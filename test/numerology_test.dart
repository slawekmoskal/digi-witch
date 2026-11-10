import 'dart:convert';
import 'dart:io';

import 'package:digi_witch/engine/numerology.dart';
import 'package:flutter_test/flutter_test.dart';

/// Expectations come from tool/expected_numerology.py (independent oracle).
void main() {
  final cases = jsonDecode(File('test/fixtures/numerology_cases.json').readAsStringSync());

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
    final c = (cases['dates'] as List).firstWhere((c) => c['date'] == '1950-01-04');
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

  test('birth day never yields 33; trace contains steps', () {
    for (var d = 1; d <= 31; d++) {
      expect(birthDay(CalendarDate.tryCreate(2000, 1, d)!).value, isNot(33));
    }
    final r = lifePath(CalendarDate.tryParse('1975-05-29')!);
    expect(r.steps.first, 'Cyfry daty: 2 + 9 + 0 + 5 + 1 + 9 + 7 + 5 = 38.');
    expect(r.steps.last, contains('liczba mistrzowska'));
    expect(r.toJson()['version'], algorithmVersion);
  });
}
