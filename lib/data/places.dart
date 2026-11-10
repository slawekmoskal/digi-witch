import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../engine/numerology.dart';

typedef Place = ({String name, double lat, double lon});

// shortcut: Polish cities only (one time zone with full DST history); add foreign places with their zone when asked for.
const List<Place> cities = [
  (name: 'Biała Podlaska', lat: 52.03, lon: 23.13),
  (name: 'Białystok', lat: 53.13, lon: 23.16),
  (name: 'Bielsko-Biała', lat: 49.82, lon: 19.04),
  (name: 'Bydgoszcz', lat: 53.12, lon: 18.01),
  (name: 'Bytom', lat: 50.35, lon: 18.92),
  (name: 'Chełm', lat: 51.14, lon: 23.47),
  (name: 'Chorzów', lat: 50.30, lon: 18.95),
  (name: 'Ciechanów', lat: 52.88, lon: 20.62),
  (name: 'Częstochowa', lat: 50.81, lon: 19.12),
  (name: 'Elbląg', lat: 54.16, lon: 19.40),
  (name: 'Gdańsk', lat: 54.35, lon: 18.65),
  (name: 'Gdynia', lat: 54.52, lon: 18.53),
  (name: 'Gliwice', lat: 50.29, lon: 18.67),
  (name: 'Gniezno', lat: 52.54, lon: 17.60),
  (name: 'Gorzów Wielkopolski', lat: 52.73, lon: 15.24),
  (name: 'Grudziądz', lat: 53.48, lon: 18.75),
  (name: 'Inowrocław', lat: 52.80, lon: 18.26),
  (name: 'Jastrzębie-Zdrój', lat: 49.96, lon: 18.60),
  (name: 'Jaworzno', lat: 50.20, lon: 19.27),
  (name: 'Jelenia Góra', lat: 50.90, lon: 15.73),
  (name: 'Kalisz', lat: 51.76, lon: 18.09),
  (name: 'Katowice', lat: 50.26, lon: 19.02),
  (name: 'Kielce', lat: 50.87, lon: 20.63),
  (name: 'Konin', lat: 52.22, lon: 18.25),
  (name: 'Koszalin', lat: 54.19, lon: 16.17),
  (name: 'Kraków', lat: 50.06, lon: 19.94),
  (name: 'Krosno', lat: 49.69, lon: 21.77),
  (name: 'Legnica', lat: 51.21, lon: 16.16),
  (name: 'Leszno', lat: 51.84, lon: 16.57),
  (name: 'Lubin', lat: 51.40, lon: 16.20),
  (name: 'Lublin', lat: 51.25, lon: 22.57),
  (name: 'Łomża', lat: 53.18, lon: 22.06),
  (name: 'Łódź', lat: 51.76, lon: 19.46),
  (name: 'Mysłowice', lat: 50.21, lon: 19.17),
  (name: 'Nowy Sącz', lat: 49.62, lon: 20.69),
  (name: 'Olsztyn', lat: 53.78, lon: 20.48),
  (name: 'Opole', lat: 50.67, lon: 17.93),
  (name: 'Ostrołęka', lat: 53.08, lon: 21.57),
  (name: 'Ostrów Wielkopolski', lat: 51.65, lon: 17.81),
  (name: 'Piła', lat: 53.15, lon: 16.74),
  (name: 'Piotrków Trybunalski', lat: 51.40, lon: 19.70),
  (name: 'Płock', lat: 52.55, lon: 19.71),
  (name: 'Poznań', lat: 52.41, lon: 16.93),
  (name: 'Przemyśl', lat: 49.78, lon: 22.77),
  (name: 'Radom', lat: 51.40, lon: 21.15),
  (name: 'Ruda Śląska', lat: 50.26, lon: 18.86),
  (name: 'Rybnik', lat: 50.10, lon: 18.55),
  (name: 'Rzeszów', lat: 50.04, lon: 22.00),
  (name: 'Siedlce', lat: 52.17, lon: 22.29),
  (name: 'Sieradz', lat: 51.60, lon: 18.73),
  (name: 'Skierniewice', lat: 51.96, lon: 20.15),
  (name: 'Słupsk', lat: 54.46, lon: 17.03),
  (name: 'Sosnowiec', lat: 50.29, lon: 19.10),
  (name: 'Stargard', lat: 53.34, lon: 15.05),
  (name: 'Suwałki', lat: 54.10, lon: 22.93),
  (name: 'Szczecin', lat: 53.43, lon: 14.55),
  (name: 'Tarnobrzeg', lat: 50.57, lon: 21.68),
  (name: 'Tarnów', lat: 50.01, lon: 20.99),
  (name: 'Toruń', lat: 53.01, lon: 18.60),
  (name: 'Tychy', lat: 50.12, lon: 18.99),
  (name: 'Wałbrzych', lat: 50.77, lon: 16.28),
  (name: 'Warszawa', lat: 52.23, lon: 21.01),
  (name: 'Włocławek', lat: 52.65, lon: 19.07),
  (name: 'Wrocław', lat: 51.11, lon: 17.03),
  (name: 'Zabrze', lat: 50.32, lon: 18.79),
  (name: 'Zakopane', lat: 49.30, lon: 19.95),
  (name: 'Zamość', lat: 50.72, lon: 23.25),
  (name: 'Zielona Góra', lat: 51.94, lon: 15.51),
];

Place? placeNamed(String? name) {
  for (final c in cities) {
    if (c.name == name) return c;
  }
  return null;
}

var _tzReady = false;

/// Polish civil time → UTC, using the tz database history (incl. pre-1977 summer time).
DateTime warsawToUtc(CalendarDate d, int minutes) {
  if (!_tzReady) {
    tzdata.initializeTimeZones();
    _tzReady = true;
  }
  final t = tz.TZDateTime(
    tz.getLocation('Europe/Warsaw'),
    d.year,
    d.month,
    d.day,
    minutes ~/ 60,
    minutes % 60,
  );
  return DateTime.fromMillisecondsSinceEpoch(
    t.millisecondsSinceEpoch,
    isUtc: true,
  );
}
