import 'package:digi_witch/data/places.dart';
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

  test('city list is unique and inside Poland', () {
    expect(cities.map((c) => c.name).toSet().length, cities.length);
    for (final c in cities) {
      expect(c.lat, inInclusiveRange(49.0, 55.0), reason: c.name);
      expect(c.lon, inInclusiveRange(14.0, 24.2), reason: c.name);
    }
    expect(placeNamed('Kraków')!.lat, 50.06);
  });
}
