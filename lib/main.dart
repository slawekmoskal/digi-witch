import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'native_tabs.dart';

import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/content.dart';
import 'data/store.dart';
import 'l10n/app_localizations.dart';
import 'monetization/monetization.dart';
import 'reminders.dart';
import 'ui/astro_screens.dart';
import 'engine/lang.dart';
import 'engine/numerology.dart' show CalendarDate;
import 'home_widget_sync.dart';
import 'ui/library_screen.dart';
import 'ui/numerology_screen.dart';
import 'ui/tarot_screen.dart';
import 'ui/theme.dart';
import 'ui/today_screen.dart';
import 'ui/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks([
      'Cormorant Garamond',
    ], await rootBundle.loadString('assets/fonts/OFL.txt'));
  });
  final store = await AppStore.open();
  // Only the language in use is loaded; another one loads when picked in Settings.
  final lang = resolveLanguage(store.language, _phone, appLangs);
  final content = await Content.load(lang: lang);
  final m = monetizationSupported ? Monetization(store) : null;
  runApp(
    DigiWitchApp(
      store: store,
      contents: {lang: content},
      loadContent: (l) => Content.load(lang: l),
      monetization: m,
    ),
  );
  retryPendingHomeWidgetClear(
    store,
  ); // also on the onboarding screen, where HomeShell never runs
  if (store.onboarded) {
    m?.init(); // first run: started from onboarding, so consent never covers it
  }
}

/// The phone's preferred languages, most preferred first (on Android 13+ and iOS this
/// is the per-app language when the user has set one in system settings).
List<String> get _phone => [
  for (final l in PlatformDispatcher.instance.locales) l.languageCode,
];

class DigiWitchApp extends StatefulWidget {
  final AppStore store;

  /// Content per language code. With [loadContent] any of [appLangs] can be picked and is
  /// loaded on first use; without it (widget tests) only the languages given here.
  final Map<String, Content> contents;
  final Future<Content> Function(String lang)? loadContent;
  final Monetization? monetization;
  const DigiWitchApp({
    super.key,
    required this.store,
    required this.contents,
    this.loadContent,
    this.monetization,
  });

  @override
  State<DigiWitchApp> createState() => _DigiWitchAppState();
}

class _DigiWitchAppState extends State<DigiWitchApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // The phone's language changed while the app was open: follow it at once.
  @override
  void didChangeLocales(List<Locale>? locales) => setState(() {});

  late final _contents = {...widget.contents};
  late var _shown = _contents.keys.first;
  final _loading = <String>{};

  void _load(String lang) {
    if (!_loading.add(lang)) return;
    widget.loadContent!(lang).then(
      (c) {
        if (mounted) setState(() => _contents[lang] = c);
      },
      onError: (Object e) {
        _loading.remove(
          lang,
        ); // stays on the shown language; a later pick retries
        debugPrint('content $lang: $e');
      },
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Listenable.merge([
      widget.store,
      widget.monetization,
      nativeTabs,
    ]),
    builder: (context, _) {
      final available = widget.loadContent == null ? _contents.keys : appLangs;
      final wanted = resolveLanguage(widget.store.language, _phone, available);
      // Until a newly picked language has loaded, the current one stays on screen.
      if (_contents.containsKey(wanted)) {
        _shown = wanted;
      } else {
        _load(wanted);
      }
      final lang = _shown;
      appLang =
          lang; // texts built outside the widget tree follow the same language
      return AppScope(
        store: widget.store,
        content: _contents[lang]!,
        monetization: widget.monetization,
        child: MaterialApp(
          onGenerateTitle: (c) => AppLocalizations.of(c).appTitle,
          debugShowCheckedModeBanner: false,
          theme: buildTheme(Brightness.light),
          darkTheme: buildTheme(Brightness.dark),
          themeMode: ThemeMode.values.byName(widget.store.themeMode),
          locale: Locale(lang),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          navigatorKey: _navigator,
          navigatorObservers: [_backWatch],
          // The rail lives outside the navigator, so it stays when a screen is pushed.
          builder: (context, child) => _Frame(
            rail: widget.store.onboarded && hasRail(context),
            child: child!,
          ),
          home: widget.store.onboarded ? const HomeShell() : const Onboarding(),
        ),
      );
    },
  );
}

final _navigator = GlobalKey<NavigatorState>();

/// Whether a screen is open above the tabs (the rail then shows a back button).
final _canGoBack = ValueNotifier<bool>(false);
final _backWatch = _BackWatch();

class _BackWatch extends NavigatorObserver {
  // After the frame: routes change while the tree is building.
  void _update() => WidgetsBinding.instance.addPostFrameCallback(
    (_) => _canGoBack.value = navigator?.canPop() ?? false,
  );
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _update();
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => _update();
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _update();
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      _update();
}

List<(IconData, String)> _tabs(AppLocalizations l) => [
  (Icons.auto_awesome_outlined, l.tabStars),
  (Icons.style_outlined, l.tabTarot),
  (Icons.wb_sunny_outlined, l.tabToday),
  (Icons.tag, l.tabNumerology),
  (Icons.nights_stay_outlined, l.tabDreams),
];

/// Everything the app draws sits between the side insets (a notch in landscape, the
/// system's vertical bar on iPhone Duo); only the background runs under them. In wide
/// windows the tabs are a rail on the right of the pages, and it stays when a screen is
/// pushed, with a back button above the tabs.
class _Frame extends StatelessWidget {
  final Widget child;
  final bool rail;
  const _Frame({required this.child, required this.rail});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final mq = MediaQuery.of(context);
    final pad = mq.padding;
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: EdgeInsets.only(left: pad.left, right: pad.right),
        // Inside, the window is simply narrower and has no side insets.
        child: ValueListenableBuilder<double>(
          valueListenable: nativeBarInset,
          builder: (context, bar, _) => MediaQuery(
            data: mq.copyWith(
              // The system's tab bar floats over the page: keep content clear of it
              // (the keyboard covers the bar, so not then).
              padding: pad.copyWith(
                left: 0,
                right: 0,
                bottom: mq.viewInsets.bottom > 0
                    ? pad.bottom
                    : max(pad.bottom, bar),
              ),
              size: Size(mq.size.width - pad.horizontal, mq.size.height),
            ),
            child: !rail ? child : _withRail(cs),
          ),
        ),
      ),
    );
  }

  Widget _withRail(ColorScheme cs) => Row(
    children: [
      Expanded(child: child),
      SizedBox(
        width: railWidth,
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(8, 12, 8, 12),
          // At the bottom, where system apps keep their tabs.
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              reverse: true,
              clipBehavior: Clip.none,
              child: ListenableBuilder(
                listenable: Listenable.merge([homeTab, _canGoBack]),
                builder: (context, _) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_canGoBack.value) ...[
                      Semantics(
                        button: true,
                        label: MaterialLocalizations.of(context)
                            .backButtonTooltip,
                        child: Material(
                          color: cs.surfaceContainerHighest,
                          shape: const CircleBorder(),
                          elevation: 2,
                          child: InkWell(
                            key: const Key('railBack'),
                            customBorder: const CircleBorder(),
                            onTap: () => _navigator.currentState?.maybePop(),
                            child: SizedBox.square(
                              dimension: 56,
                              child: Icon(
                                Icons.chevron_left,
                                size: 32,
                                color: cs.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                    FloatingNav(
                      index: homeTab.value,
                      vertical: true,
                      // A dot on Today until the card of the day is turned.
                      centreDot: !context.store.cardRevealed(
                        CalendarDate.fromDateTime(DateTime.now()),
                      ),
                      onSelect: (i) {
                        // From a pushed screen a tab leads back to the tabs.
                        _navigator.currentState?.popUntil((r) => r.isFirst);
                        homeTab.value = i;
                      },
                      items: _tabs(context.l),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

/// First run on one screen: what the app is, an optional birth date, start. With the
/// date the first Today already has the horoscope; without it, the card of the day.
class Onboarding extends StatefulWidget {
  const Onboarding({super.key});
  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final _date = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    // The system's bar exists from the start; hide it until the app proper begins.
    attachNativeTabs(
      onSelect: (_) {},
      onBack: () {},
    ).then((_) => hideNativeTabs());
  }

  @override
  void dispose() {
    _date.dispose();
    super.dispose();
  }

  void _start() {
    final l = context.l;
    final s = context.store;
    if (_date.text.isNotEmpty) {
      final d = parseUserDate(_date.text);
      final today = CalendarDate.fromDateTime(DateTime.now());
      setState(
        () => _error = d == null
            ? l.dateInvalid
            : d.compareTo(today) > 0
            ? l.dateFuture
            : null,
      );
      if (_error != null) return;
      s.saveProfile(d, null);
    }
    s.onboarded = true;
    context.monetization?.init();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final t = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 24),
            Semantics(
              header: true,
              child: Text(l.appTitle, style: t.headlineMedium),
            ),
            const SizedBox(height: 16),
            Text(l.onboardWhat),
            const SizedBox(height: 20),
            TextField(
              controller: _date,
              keyboardType: TextInputType.number,
              inputFormatters: [DateMaskFormatter()],
              onSubmitted: (_) => _start(),
              decoration: InputDecoration(
                labelText: l.birthDate,
                hintText: l.dateHint,
                helperText: l.onboardBirthHint,
                helperMaxLines: 3,
                errorText: _error,
                prefixIcon: const Icon(Icons.cake_outlined),
              ),
            ),
            const SizedBox(height: 12),
            Text(l.onboardPrivacy),
            const SizedBox(height: 20),
            FilledButton(onPressed: _start, child: Text(l.start)),
            const SizedBox(height: 20),
            Text(l.onboardNot, style: t.bodySmall),
            const SizedBox(height: 8),
            Text(l.onboardAdults, style: t.bodySmall),
          ],
        ),
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int get _i => homeTab.value;

  // Every tab has its own scroll position; a tab that is switched to starts at the top.
  final _scrolls = List.generate(5, (_) => ScrollController());
  var _shownTab = 2;

  void _onTab() {
    if (_i != _shownTab) {
      _shownTab = _i;
      final c = _scrolls[_i];
      if (c.hasClients) c.jumpTo(0);
    }
    setState(() {});
  }

  // iPhone Duo: the system shows the tabs; tell it what the app shows.
  void _toNative() {
    if (!mounted) return;
    updateNativeTabs(
      index: _i,
      titles: [for (final t in _tabs(context.l)) t.$2],
      canGoBack: _canGoBack.value,
      back: MaterialLocalizations.of(context).backButtonTooltip,
    );
  }

  // Card turned, profile changed, data deleted → the home-screen widget follows.
  late final AppStore _store = context.store;
  void _syncWidget() {
    if (mounted) syncHomeWidget(context);
  }

  StreamSubscription<Uri?>? _taps;

  // A widget opens its own place: the full horoscope, the card of the day, the Moon calendar.
  void _openFromWidget(String target) {
    if (!mounted) return;
    Navigator.of(context).popUntil((r) => r.isFirst);
    switch (target) {
      case 'card':
        homeTab.value = 2; // the card is the first thing on Today
      case 'horoscope':
        homeTab.value = _store.birthDate == null ? 2 : 0;
      case 'moon':
        pushScreen(context, const MoonCalendarScreen());
    }
  }

  @override
  void dispose() {
    _taps?.cancel();
    _store.removeListener(_syncWidget);
    homeTab.removeListener(_onTab);
    for (final c in _scrolls) {
      c.dispose();
    }
    nativeTabs.removeListener(_onTab);
    _canGoBack.removeListener(_toNative);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    homeTab.value = 2; // always start on Today
    homeTab.addListener(_onTab);
    nativeTabs.addListener(
      _onTab,
    ); // the bottom bar goes when the system shows the tabs
    _canGoBack.addListener(_toNative);
    attachNativeTabs(
      onSelect: (i) {
        _navigator.currentState?.popUntil((r) => r.isFirst);
        homeTab.value = i;
      },
      onBack: () => _navigator.currentState?.maybePop(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _store.addListener(_syncWidget);
      _syncWidget();
      _taps = listenWidgetTaps(_openFromWidget);
      if (context.store.moonReminders) {
        Reminders.rescheduleMoon(moonReminderEvents(context.l));
      }
      final m = context.store.reminderMinutes;
      if (m != null) {
        Reminders.reschedule(dailyReminderEvents(context, m));
      }
    });
  }

  static const _pages = <Widget>[
    StarsScreen(),
    TarotScreen(),
    TodayScreen(),
    NumerologyScreen(),
    DreamScreen(tab: true),
  ];

  // Keeps the tabs' state when the window crosses the wide breakpoint (fold / unfold).
  final _stackKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    _toNative(); // also after a language change
    // The tabs are in the rail beside the pages, or in the system's own bar.
    final rail = hasRail(context) || nativeTabs.value;
    final m = context.monetization;
    return ListenableBuilder(
      listenable: Listenable.merge([?m]),
      builder: (context, _) {
        final ads = m != null && !m.isPro && m.canShowAds;
        // The system's bar floats over the page and takes no room in the layout. With no
        // ad there is nothing at the bottom, so the page gets the whole screen and clears
        // the bar with its own padding (a Scaffold with a bottom bar drops that padding).
        final bare = nativeTabs.value && !ads;
        return Scaffold(
          extendBody: !rail, // pages scroll under the floating bar
          body: IndexedStack(
            key: _stackKey,
            index: _i,
            children: [
              for (var k = 0; k < _pages.length; k++)
                PrimaryScrollController(
                  controller: _scrolls[k],
                  child: _pages[k],
                ),
            ],
          ),
          bottomNavigationBar: bare
              ? null
              : _BottomArea(
                  nav: rail
                      ? null
                      : FloatingNav(
                          index: _i,
                          // A dot on Today until the card of the day is turned.
                          centreDot: !context.store.cardRevealed(
                            CalendarDate.fromDateTime(DateTime.now()),
                          ),
                          onSelect: (i) => homeTab.value = i,
                          items: _tabs(l),
                        ),
                ),
        );
      },
    );
  }
}

/// Ad banner (if any) above the nav bar. With an ad, the whole area is an opaque band so
/// page content ends above it instead of showing through around the banner.
class _BottomArea extends StatelessWidget {
  final Widget? nav;
  const _BottomArea({required this.nav});
  @override
  Widget build(BuildContext context) {
    final m = context.monetization;
    // The column keeps the bar at its own height; alone it would fill the screen.
    if (m == null) {
      return Column(mainAxisSize: MainAxisSize.min, children: [?nav]);
    }
    return ListenableBuilder(
      listenable: m,
      builder: (context, _) {
        // No ads for Pro; the journal is a full-screen route, so it never shows this bar.
        final ads = !m.isPro && m.canShowAds;
        return ColoredBox(
          color: ads
              ? Theme.of(context).scaffoldBackgroundColor
              : Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // The system's bar, when it is at the bottom, is not in this layout.
              if (ads)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: nativeTabs.value
                        ? MediaQuery.paddingOf(context).bottom
                        : 0,
                  ),
                  child: AdBanner(m),
                ),
              ?nav,
            ],
          ),
        );
      },
    );
  }
}

/// Floating rounded bar with side margins; the middle item (Today) is a gold disc with the
/// app's card-and-star emblem, standing out above the bar.
class FloatingNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onSelect;
  final List<(IconData, String)> items;
  final bool centreDot;

  /// Side rail (wide windows) instead of the bottom bar.
  final bool vertical;
  const FloatingNav({
    super.key,
    required this.index,
    required this.onSelect,
    required this.items,
    this.centreDot = false,
    this.vertical = false,
  });

  /// How far the centre disc rises above the bar.
  static const _rise = 18.0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final light = Theme.of(context).brightness == Brightness.light;
    // iOS: Liquid Glass look (blurred, translucent, bright rim) over scrolling content.
    // shortcut: Flutter imitation (blur + tint), not Apple's native material; native needs a UIKit platform view.
    final glass = Theme.of(context).platform == TargetPlatform.iOS;
    final on = glass
        ? (light ? cs.primary : cs.onSurface)
        : (light ? cs.onPrimary : cs.onSurface);
    final mid = items.length ~/ 2;
    final radius = BorderRadius.circular(35);
    final shadow = [
      BoxShadow(
        color: Colors.black.withValues(alpha: glass ? 0.12 : 0.18),
        blurRadius: 18,
        offset: const Offset(0, 6),
      ),
    ];
    Widget tap(int i, Widget child) => Semantics(
      button: true,
      selected: i == index,
      child: InkResponse(onTap: () => onSelect(i), radius: 36, child: child),
    );
    Widget centre() => Semantics(
      button: true,
      selected: index == mid,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onSelect(mid),
        child: _centre(context, items[mid], index == mid, on),
      ),
    );
    // The bar itself: glass on iOS, solid elsewhere.
    Widget shell(Widget child, BoxConstraints box, EdgeInsets pad) => glass
        ? DecoratedBox(
            decoration: BoxDecoration(borderRadius: radius, boxShadow: shadow),
            child: ClipRRect(
              borderRadius: radius,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  constraints: box,
                  padding: pad,
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: light
                          ? [
                              Colors.white.withValues(alpha: 0.62),
                              Colors.white.withValues(alpha: 0.34),
                            ]
                          : [
                              Colors.white.withValues(alpha: 0.16),
                              Colors.white.withValues(alpha: 0.06),
                            ],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(
                        alpha: light ? 0.75 : 0.22,
                      ),
                    ),
                  ),
                  child: child,
                ),
              ),
            ),
          )
        : Container(
            constraints: box,
            padding: pad,
            decoration: BoxDecoration(
              color: light ? cs.primary : cs.surfaceContainerHighest,
              borderRadius: radius,
              boxShadow: shadow,
            ),
            child: child,
          );

    if (vertical) {
      // Rail: the capsule only; the shell around it places and scrolls it.
      return MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.3,
        child: shell(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < items.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: i == mid
                      ? centre()
                      : tap(
                          i,
                          SizedBox(
                            width: 64,
                            child: _item(context, items[i], i == index, on),
                          ),
                        ),
                ),
            ],
          ),
          const BoxConstraints(),
          const EdgeInsets.symmetric(vertical: 8),
        ),
      );
    }

    final row = Row(
      children: [
        for (var i = 0; i < items.length; i++)
          Expanded(
            // The centre slot stays empty: its button is drawn above the bar.
            child: i == mid
                ? const SizedBox()
                : tap(i, _item(context, items[i], i == index, on)),
          ),
      ],
    );
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(12, 6, 12, 10),
      child: MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.3,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: _rise),
              child: shell(
                row,
                const BoxConstraints(minHeight: 70),
                const EdgeInsets.symmetric(vertical: 6),
              ),
            ),
            centre(),
          ],
        ),
      ),
    );
  }

  Widget _item(BuildContext c, (IconData, String) it, bool sel, Color on) {
    final color = sel ? on : on.withValues(alpha: 0.78);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(it.$1, color: color, size: 24),
        const SizedBox(height: 2),
        Text(
          it.$2,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11.5,
            color: color,
            fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(top: 3),
          width: sel ? 18 : 0,
          height: 2.5,
          decoration: BoxDecoration(
            color: Theme.of(c).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _centre(BuildContext c, (IconData, String) it, bool sel, Color on) {
    final cs = Theme.of(c).colorScheme;
    return SizedBox(
      width: vertical ? 64 : 84,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Badge(
            isLabelVisible: centreDot,
            smallSize: 12,
            backgroundColor: const Color(0xFFE8544E),
            child: AnimatedScale(
              scale: sel ? 1 : 0.92,
              duration: const Duration(milliseconds: 200),
              child: Container(
                // The rail is a size smaller than the bottom bar.
                width: vertical ? 54 : 66,
                height: vertical ? 54 : 66,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFF1D98A),
                      Color(0xFFC9A44C),
                      Color(0xFFA9832F),
                    ],
                  ),
                  border: Border.all(
                    color: Theme.of(c).scaffoldBackgroundColor,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cs.tertiary.withValues(alpha: sel ? 0.55 : 0.25),
                      blurRadius: sel ? 16 : 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const CustomPaint(painter: _EmblemPainter()),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            it.$2,
            style: TextStyle(
              fontSize: 11.5,
              color: sel ? on : on.withValues(alpha: 0.78),
              fontWeight: sel ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// The app icon's emblem: a tarot card outline with a star and a spark.
class _EmblemPainter extends CustomPainter {
  const _EmblemPainter();
  @override
  void paint(Canvas canvas, Size s) {
    const ink = Color(0xFF2B2140);
    final c = s.center(Offset.zero);
    final card = RRect.fromRectAndRadius(
      Rect.fromCenter(center: c, width: s.width * 0.36, height: s.width * 0.56),
      Radius.circular(s.width * 0.06),
    );
    canvas.drawRRect(
      card,
      Paint()
        ..color = ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = s.width * 0.045,
    );
    final fill = Paint()..color = ink;
    canvas.drawPath(
      starPath(c.translate(0, s.width * 0.04), s.width * 0.12),
      fill,
    );
    canvas.drawPath(
      starPath(c.translate(s.width * 0.08, -s.width * 0.14), s.width * 0.04),
      fill,
    );
  }

  @override
  bool shouldRepaint(_EmblemPainter old) => false;
}
