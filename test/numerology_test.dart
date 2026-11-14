import 'dart:convert';
import 'dart:io';

import 'package:digi_witch/engine/numerology.dart';
import 'package:flutter_test/flutter_test.dart';

/// Expectations come from tool/expected_numerology.py (independent oracle).
void main() {
  final cases = jsonDecode(
    File('test/fixtures/numerology_cases.json').readAsStringSync(),
  );

  group('dates (oracle)', () {
    for (final c in cases['dates']) {
      test(c['date'], () {
        final d = CalendarDate.tryParse(c['date'])!;
        expect(lifePath(d).value, c['lifePath']);
        expect(birthDay(d).value, c['birthDay']);
        expect(personalYear(d, 2026).value, c['personalYear2026']);
      });
    }
  });

  group('names (oracle)', () {
    for (final c in cases['names']) {
      test(c['name'], () {
        final n = normalizeName(c['name']);
        expect(n.isValid, isTrue);
        expect(expression(n).value, c['expression']);
        expect(soulUrge(n).value, c['soulUrge']);
        expect(personality(n).value, c['personality']);
      });
    }
  });

  test('school difference is real: 1950-01-04 is 2 here, 11 when reducing parts separately', () {
    final c = (cases['dates'] as List).firstWhere(
      (c) => c['date'] == '1950-01-04',
    );
    expect(c['lifePathSeparateSchool'], 11);
    expect(lifePath(CalendarDate.tryParse('1950-01-04')!).value, 2);
  });

  test('invalid and leap dates', () {
    expect(CalendarDate.tryCreate(2023, 2, 29), isNull);
    expect(CalendarDate.tryCreate(1900, 2, 29), isNull);
    expect(CalendarDate.tryCreate(2000, 2, 29), isNotNull);
    expect(CalendarDate.tryCreate(2024, 4, 31), isNull);
    expect(CalendarDate.tryParse('1990-7-15'), isNull);
  });

  test('Ł is mapped explicitly, separators ignored, original kept', () {
    final n = normalizeName("Łucja Ż-ó'ł");
    expect(n.letters.join(), 'LUCJAZOL');
    expect(n.original, "Łucja Ż-ó'ł");
  });

  test('unsupported alphabet is reported, never dropped', () {
    final n = normalizeName('Yıldız');
    expect(n.isValid, isFalse);
    expect(n.unsupported, {'ı'});
    expect(() => expression(n), throwsArgumentError);
    expect(normalizeName('Иван').unsupported.length, 4);
  });

  test('German, French and Spanish letters use their plain spelling', () {
    expect(normalizeName('Jürgen Straße').letters.join(), 'JURGENSTRASSE');
    expect(normalizeName('François Lœw').letters.join(), 'FRANCOISLOEW');
    expect(normalizeName('Iñés Peña').letters.join(), 'INESPENA');
    // Italian, Brazilian Portuguese and Dutch.
    expect(
      normalizeName('Niccolò Perché Più').letters.join(),
      'NICCOLOPERCHEPIU',
    );
    expect(
      normalizeName('Ítalo Gonçalves Pôr Ângela Mãe Põe Lúcia').letters.join(),
      'ITALOGONCALVESPORANGELAMAEPOELUCIA',
    );
    expect(
      normalizeName('Zoë Maïté Müller Ĳssel').letters.join(),
      'ZOEMAITEMULLERIJSSEL',
    );
    expect(normalizeName('Ijsbrand').letters.join(), 'IJSBRAND');
  });

  test('no vowels -> no basis, not zero', () {
    final r = soulUrge(normalizeName('Krk'));
    expect(r.value, isNull);
    expect(r.steps.single, contains('brak podstaw'));
  });

  test('trace contains steps and version', () {
    final r = lifePath(CalendarDate.tryParse('1975-05-29')!);
    expect(r.steps.first, 'Cyfry daty: 2 + 9 + 0 + 5 + 1 + 9 + 7 + 5 = 38.');
    expect(r.steps.last, contains('liczba mistrzowska'));
    expect(r.toJson()['version'], algorithmVersion);
  });

  test(
    'NFD Polish letters, typographic separators and whitespace are accepted',
    () {
      expect(normalizeName('Ęwa Żółć').letters.join(), 'EWAZOLC');
      expect(normalizeName('Ewa Nowak').isValid, isTrue);
      expect(
        normalizeName('Anna‑Maria O’Neill\tX').letters.join(),
        'ANNAMARIAONEILLX',
      );
      expect(
        normalizeName('Anna‑Maria').letters.join(),
        normalizeName('Anna-Maria').letters.join(),
      );
    },
  );

  test(
    'look-alike letters are not silently accepted; emoji reported whole',
    () {
      expect(normalizeName('Joſef').unsupported, {'ſ'}); // long s
      expect(normalizeName('ıwona').unsupported, {'ı'}); // dotless i
      expect(normalizeName('Ewa\u{1F642}').unsupported, {'\u{1F642}'});
    },
  );

  test('date validation is zone-independent and bounded', () {
    expect(
      CalendarDate.tryCreate(2011, 12, 30),
      isNotNull,
    ); // skipped locally in Pacific/Apia
    expect(CalendarDate.tryCreate(300000, 1, 1), isNull);
    expect(CalendarDate.tryCreate(1, 1, 1)?.iso, '0001-01-01');
  });

  test('personal day, relation number, lucky numbers', () {
    final birth = CalendarDate.tryCreate(1990, 7, 15)!;
    final day = CalendarDate.tryCreate(2026, 11, 10)!;
    // personal year 2026: 1+5 + 7 + (2+0+2+6=10) = 23 → 5; day: 5 + (1+1) + (1+0) = 8
    expect(personalYear(birth, 2026).value, 5);
    expect(personalDay(birth, day).value, 8);
    // life paths: 15.07.1990 → 32 → 5; 01.01.2000 → 4; 5 + 4 = 9
    expect(relation(birth, CalendarDate.tryCreate(2000, 1, 1)!).value, 9);
    final a = luckyNumbers(birth, day);
    expect(a, luckyNumbers(birth, day)); // stable for the day
    expect(a.length, 3);
    expect(a.every((n) => n >= 1 && n <= 99), isTrue);
    expect(
      a,
      isNot(luckyNumbers(birth, CalendarDate.tryCreate(2026, 11, 11)!)),
    );
  });

  test('Pythagoras square, classic and 2000+ variant', () {
    // 15.07.1990: 1+5+0+7+1+9+9+0 = 32; 5; 32 − 2·1 = 30; 3
    var s = pythagorasSquare(CalendarDate.tryCreate(1990, 7, 15)!);
    expect(s.working, [32, 5, 30, 3]);
    expect(s.counts, {1: 2, 2: 1, 3: 3, 4: 0, 5: 2, 6: 0, 7: 1, 8: 0, 9: 2});
    // 03.05.2004: 0+3+0+5+2+0+0+4 = 14; 5; 14 + 19 = 33; 6
    s = pythagorasSquare(CalendarDate.tryCreate(2004, 5, 3)!);
    expect(s.working, [14, 5, 33, 6]);
    expect(s.counts[3], 3); // one 3 in the date + two in 33
  });

  test('life periods: pinnacles, challenges, ages', () {
    // 15.07.1990: m 7, d 6, y 1; life path 32 → 5; first period ends at 31
    final p = lifePeriods(CalendarDate.tryCreate(1990, 7, 15)!);
    expect([for (final x in p) x.pinnacle], [4, 7, 2, 8]); // 13→4, 7, 11→2, 8
    expect([for (final x in p) x.challenge], [1, 5, 4, 6]);
    expect(
      [p[0].toAge, p[1].fromAge, p[1].toAge, p[3].fromAge, p[3].toAge],
      [31, 32, 40, 50, null],
    );
  });

  test('personal month, maturity, house number', () {
    final b = CalendarDate.tryCreate(1990, 7, 15)!;
    // personal year 2026 = 5; November: 1+1 = 2 → 7
    expect(personalMonth(b, 2026, 11).value, 7);
    // JAN KOWALSKI expression: J1 A1 N5 K2 O6 W5 A1 L3 S1 K2 I9 = 36 → 9; life path 5 → 14 → 5
    final n = normalizeName('Jan Kowalski');
    expect(expression(n).value, 9);
    expect(maturity(b, n).value, 5);
    expect(houseNumber('12A')!.value, 4); // 1 + 2 + A(1) = 4
    expect(houseNumber('+48 600 100 200')!.value, 3); // 4+8+6+1+2 = 21 → 3
    expect(houseNumber('---'), isNull);
  });

  test('karmic debts and lessons', () {
    // born on the 13th → debt 13
    expect(
      karmicDebts(CalendarDate.tryCreate(1990, 7, 13)!, null),
      contains(13),
    );
    // 15.07.1990: digits sum 32, day 15 → no karmic numbers on the way
    expect(karmicDebts(CalendarDate.tryCreate(1990, 7, 15)!, null), isEmpty);
    // "Jan Kowalski" letter values: 1,5,2,6,3,9 present → lessons 4,7,8
    expect(karmicLessons(normalizeName('Jan Kowalski')), [4, 7, 8]);
  });
}
