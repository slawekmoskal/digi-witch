import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../data/store.dart';

/// Product configured in App Store Connect / Play Console as a non-consumable, 24,99–25 PLN.
const proProductId = 'pro_lifetime';

// Real unit IDs are injected at build time; defaults are Google's public TEST units.
const _bannerAndroid = String.fromEnvironment(
  'ADMOB_BANNER_ANDROID',
  defaultValue: 'ca-app-pub-3940256099942544/9214589741',
);
const _bannerIos = String.fromEnvironment(
  'ADMOB_BANNER_IOS',
  defaultValue: 'ca-app-pub-3940256099942544/2435281174',
);

/// Pro purchase + ad consent. Created only on real devices (main.dart); tests and web run without it.
class Monetization extends ChangeNotifier {
  final AppStore store;
  Monetization(this.store);

  final _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;
  ProductDetails?
  product; // null = store unavailable / product not configured yet
  bool canShowAds = false;
  bool privacyOptionsRequired = false;
  String? lastError;

  bool get isPro => store.isPro;

  Future<void> init() async {
    _sub = _iap.purchaseStream.listen(
      _onPurchases,
      onError: (Object e) {
        lastError = '$e';
        notifyListeners();
      },
    );
    if (await _iap.isAvailable()) {
      final r = await _iap.queryProductDetails({proProductId});
      product = r.productDetails.isEmpty ? null : r.productDetails.first;
    }
    notifyListeners();
    // Pro users never see the consent form or ads; Pro itself does not depend on ad consent.
    if (!isPro) await _gatherConsent();
  }

  Future<void> _onPurchases(List<PurchaseDetails> list) async {
    for (final p in list) {
      if (p.productID != proProductId) continue;
      if (p.status == PurchaseStatus.purchased ||
          p.status == PurchaseStatus.restored) {
        // shortcut: trusts the store's client-side result, no server receipt validation; add a backend check if piracy becomes material.
        store.isPro = true;
      } else if (p.status == PurchaseStatus.error) {
        lastError = p.error?.message;
      }
      if (p.pendingCompletePurchase) await _iap.completePurchase(p);
    }
    notifyListeners();
  }

  Future<void> buyPro() async {
    if (product == null) return;
    lastError = null;
    await _iap.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: product!),
    );
  }

  Future<void> restore() => _iap.restorePurchases();

  Future<void> _gatherConsent() async {
    final done = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () =>
          ConsentForm.loadAndShowConsentFormIfRequired((_) => done.complete()),
      (_) => done.complete(), // offline etc.: fall through to canRequestAds with cached consent
    );
    await done.future;
    await _refreshConsent();
  }

  Future<void> _refreshConsent() async {
    canShowAds = await ConsentInformation.instance.canRequestAds();
    privacyOptionsRequired =
        await ConsentInformation.instance
            .getPrivacyOptionsRequirementStatus() ==
        PrivacyOptionsRequirementStatus.required;
    if (canShowAds) {
      // Calm ad content; not child-directed (adult audience), so no child/age-restricted tag.
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(maxAdContentRating: MaxAdContentRating.t),
      );
      await MobileAds.instance.initialize();
    }
    notifyListeners();
  }

  Future<void> showPrivacyOptions() async {
    await ConsentForm.showPrivacyOptionsForm((_) {});
    await _refreshConsent();
  }

  String get bannerUnitId => Platform.isIOS ? _bannerIos : _bannerAndroid;

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

/// One calm anchored banner. Nothing is rendered for Pro, without consent, or when no ad loads.
class AdBanner extends StatefulWidget {
  final Monetization m;
  const AdBanner(this.m, {super.key});
  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    // Small fixed 320x50 banner: least intrusive standard size.
    _ad = BannerAd(
      adUnitId: widget.m.bannerUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _loaded = true),
        onAdFailedToLoad: (ad, _) => ad.dispose(),
      ),
    )..load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || widget.m.isPro || _ad == null) {
      return const SizedBox.shrink();
    }
    return SafeArea(
      top: false,
      child: SizedBox(
        width: _ad!.size.width.toDouble(),
        height: _ad!.size.height.toDouble(),
        child: AdWidget(ad: _ad!),
      ),
    );
  }
}

bool get monetizationSupported =>
    !kIsWeb && (Platform.isAndroid || Platform.isIOS);
