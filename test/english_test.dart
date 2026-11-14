import 'package:digi_witch/data/content.dart';
import 'package:digi_witch/data/store.dart';
import 'package:digi_witch/engine/lang.dart';
import 'package:digi_witch/engine/numerology.dart';
import 'package:digi_witch/engine/tarot.dart';
import 'package:digi_witch/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// English version: content parity with Polish, and the app running in English.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Content pl, en;
  setUpAll(() async {
    pl = await Content.load();
    en = await Content.load(lang: 'en');
  });
  tearDown(() => appLang = 'pl');

  test('English content covers everything the Polish one does', () {
    expect(en.cards.keys, pl.cards.keys);
    expect(en.cards['major_13']!.name, 'Death');
    for (final i in Indicator.values) {
      expect(en.numerology[i]!.keys, pl.numerology[i]!.keys, reason: i.name);
    }
    expect(en.iching.keys, pl.iching.keys);
    for (final h in en.iching.values) {
      expect(h.lines, hasLength(6));
    }
    expect(en.dreams, hasLength(pl.dreams.length));
    expect(en.articles.map((a) => a.id), pl.articles.map((a) => a.id));
    expect(en.astro.signs.map((s) => s.name).first, 'Aries');
    expect(en.astro.today.keys, pl.astro.today.keys);
    // No Polish letters left anywhere in the English card texts.
    final polish = RegExp('[ąćęłńśźżĄĆĘŁŃŚŹŻ]');
    for (final c in en.cards.values) {
      expect(
        polish.hasMatch('${c.name}${c.upright}${c.reversed}${c.advice}'),
        isFalse,
        reason: c.id,
      );
    }
  });

  test('engine texts follow the language', () {
    appLang = 'en';
    expect(spreads.first.name, 'One card');
    expect(spreads.map((s) => s.id), [for (final s in spreads) s.id]);
    expect(
      lifePath(CalendarDate.tryCreate(1990, 7, 15)!).steps.first,
      startsWith('Date digits:'),
    );
    appLang = 'pl';
    expect(spreads.first.name, 'Jedna karta');
  });

  testWidgets('the app runs in English, also at 2x text', (t) async {
    SharedPreferences.setMockInitialValues({
      'onboarded': true,
      'language': 'en',
      'birthDate': '1990-07-15',
    });
    final store = AppStore(await SharedPreferences.getInstance());
    t.view.physicalSize = const Size(1080, 2400);
    t.view.devicePixelRatio = 2.75;
    addTearDown(t.view.reset);
    await t.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: DigiWitchApp(store: store, contents: {'pl': pl, 'en': en}),
      ),
    );
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
    // At 2x text the message of the day fills the first screen.
    await t.scrollUntilVisible(
      find.text('Cancer'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('TODAY FOR YOU'), findsOneWidget);
    expect(find.text('Cancer'), findsOneWidget);
    for (final tab in ['Stars', 'Tarot', 'Numbers', 'Dreams']) {
      await t.tap(find.text(tab).last);
      await t.pumpAndSettle();
      expect(t.takeException(), isNull, reason: tab);
    }
    expect(find.text('What did you dream last night?'), findsOneWidget);

    // Switching back to Polish in Settings takes effect at once.
    store.language = 'pl';
    await t.pumpAndSettle();
    expect(find.text('Co Ci się dziś śniło?'), findsOneWidget);
  });

  test('language follows the setting, then the phone, then English', () {
    const langs = ['pl', 'en', 'de'];
    expect(resolveLanguage('system', ['pl'], langs), 'pl');
    expect(resolveLanguage('system', ['fr'], langs), 'en');
    expect(resolveLanguage('system', ['fr', 'de', 'pl'], langs), 'de');
    expect(resolveLanguage('system', [], langs), 'en');
    expect(resolveLanguage('pl', ['de'], langs), 'pl');
    expect(resolveLanguage('uk', ['pl'], langs), 'en'); // not available yet
    expect(resolveLanguage('en', ['en'], ['pl']), 'pl');
  });

  testWidgets('a newly picked language loads on demand', (t) async {
    SharedPreferences.setMockInitialValues({'onboarded': true});
    final store = AppStore(await SharedPreferences.getInstance());
    store.language = 'pl';
    final loaded = <String>[];
    await t.pumpWidget(
      DigiWitchApp(
        store: store,
        contents: {'pl': pl},
        loadContent: (l) async {
          loaded.add(l);
          return en;
        },
      ),
    );
    await t.pumpAndSettle();
    expect(find.text('Gwiazdy'), findsOneWidget);
    store.language = 'en';
    await t.pumpAndSettle();
    expect(loaded, ['en']);
    expect(find.text('Stars'), findsOneWidget);
    store.language = 'pl';
    await t.pumpAndSettle();
    store.language = 'en';
    await t.pumpAndSettle();
    expect(loaded, ['en'], reason: 'kept after the first load');
  });
}
