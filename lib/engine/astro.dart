/// Astro engine — pure Dart, offline, no texts. Low-precision formulas from the
/// Astronomical Almanac (Moon ~0.3°, Sun ~0.01°); phase times accurate to ~1 h.
library;

import 'dart:math';

import 'numerology.dart';

const signIds = [
  'aries', 'taurus', 'gemini', 'cancer', 'leo', 'virgo', //
  'libra', 'scorpio', 'sagittarius', 'capricorn', 'aquarius', 'pisces',
];
const elements = ['fire', 'earth', 'air', 'water']; // sign i → elements[i % 4]
const chineseIds = [
  'rat', 'ox', 'tiger', 'rabbit', 'dragon', 'snake', //
  'horse', 'goat', 'monkey', 'rooster', 'dog', 'pig',
];

// First day (month, day) of each sign, starting from Capricorn's year-end boundary.
// shortcut: fixed table, the real cusp moves ±1 day by year and birth time is unknown.
const _signStarts = [
  (1, 20, 10),
  (2, 19, 11),
  (3, 21, 0),
  (4, 20, 1),
  (5, 21, 2),
  (6, 21, 3),
  (7, 23, 4),
  (8, 23, 5),
  (9, 23, 6),
  (10, 23, 7),
  (11, 22, 8),
  (12, 22, 9),
];

/// Sun sign index into [signIds] for a birth date.
int sunSign(CalendarDate d) {
  var sign = 9; // Capricorn until 19 January
  for (final (m, day, s) in _signStarts) {
    if (d.month > m || (d.month == m && d.day >= day)) sign = s;
  }
  return sign;
}

String elementOf(int sign) => elements[sign % 4];

/// same / supportive (fire–air, earth–water) / tense (fire–water, earth–air) / neutral.
String elementRelation(String a, String b) {
  if (a == b) return 'same';
  final pair = {a, b};
  if (pair.containsAll(['fire', 'air']) ||
      pair.containsAll(['earth', 'water'])) {
    return 'supportive';
  }
  if (pair.containsAll(['fire', 'water']) ||
      pair.containsAll(['earth', 'air'])) {
    return 'tense';
  }
  return 'neutral';
}

// ---- Sun and Moon ----

double _jd(DateTime t) =>
    t.toUtc().millisecondsSinceEpoch / 86400000 + 2440587.5;
DateTime _fromJd(double jd) => DateTime.fromMillisecondsSinceEpoch(
  ((jd - 2440587.5) * 86400000).round(),
  isUtc: true,
);
double _sin(double deg) => sin(deg * pi / 180);
double _norm360(double a) => (a % 360 + 360) % 360;

/// Geocentric ecliptic longitude of the Sun, degrees.
double sunLongitude(DateTime t) {
  final n = _jd(t) - 2451545.0;
  final g = 357.528 + 0.9856003 * n;
  return _norm360(
    280.460 + 0.9856474 * n + 1.915 * _sin(g) + 0.020 * _sin(2 * g),
  );
}

/// Geocentric ecliptic longitude of the Moon, degrees (±0.3°).
double moonLongitude(DateTime t) {
  final c = (_jd(t) - 2451545.0) / 36525;
  return _norm360(
    218.32 +
        481267.881 * c +
        6.29 * _sin(135.0 + 477198.87 * c) -
        1.27 * _sin(259.3 - 413335.36 * c) +
        0.66 * _sin(235.7 + 890534.22 * c) +
        0.21 * _sin(269.9 + 954397.74 * c) -
        0.19 * _sin(357.5 + 35999.05 * c) -
        0.11 * _sin(186.5 + 966404.03 * c),
  );
}

/// Moon − Sun, 0 = new moon, 180 = full moon.
double elongation(DateTime t) => _norm360(moonLongitude(t) - sunLongitude(t));

/// Zodiac sign index the Moon is in at [t].
int moonSign(DateTime t) => moonLongitude(t) ~/ 30;

/// 0 new, 1 waxing crescent, 2 first quarter, 3 waxing gibbous,
/// 4 full, 5 waning gibbous, 6 last quarter, 7 waning crescent.
int moonPhase(DateTime t) => ((elongation(t) + 22.5) % 360) ~/ 45;

/// Fraction of the disc lit, 0–1.
double illumination(DateTime t) => (1 - cos(elongation(t) * pi / 180)) / 2;

/// First moment after [from] when [angle] (monotonically increasing mod 360) reaches [target].
DateTime _next(double Function(DateTime) angle, double target, DateTime from) {
  double off(DateTime t) =>
      (angle(t) - target + 540) % 360 - 180; // (-180, 180]
  var a = _jd(from);
  var b = a + 0.25;
  while (!(off(_fromJd(a)) < 0 && off(_fromJd(b)) >= 0)) {
    a = b;
    b += 0.25; // Moon moves ~3°/6 h, so no crossing is skipped
  }
  for (var i = 0; i < 40; i++) {
    final m = (a + b) / 2;
    off(_fromJd(m)) < 0 ? a = m : b = m;
  }
  return _fromJd(b);
}

class PhaseEvent {
  final int phase; // 0 new, 2 first quarter, 4 full, 6 last quarter
  final DateTime utc;
  const PhaseEvent(this.phase, this.utc);
}

/// Main lunar phases after [from], in time order.
List<PhaseEvent> phaseEvents(DateTime from, int count) {
  final out = <PhaseEvent>[];
  var t = from;
  while (out.length < count) {
    final next = [
      for (final p in [0, 2, 4, 6])
        PhaseEvent(p, _next(elongation, p * 45.0, t)),
    ]..sort((a, b) => a.utc.compareTo(b.utc));
    out.add(next.first);
    t = next.first.utc.add(const Duration(minutes: 1));
  }
  return out;
}

// ---- Chinese zodiac ----

CalendarDate _chinaDate(DateTime utc) =>
    CalendarDate.fromDateTime(utc.add(const Duration(hours: 8)));

/// Chinese New Year: second new moon (China time) after the winter solstice.
/// shortcut: ignores leap months 11/12 (next case 2033), fine for birth years before that.
CalendarDate chineseNewYear(int year) {
  final solstice = _next(sunLongitude, 270, DateTime.utc(year - 1, 12, 1));
  final day = _chinaDate(solstice);
  var t = solstice;
  var found = 0;
  while (true) {
    t = _next(elongation, 0, t);
    if (_chinaDate(t).compareTo(day) > 0 && ++found == 2) return _chinaDate(t);
    t = t.add(const Duration(days: 1));
  }
}

/// Index into [chineseIds]; dates before Chinese New Year belong to the previous year.
int chineseSign(CalendarDate d) => (chineseYearOf(d) - 4) % 12; // 1984 = rat

// ---- Ascendant (needs birth time and place) ----

double _obliquity(DateTime t) =>
    23.439291 - 0.0130042 * (_jd(t) - 2451545.0) / 36525;

/// Greenwich mean sidereal time, degrees.
double _gmst(DateTime t) {
  final d = _jd(t) - 2451545.0;
  final c = d / 36525;
  return _norm360(280.46061837 + 360.98564736629 * d + 0.000387933 * c * c);
}

/// Ecliptic longitude rising on the eastern horizon; [lat]/[lon] in degrees, east positive.
double ascendant(DateTime utc, double lat, double lon) {
  final th = (_gmst(utc) + lon) * pi / 180;
  final e = _obliquity(utc) * pi / 180;
  final f = lat * pi / 180;
  return _norm360(
    atan2(cos(th), -(sin(th) * cos(e) + tan(f) * sin(e))) * 180 / pi,
  );
}

// ---- Mercury (JPL approximate Keplerian elements, valid 1800–2050) ----

// a, e, I, L, long. perihelion, long. node + rates per century (J2000 ecliptic).
const _mercury = [
  0.38709927, 0.20563593, 7.00497902, 252.25032350, 77.45779628, 48.33076593, //
  0.00000037, 0.00001906, -0.00594749, 149472.67411175, 0.16047689, -0.12534081,
];
const _earth = [
  1.00000261, 0.01671123, -0.00001531, 100.46457166, 102.93768193, 0.0, //
  0.00000562, -0.00004392, -0.01294668, 35999.37244981, 0.32327364, 0.0,
];

List<double> _helio(List<double> k, double c) {
  double el(int i) => k[i] + k[i + 6] * c;
  final a = el(0), e = el(1), inc = el(2) * pi / 180;
  final node = el(5) * pi / 180, peri = el(4) * pi / 180;
  final w = peri - node;
  final m = ((el(3) - el(4)) % 360) * pi / 180;
  var ea = m;
  for (var i = 0; i < 12; i++) {
    ea -= (ea - e * sin(ea) - m) / (1 - e * cos(ea));
  }
  final xp = a * (cos(ea) - e), yp = a * sqrt(1 - e * e) * sin(ea);
  return [
    (cos(w) * cos(node) - sin(w) * sin(node) * cos(inc)) * xp +
        (-sin(w) * cos(node) - cos(w) * sin(node) * cos(inc)) * yp,
    (cos(w) * sin(node) + sin(w) * cos(node) * cos(inc)) * xp +
        (-sin(w) * sin(node) + cos(w) * cos(node) * cos(inc)) * yp,
  ];
}

/// Geocentric ecliptic longitude of Mercury (ecliptic of date), degrees.
double mercuryLongitude(DateTime t) {
  final c = (_jd(t) - 2451545.0) / 36525;
  final m = _helio(_mercury, c), e = _helio(_earth, c);
  final lon = atan2(m[1] - e[1], m[0] - e[0]) * 180 / pi;
  return _norm360(lon + 1.3970 * c); // precession J2000 → date
}

/// Retrograde periods (start, end) that overlap [from, to].
List<(DateTime, DateTime)> mercuryRetrogrades(DateTime from, DateTime to) {
  double speed(DateTime t) =>
      (mercuryLongitude(t.add(const Duration(hours: 6))) -
              mercuryLongitude(t) +
              540) %
          360 -
      180;
  DateTime station(DateTime a, DateTime b) {
    final retro = speed(a) < 0;
    for (var i = 0; i < 30; i++) {
      final m = a.add(b.difference(a) ~/ 2);
      (speed(m) < 0) == retro ? a = m : b = m;
    }
    return b;
  }

  final out = <(DateTime, DateTime)>[];
  var t = from.subtract(
    const Duration(days: 30),
  ); // catch a period already running
  DateTime? start;
  var retro = speed(t) < 0;
  while (t.isBefore(to)) {
    final n = t.add(const Duration(days: 1));
    final r = speed(n) < 0;
    if (r != retro) {
      final s = station(t, n);
      if (r) {
        start = s;
      } else if (start != null && s.isAfter(from)) {
        out.add((start, s));
      }
      retro = r;
    }
    t = n;
  }
  if (retro && start != null) {
    // Still retrograde at [to]: find the real end (periods last ~3 weeks).
    var u = t;
    while (speed(u) < 0) {
      u = u.add(const Duration(days: 1));
    }
    out.add((start, station(u.subtract(const Duration(days: 1)), u)));
  }
  return out;
}

// ---- Chinese element, yin/yang, compatibility ----

const chineseElements = ['wood', 'fire', 'earth', 'metal', 'water'];

/// Chinese year a date belongs to (before Chinese New Year → previous year).
int chineseYearOf(CalendarDate d) =>
    d.compareTo(chineseNewYear(d.year)) < 0 ? d.year - 1 : d.year;

/// Heavenly stem → element of the year; even stems are yang (1984 = yang wood).
String yearElement(int chineseYear) =>
    chineseElements[((chineseYear - 4) % 10) ~/ 2];
bool yearIsYang(int chineseYear) => (chineseYear - 4) % 2 == 0;

/// same / friend (secret friends) / trine / clash (opposite) / neutral.
String chineseRelation(int a, int b) {
  if (a == b) return 'same';
  if ((a + b) % 12 == 1) return 'friend';
  if (a % 4 == b % 4) return 'trine';
  if ((a - b) % 12 == 6) return 'clash';
  return 'neutral';
}
