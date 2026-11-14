import 'dart:io';

import 'package:digi_witch/data/content.dart';
import 'package:digi_witch/data/store.dart';
import 'package:digi_witch/engine/lang.dart';
import 'package:digi_witch/engine/numerology.dart';
import 'package:digi_witch/engine/tarot.dart';
import 'package:digi_witch/l10n/app_localizations.dart';
import 'package:digi_witch/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Every language in Settings: content parity with Polish, and the app running in it.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final others = appLangs.where((l) => l != 'pl').toList();
  late Content pl;
  final content = <String, Content>{};
  setUpAll(() async {
    pl = await Content.load();
    for (final l in others) {
      content[l] = await Content.load(lang: l);
    }
  });
  tearDown(() => appLang = 'pl');

  for (final lang in others) {
    test('$lang content covers everything the Polish one does', () {
      final c = content[lang]!;
      expect(c.cards.keys, pl.cards.keys);
      for (final i in Indicator.values) {
        expect(c.numerology[i]!.keys, pl.numerology[i]!.keys, reason: i.name);
      }
      expect(c.iching.keys, pl.iching.keys);
      for (final h in c.iching.values) {
        expect(h.lines, hasLength(6));
      }
      expect(c.dreams, hasLength(pl.dreams.length));
      expect(c.articles.map((a) => a.id), pl.articles.map((a) => a.id));
      expect(c.astro.today.keys, pl.astro.today.keys);
      expect(c.astro.signs, hasLength(12));
      // Not Polish, and not left in English either.
      final polish = RegExp('[ąćęłńśźżĄĆĘŁŃŚŹŻ]');
      final en = content['en']!;
      for (final card in c.cards.values) {
        expect(
          polish.hasMatch('${card.name}${card.upright}${card.advice}'),
          isFalse,
          reason: card.id,
        );
        if (lang != 'en') {
          expect(card.upright, isNot(en.cards[card.id]!.upright));
        }
      }
    });

    test('$lang engine texts are translated', () {
      appLang = lang;
      final names = spreads.map((s) => s.name).toList();
      final steps = lifePath(CalendarDate.tryCreate(1990, 7, 15)!).steps.first;
      appLang = 'en';
      if (lang != 'en') {
        expect(names, isNot(spreads.map((s) => s.name).toList()));
        expect(
          steps,
          isNot(lifePath(CalendarDate.tryCreate(1990, 7, 15)!).steps.first),
        );
      }
    });

    testWidgets('the app runs in $lang, also at 2x text', (t) async {
      SharedPreferences.setMockInitialValues({
        'onboarded': true,
        'language': lang,
        'birthDate': '1990-07-15',
      });
      final store = AppStore(await SharedPreferences.getInstance());
      t.view.physicalSize = const Size(1080, 2400);
      t.view.devicePixelRatio = 2.75;
      addTearDown(t.view.reset);
      await t.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: DigiWitchApp(
            store: store,
            contents: {'pl': pl, lang: content[lang]!},
          ),
        ),
      );
      await t.pumpAndSettle();
      expect(t.takeException(), isNull);
      final l = AppLocalizations.of(t.element(find.byType(Scaffold).first));
      expect(l.localeName, lang);
      for (final tab in [
        l.tabStars,
        l.tabTarot,
        l.tabNumerology,
        l.tabDreams,
      ]) {
        await t.tap(find.text(tab).last);
        await t.pumpAndSettle();
        expect(t.takeException(), isNull, reason: '$lang $tab');
      }
      expect(find.text(l.dreamAsk), findsOneWidget);
    });
  }

  test('iOS and Android declare exactly the languages in Settings', () {
    final plist = File('ios/Runner/Info.plist').readAsStringSync();
    final ios = plist.split('<key>CFBundleLocalizations</key>')[1];
    final iosLangs = RegExp(r'<string>(\w+)</string>')
        .allMatches(ios.substring(0, ios.indexOf('</array>')))
        .map((m) => m[1]);
    expect(iosLangs, appLangs);
    final android = RegExp(r'android:name="(\w+)"')
        .allMatches(
          File('android/app/src/main/res/xml/locales_config.xml')
              .readAsStringSync(),
        )
        .map((m) => m[1]);
    expect(android, appLangs);
  });
}
