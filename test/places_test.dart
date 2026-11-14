import 'package:digi_witch/data/places.dart';
import 'package:digi_witch/engine/lang.dart';
import 'package:digi_witch/engine/numerology.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CalendarDate d(int y, int m, int day) => CalendarDate.tryCreate(y, m, day)!;

  test('Polish time to UTC follows summer-time history', () {
    expect(warsawToUtc(d(1990, 1, 15), 12 * 60), DateTime.utc(1990, 1, 15, 11));
    expect(warsawToUtc(d(1990, 7, 15), 12 * 60), DateTime.utc(1990, 7, 15, 10));
    expect(
      warsawToUtc(d(1970, 7, 15), 12 * 60),
      DateTime.utc(1970, 7, 15, 11),
    ); // no DST 1965–1976
    expect(
      warsawToUtc(d(1960, 7, 1), 12 * 60),
      DateTime.utc(1960, 7, 1, 10),
    ); // DST 1957–1964
  });

  test('foreign zones: London, New York, Sydney (southern summer)', () {
    expect(
      localToUtc(d(1995, 7, 1), 12 * 60, 'Europe/London'),
      DateTime.utc(1995, 7, 1, 11),
    );
    expect(
      localToUtc(d(1995, 1, 10), 12 * 60, 'America/New_York'),
      DateTime.utc(1995, 1, 10, 17),
    );
    expect(
      localToUtc(d(1995, 1, 10), 12 * 60, 'Australia/Sydney'),
      DateTime.utc(1995, 1, 10, 1),
    );
  });

  test('every place has a known zone, unique label, valid coordinates', () {
    final labels = cities.map(placeLabel).toList();
    expect(labels.toSet().length, labels.length);
    for (final c in cities) {
      expect(isZone(c.tz), isTrue, reason: c.name);
      expect(
        c.lat.abs(),
        lessThan(66),
        reason: c.name,
      ); // ascendant undefined near the poles
      expect(c.lon.abs(), lessThanOrEqualTo(180), reason: c.name);
      if (c.country == null) {
        expect(c.tz, 'Europe/Warsaw');
        expect(c.lat, inInclusiveRange(49.0, 55.0), reason: c.name);
        expect(c.lon, inInclusiveRange(14.0, 24.2), reason: c.name);
      }
    }
    expect(
      placeNamed('Kraków')!.lat,
      50.06,
    ); // profiles saved before the world list
    expect(placeNamed('Londyn (Wielka Brytania)')!.tz, 'Europe/London');
  });

  test('custom place round-trips and rejects bad input', () {
    final p = placeNamed(customPlace(-12.05, -77.04, 'America/Lima'))!;
    expect([p.lat, p.lon, p.tz], [-12.05, -77.04, 'America/Lima']);
    expect(placeNamed('custom:1;2;Nowhere/Zone'), isNull);
    expect(placeNamed('custom:abc'), isNull);
    expect(placeNamed('Atlantyda'), isNull);
  });

  test(
    'every country has a name in every language; Ukrainian names every city',
    () {
      final countries = {'Polska', for (final c in cities) ?c.country};
      // English lists only names that differ from Polish (Austria, USA…); the others list all.
      for (final MapEntry(key: lang, value: names) in countryNames.entries.skip(
        1,
      )) {
        expect(countries.difference(names.keys.toSet()), isEmpty, reason: lang);
      }
      expect(
        cities
            .map((c) => c.name)
            .toSet()
            .difference(cityNames['uk']!.keys.toSet()),
        isEmpty,
      );
      for (final m in cityNames.values) {
        expect(
          m.keys.toSet().difference(cities.map((c) => c.name).toSet()),
          isEmpty,
        );
      }
      appLang = 'de';
      final warsaw = cities.firstWhere((c) => c.name == 'Warszawa');
      final london = cities.firstWhere((c) => c.name == 'Londyn');
      expect(placeDisplay(warsaw), 'Warschau (Polen)');
      expect(placeDisplay(london), 'London (Vereinigtes Königreich)');
      appLang = 'uk';
      expect(placeDisplay(warsaw), 'Варшава (Польща)');
      final munich = cities.firstWhere((c) => c.name == 'Monachium');
      appLang = 'it';
      expect(placeDisplay(munich), 'Monaco di Baviera (Germania)');
      appLang = 'pt';
      expect(placeDisplay(munich), 'Munique (Alemanha)');
      appLang = 'nl';
      expect(placeDisplay(munich), 'München (Duitsland)');
      // The new languages name at least every city German does.
      for (final l in ['it', 'pt', 'nl']) {
        expect(
          cityNames['de']!.keys.toSet().difference(cityNames[l]!.keys.toSet()),
          isEmpty,
          reason: l,
        );
      }
      appLang = 'pl';
    },
  );
}
