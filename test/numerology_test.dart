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
    final n = normalizeName('Müller');
    expect(n.isValid, isFalse);
    expect(n.unsupported, {'ü'});
    expect(() => expression(n), throwsArgumentError);
    expect(normalizeName('Иван').unsupported.length, 4);
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
      expect(normalizeName('Straße').unsupported, {'ß'});
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
}
