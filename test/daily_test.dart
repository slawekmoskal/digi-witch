import 'package:digi_witch/data/content.dart';
import 'package:digi_witch/data/store.dart';
import 'package:digi_witch/engine/astro.dart';
import 'package:digi_witch/engine/daily.dart';
import 'package:digi_witch/engine/numerology.dart';
import 'package:digi_witch/l10n/app_localizations.dart';
import 'package:digi_witch/main.dart';
import 'package:digi_witch/ui/astro_screens.dart' show cheerFor, hasGoodNews;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The personal daily reading: meters, text rotation, and the card on Today.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Content pl, en;
  setUpAll(() async {
    pl = await Content.load();
    en = await Content.load(lang: 'en');
  });

  test('meters stay within 1–5 and follow their inputs', () {
    for (var sun = 0; sun < 12; sun++) {
      for (var moon = 0; moon < 12; moon++) {
        for (var phase = 0; phase < 8; phase++) {
          for (var n = 1; n <= 9; n++) {
            final m = dayMeters(
              sun: sun,
              moon: moon,
              phase: phase,
              dayNumber: n,
            );
            for (final v in [m.love, m.work, m.energy]) {
              expect(v, inInclusiveRange(1, 5));
            }
          }
        }
      }
    }
    // Aries (fire) with the Moon in Leo (fire), full Moon, day of results.
    final good = dayMeters(sun: 0, moon: 4, phase: 4, dayNumber: 8);
    // Aries with the Moon in Cancer (water), new Moon, day of reflection.
    final hard = dayMeters(sun: 0, moon: 3, phase: 0, dayNumber: 7);
    expect(good.energy, greaterThan(hard.energy));
    expect(good.work, greaterThan(hard.work));
    expect(good.love, greaterThan(hard.love));
    expect(meterLevel(2), 'low');
    expect(meterLevel(3), 'mid');
    expect(meterLevel(4), 'high');
  });

  test('Polish has every text the reading can ask for; English not yet', () {
    final d = pl.daily!;
    expect(en.daily, isNull);
    expect(d.mood.keys, signIds);
    for (final s in d.mood.values) {
      expect(s.keys.toSet(), {'same', 'supportive', 'neutral', 'tense'});
    }
    for (var n = 1; n <= 9; n++) {
      expect(d.events[n], hasLength(3));
      expect(d.advice[n], hasLength(3));
    }
    for (final area in [d.love, d.work, d.energy]) {
      expect(area.keys, ['low', 'mid', 'high']);
    }
  });

  test('the same day number shows another text when it returns', () {
    final a = CalendarDate.tryCreate(2026, 11, 11)!;
    final b = CalendarDate.tryCreate(2026, 11, 20)!; // nine days later
    expect(nineDayVariant(a, 3), isNot(nineDayVariant(b, 3)));
    expect(dayIndex(b) - dayIndex(a), 9);
  });

  testWidgets('Today shows the reading with meters', (t) async {
    SharedPreferences.setMockInitialValues({
      'onboarded': true,
      'language': 'pl',
      'birthDate': '1990-07-15',
    });
    final store = AppStore(await SharedPreferences.getInstance());
    t.view.physicalSize = const Size(1080, 2400);
    t.view.devicePixelRatio = 2.75;
    addTearDown(t.view.reset);
    await t.pumpWidget(DigiWitchApp(store: store, contents: {'pl': pl}));
    await t.pumpAndSettle();
    // The three areas stand in the day's message at the top, once.
    for (final area in ['Miłość', 'Praca', 'Energia']) {
      expect(find.text(area), findsOneWidget);
      // Screen readers get "Miłość: 3 z 5" instead of five dots.
      final spoken = RegExp('^$area: [1-5] z 5\$');
      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && spoken.hasMatch(w.properties.label ?? ''),
        ),
        findsOneWidget,
      );
    }
    // The horoscope follows the daily ritual.
    await t.scrollUntilVisible(
      find.text('JAK MOŻESZ SIĘ DZIŚ CZUĆ'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('JAK MOŻESZ SIĘ DZIŚ CZUĆ'), findsOneWidget);
    // Today is the short read; what may happen is in Stars.
    expect(find.text('CO MOŻE CIĘ DZIŚ SPOTKAĆ'), findsNothing);
    expect(find.text('RADA NA DZIŚ'), findsOneWidget);
    expect(t.takeException(), isNull);
  });

  testWidgets('a language without the reading keeps the older horoscope', (
    t,
  ) async {
    SharedPreferences.setMockInitialValues({
      'onboarded': true,
      'language': 'en',
      'birthDate': '1990-07-15',
    });
    final store = AppStore(await SharedPreferences.getInstance());
    await t.pumpWidget(
      DigiWitchApp(store: store, contents: {'pl': pl, 'en': en}),
    );
    await t.pumpAndSettle();
    // The horoscope follows the daily ritual.
    await t.scrollUntilVisible(
      find.text('TODAY'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('TODAY'), findsOneWidget);
    expect(find.text('HOW YOU MAY FEEL TODAY'), findsNothing);
    // The dots need no translated text, so they stay (in the day's message at the top).
    await t.drag(find.byType(Scrollable).first, const Offset(0, 5000));
    await t.pumpAndSettle();
    for (final area in ['Love', 'Work', 'Energy']) {
      expect(find.text(area), findsOneWidget);
    }
  });

  test('day headline: strongest area, else an improvement, else the Moon', () {
    final l = lookupAppLocalizations(const Locale('pl'));
    const flat = (love: 3, work: 3, energy: 3);
    String c(
      int love,
      int work,
      int energy, [
      DayMeters before = flat,
      int phase = 4,
      int day = 0,
    ]) => cheerFor(
      l,
      (love: love, work: work, energy: energy),
      before,
      phase,
      day,
    );
    expect(c(4, 4, 5), l.cheerAll);
    expect(c(5, 2, 1), l.cheerLove);
    expect(c(3, 5, 4), l.cheerWork); // the strongest area wins
    expect(c(4, 4, 2), l.cheerLove); // ties: love first
    expect(c(2, 3, 4), l.cheerEnergy);
    // Low days: what got better since yesterday.
    expect(c(2, 2, 2, (love: 1, work: 2, energy: 1)), l.cheerUpLove);
    expect(c(2, 3, 2, (love: 2, work: 1, energy: 2)), l.cheerUpWork);
    // Nothing better: the Moon phase always has something good to say.
    expect(c(2, 2, 2, flat, 0), l.cheerNewMoon);
    expect(c(2, 2, 2, flat, 2), l.cheerWaxing);
    expect(c(2, 2, 2, flat, 4), l.cheerFullMoon);
    expect(c(3, 1, 2, flat, 6), l.cheerWaning);
    // A phase lasts for days: the wording changes from one day to the next.
    expect(c(2, 2, 2, flat, 2, 1), l.cheerWaxing2);
    expect(c(2, 2, 2, flat, 2, 2), l.cheerWaxing3);
  });

  test(
    'good news from the reading: an area at 4–5 or one better than yesterday',
    () {
      const flat = (love: 3, work: 3, energy: 3);
      expect(hasGoodNews((love: 4, work: 1, energy: 1), flat), isTrue);
      expect(
        hasGoodNews(
          (love: 2, work: 3, energy: 3),
          (love: 1, work: 3, energy: 3),
        ),
        isTrue,
      );
      expect(hasGoodNews((love: 2, work: 2, energy: 2), flat), isFalse);
      expect(hasGoodNews(flat, flat), isFalse);
    },
  );

  test('daily messages: no repeat within a pass, a new order each pass', () {
    const n = 180;
    for (final pass in [0, 1, 115, 116]) {
      final seen = {for (var k = 0; k < n; k++) messageIndex(pass * n + k, n)};
      expect(seen, hasLength(n), reason: 'pass $pass shows every message once');
    }
    expect([
      for (var k = 0; k < 5; k++) messageIndex(115 * n + k, n),
    ], isNot([for (var k = 0; k < 5; k++) messageIndex(116 * n + k, n)]));
    // The kind of message changes every day; small steps lead, noticing good things
    // comes about once a week.
    String kind(int d) => messagePattern[messageIndex(d, n) % 36];
    for (var d = 115 * n; d < 115 * n + n - 1; d++) {
      expect(kind(d), isNot(kind(d + 1)), reason: 'day $d');
    }
    final month = [for (var d = 115 * n; d < 115 * n + 36; d++) kind(d)];
    expect(month.where((k) => k == 'K'), hasLength(9));
    expect(month.where((k) => k == 'D'), hasLength(6));
    // A pool that shares a factor with the step still shows everything.
    expect({
      for (var k = 0; k < 22; k++) messageIndex(22 + k, 22),
    }, hasLength(22));
  });

  test(
    'daily messages fit the widgets: 180 per language, max 70 chars',
    () async {
      for (final lang in [
        'pl',
        'en',
        'de',
        'fr',
        'es',
        'uk',
        'it',
        'pt',
        'nl',
      ]) {
        final m = (await Content.load(lang: lang)).messages;
        expect(m, hasLength(180), reason: lang);
        expect(m.toSet(), hasLength(180), reason: '$lang: no duplicates');
        expect(m.where((x) => x.runes.length > 70), isEmpty, reason: lang);
      }
    },
  );
}
