import 'dart:convert';
import 'dart:io';

import 'package:digi_witch/engine/astro.dart';
import 'package:digi_witch/engine/numerology.dart';
import 'package:flutter_test/flutter_test.dart';

double angleDiff(double a, double b) => ((a - b + 540) % 360 - 180).abs();
CalendarDate d(int y, int m, int day) => CalendarDate.tryCreate(y, m, day)!;

void main() {
  // Reference values from PyEphem 4.2.1 (ecliptic of date), see test/fixtures/astro_ref.json.
  final ref = jsonDecode(
    File('test/fixtures/astro_ref.json').readAsStringSync(),
  );

  test('Moon and Sun longitude match PyEphem, 1940–2050', () {
    for (final p in ref['pts']) {
      final t = DateTime.parse(p[0]);
      expect(angleDiff(moonLongitude(t), p[1]), lessThan(0.5), reason: p[0]);
      expect(angleDiff(sunLongitude(t), p[2]), lessThan(0.05), reason: p[0]);
    }
  });

  test('main phase times within 90 minutes of PyEphem', () {
    final ev = phaseEvents(DateTime.utc(2026, 11, 10), 12);
    for (var i = 0; i < 12; i++) {
      expect(ev[i].phase, ref['events'][i][0]);
      final diff = ev[i].utc.difference(DateTime.parse(ref['events'][i][1]));
      expect(diff.inMinutes.abs(), lessThan(90), reason: '$i');
    }
  });

  test('Chinese New Year matches published dates', () {
    const known = {
      1970: '1970-02-06',
      1980: '1980-02-16',
      1985: '1985-02-20',
      1990: '1990-01-27',
      1995: '1995-01-31',
      2000: '2000-02-05',
      2010: '2010-02-14',
      2015: '2015-02-19',
      2017: '2017-01-28',
      2018: '2018-02-16',
      2019: '2019-02-05',
      2020: '2020-01-25',
      2021: '2021-02-12',
      2022: '2022-02-01',
      2023: '2023-01-22',
      2024: '2024-02-10',
      2025: '2025-01-29',
      2026: '2026-02-17',
    };
    known.forEach((y, iso) => expect(chineseNewYear(y).iso, iso));
  });

  test('Chinese sign switches at New Year', () {
    expect(chineseIds[chineseSign(d(1984, 3, 1))], 'rat');
    expect(chineseIds[chineseSign(d(2024, 2, 9))], 'rabbit');
    expect(chineseIds[chineseSign(d(2024, 2, 10))], 'dragon');
  });

  test('sun sign boundaries', () {
    String s(int m, int day) => signIds[sunSign(d(2000, m, day))];
    expect(s(1, 19), 'capricorn');
    expect(s(1, 20), 'aquarius');
    expect(s(3, 20), 'pisces');
    expect(s(3, 21), 'aries');
    expect(s(12, 21), 'sagittarius');
    expect(s(12, 22), 'capricorn');
    expect(elementOf(sunSign(d(2000, 4, 1))), 'fire');
  });

  test('element relations', () {
    expect(elementRelation('fire', 'fire'), 'same');
    expect(elementRelation('air', 'fire'), 'supportive');
    expect(elementRelation('water', 'fire'), 'tense');
    expect(elementRelation('earth', 'fire'), 'neutral');
  });

  test('moon phase buckets', () {
    final full = phaseEvents(
      DateTime.utc(2026, 11, 10),
      4,
    ).firstWhere((e) => e.phase == 4).utc;
    expect(moonPhase(full), 4);
    expect(illumination(full), greaterThan(0.99));
  });

  // Ascendant, Mercury and stations vs PyEphem 4.2.1 (test/fixtures/astro_ref2.json).
  final ref2 = jsonDecode(
    File('test/fixtures/astro_ref2.json').readAsStringSync(),
  );

  test('ascendant matches PyEphem for places in Poland', () {
    for (final c in ref2['asc']) {
      final a = ascendant(DateTime.parse(c[0]), c[1], c[2]);
      expect(angleDiff(a, c[3]), lessThan(0.5), reason: '${c[0]}');
    }
  });

  test('Mercury longitude within 0.5° of PyEphem, 1950–2050', () {
    for (final c in ref2['mercury']) {
      expect(
        angleDiff(mercuryLongitude(DateTime.parse(c[0])), c[1]),
        lessThan(0.5),
        reason: c[0],
      );
    }
  });

  test('Mercury retrograde stations within a day of PyEphem', () {
    final periods = mercuryRetrogrades(
      DateTime.utc(2026, 1, 1),
      DateTime.utc(2027, 12, 31),
    );
    final st = ref2['stations'] as List;
    expect(periods.length * 2, st.length);
    for (var i = 0; i < periods.length; i++) {
      for (final (j, t) in [
        (2 * i, periods[i].$1),
        (2 * i + 1, periods[i].$2),
      ]) {
        final diff = t.difference(DateTime.parse(st[j][1])).inHours.abs();
        expect(diff, lessThan(30), reason: '$j');
      }
    }
  });

  test('Chinese year element, yin/yang and relations', () {
    expect([yearElement(1984), yearIsYang(1984)], ['wood', true]);
    expect([yearElement(2026), yearIsYang(2026)], ['fire', true]); // Fire Horse
    expect([yearElement(2027), yearIsYang(2027)], ['fire', false]); // Fire Goat
    expect(chineseIds[chineseSign(d(1966, 6, 1))], 'horse');
    expect(yearElement(chineseYearOf(d(1966, 6, 1))), 'fire');
    int i(String s) => chineseIds.indexOf(s);
    expect(chineseRelation(i('rat'), i('ox')), 'friend');
    expect(chineseRelation(i('rat'), i('dragon')), 'trine');
    expect(chineseRelation(i('rat'), i('horse')), 'clash');
    expect(chineseRelation(i('rat'), i('rabbit')), 'neutral');
  });

  test('a retrograde period running at the range end reports its real end', () {
    // 2026-11-01 is inside the 24.10–14.11.2026 retrograde.
    final t = DateTime.utc(2026, 11, 1);
    final p = mercuryRetrogrades(t, t);
    expect(p.length, 1);
    expect(p.single.$1.isBefore(t), isTrue);
    expect(p.single.$2.month, 11);
    expect(p.single.$2.day, inInclusiveRange(13, 15));
  });

  test('ascendant worldwide incl. southern hemisphere and tropics', () {
    final ref3 = jsonDecode(
      File('test/fixtures/astro_ref3.json').readAsStringSync(),
    );
    for (final c in ref3) {
      final a = ascendant(DateTime.parse(c[0]), c[1], c[2]);
      expect(angleDiff(a, c[3]), lessThan(0.5), reason: '${c[0]} ${c[1]}');
    }
  });
}
