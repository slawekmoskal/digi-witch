/// Numerology engine — pure Dart, no UI, no interpretation texts.
/// Convention is documented in docs/numerology-method.md. Bump [algorithmVersion]
/// on any rule change: saved results keep the version they were computed with.
library;

import 'dart:math';

const algorithmVersion = 'pl-pyth-1';

const mastersAll = {11, 22, 33};
const mastersBirthDay = {11, 22};

/// Calendar date without time or zone (never routed through UTC).
class CalendarDate implements Comparable<CalendarDate> {
  final int year, month, day;
  const CalendarDate._(this.year, this.month, this.day);

  /// Returns null for non-existent dates (e.g. 2023-02-30, 1900-02-29).
  static CalendarDate? tryCreate(int year, int month, int day) {
    if (year < 1 || year > 9999 || month < 1 || month > 12 || day < 1) {
      return null;
    }
    // UTC only to validate the calendar date: local zones can skip whole days (e.g. Pacific/Apia 2011-12-30).
    final dt = DateTime.utc(year, month, day);
    if (dt.year != year || dt.month != month || dt.day != day) return null;
    return CalendarDate._(year, month, day);
  }

  factory CalendarDate.fromDateTime(DateTime d) =>
      CalendarDate._(d.year, d.month, d.day);

  /// Parses `yyyy-mm-dd`; null if malformed or non-existent.
  static CalendarDate? tryParse(String s) {
    final m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(s.trim());
    if (m == null) return null;
    return tryCreate(int.parse(m[1]!), int.parse(m[2]!), int.parse(m[3]!));
  }

  String get iso =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  String get display =>
      '${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}.${year.toString().padLeft(4, '0')}';

  @override
  int compareTo(CalendarDate other) => iso.compareTo(other.iso);
  @override
  bool operator ==(Object other) => other is CalendarDate && other.iso == iso;
  @override
  int get hashCode => iso.hashCode;
  @override
  String toString() => iso;
}

enum Indicator {
  lifePath,
  birthDay,
  expression,
  soulUrge,
  personality,
  personalYear,
  personalDay,
  relation,
  personalMonth,
  maturity,
  house,
}

/// One computed indicator with a human-readable trace of every step.
class NumerologyResult {
  final Indicator indicator;
  final String method;
  final Map<String, String> inputs;
  final List<String> steps;
  final int? value; // null = no basis to compute (e.g. no vowels)
  final String version;
  const NumerologyResult(
    this.indicator,
    this.method,
    this.inputs,
    this.steps,
    this.value, {
    this.version = algorithmVersion,
  });

  Map<String, Object?> toJson() => {
    'indicator': indicator.name,
    'method': method,
    'inputs': inputs,
    'steps': steps,
    'value': value,
    'version': version,
  };
}

int digitSum(int n) =>
    n.abs().toString().split('').fold(0, (a, c) => a + int.parse(c));

/// Repeated digit sums until 1–9 or a number in [masters]. Returns every value seen.
List<int> reduceSteps(int n, Set<int> masters) {
  final seen = [n];
  while (n > 9 && !masters.contains(n)) {
    n = digitSum(n);
    seen.add(n);
  }
  return seen;
}

String _reductionLine(List<int> seen) {
  if (seen.length == 1) return 'Wynik ${seen.first} nie wymaga redukcji.';
  final parts = <String>[];
  for (var i = 0; i < seen.length - 1; i++) {
    parts.add('${seen[i].toString().split('').join(' + ')} = ${seen[i + 1]}');
  }
  return 'Redukcja: ${parts.join('; ')}.';
}

String _masterNote(int v, Set<int> masters) => masters.contains(v)
    ? ' $v to liczba mistrzowska w przyjętej konwencji — nie redukujemy jej dalej.'
    : '';

NumerologyResult lifePath(CalendarDate d) {
  final digits =
      '${d.day.toString().padLeft(2, '0')}${d.month.toString().padLeft(2, '0')}${d.year}'
          .split('')
          .map(int.parse)
          .toList();
  final sum = digits.fold(0, (a, b) => a + b);
  final seen = reduceSteps(sum, mastersAll);
  return NumerologyResult(
    Indicator.lifePath,
    'Suma wszystkich cyfr pełnej daty, następnie redukcja (zachowujemy 11, 22, 33).',
    {'Data urodzenia': d.display},
    [
      'Cyfry daty: ${digits.join(' + ')} = $sum.',
      _reductionLine(seen) + _masterNote(seen.last, mastersAll),
    ],
    seen.last,
  );
}

NumerologyResult birthDay(CalendarDate d) {
  final seen = reduceSteps(d.day, mastersBirthDay);
  return NumerologyResult(
    Indicator.birthDay,
    'Redukcja samego dnia miesiąca (zachowujemy 11 i 22).',
    {'Dzień urodzenia': '${d.day}'},
    [_reductionLine(seen) + _masterNote(seen.last, mastersBirthDay)],
    seen.last,
  );
}

NumerologyResult personalYear(CalendarDate birth, int year) {
  final a = digitSum(birth.day), b = digitSum(birth.month), c = digitSum(year);
  final seen = reduceSteps(a + b + c, const {});
  return NumerologyResult(
    Indicator.personalYear,
    'Suma cyfr dnia i miesiąca urodzenia oraz wybranego roku, redukcja do 1–9. Rok zaczyna się 1 stycznia.',
    {'Dzień i miesiąc': '${birth.day}.${birth.month}', 'Rok': '$year'},
    [
      'Dzień: ${birth.day} → $a; miesiąc: ${birth.month} → $b; rok: $year → $c.',
      'Suma: $a + $b + $c = ${a + b + c}.',
      _reductionLine(seen),
    ],
    seen.last,
  );
}

NumerologyResult personalDay(CalendarDate birth, CalendarDate day) {
  final py = personalYear(birth, day.year).value!;
  final m = digitSum(day.month), dd = digitSum(day.day);
  final seen = reduceSteps(py + m + dd, const {});
  return NumerologyResult(
    Indicator.personalDay,
    'Rok osobisty plus cyfry bieżącego miesiąca i dnia, redukcja do 1–9.',
    {'Data urodzenia': birth.display, 'Dzień': day.display},
    [
      'Rok osobisty ${day.year}: $py.',
      'Miesiąc: ${day.month} → $m; dzień: ${day.day} → $dd.',
      'Suma: $py + $m + $dd = ${py + m + dd}.',
      _reductionLine(seen),
    ],
    seen.last,
  );
}

/// Relationship number of two people: sum of both life paths, reduced to 1–9.
NumerologyResult relation(CalendarDate a, CalendarDate b) {
  final x = lifePath(a).value!, y = lifePath(b).value!;
  final seen = reduceSteps(x + y, const {});
  return NumerologyResult(
    Indicator.relation,
    'Suma liczb drogi życia obu osób, redukcja do 1–9.',
    {'Osoba 1': a.display, 'Osoba 2': b.display},
    ['Drogi życia: $x + $y = ${x + y}.', _reductionLine(seen)],
    seen.last,
  );
}

/// Three numbers 1–99, fixed for one person and one day. For fun only — not a forecast.
List<int> luckyNumbers(CalendarDate birth, CalendarDate day) {
  int key(CalendarDate d) => d.year * 10000 + d.month * 100 + d.day;
  final r = Random(key(birth) * 7919 + key(day));
  final s = <int>{};
  while (s.length < 3) {
    s.add(r.nextInt(99) + 1);
  }
  return s.toList()..sort();
}

// ---- Letters ----

const _polish = {
  'Ą': 'A',
  'Ć': 'C',
  'Ę': 'E',
  'Ł': 'L',
  'Ń': 'N',
  'Ó': 'O',
  'Ś': 'S',
  'Ź': 'Z',
  'Ż': 'Z',
};
const _polishLetters = 'ĄĆĘŁŃÓŚŹŻąćęłńóśźż';
const _nfdPolish = {
  'a\u0328': 'ą',
  'A\u0328': 'Ą',
  'e\u0328': 'ę',
  'E\u0328': 'Ę',
  'c\u0301': 'ć',
  'C\u0301': 'Ć',
  'n\u0301': 'ń',
  'N\u0301': 'Ń',
  'o\u0301': 'ó',
  'O\u0301': 'Ó',
  's\u0301': 'ś',
  'S\u0301': 'Ś',
  'z\u0301': 'ź',
  'Z\u0301': 'Ź',
  'z\u0307': 'ż',
  'Z\u0307': 'Ż',
};
// Hyphens/apostrophes incl. typographic variants (U+2010, U+2011, U+2019, U+02BC); any whitespace also ignored.
const _separators = {'-', '\u2010', '\u2011', "'", '\u2019', '\u02BC'};
const vowels = {'A', 'E', 'I', 'O', 'U', 'Y'};

int letterValue(String upperAZ) => (upperAZ.codeUnitAt(0) - 65) % 9 + 1;

/// Name normalised for calculation. [unsupported] lists characters that need an
/// explicit transliteration from the user — they are never silently dropped.
class NormalizedName {
  final String original;
  final List<String> letters;
  final Set<String> unsupported;
  const NormalizedName(this.original, this.letters, this.unsupported);
  bool get isValid => unsupported.isEmpty && letters.isNotEmpty;
}

NormalizedName normalizeName(String input) {
  final letters = <String>[];
  final bad = <String>{};
  final runes = input.trim().runes.toList();
  for (var i = 0; i < runes.length; i++) {
    var ch = String.fromCharCode(runes[i]);
    // Decomposed (NFD) Polish letters, e.g. "e" + U+0328 → "ę".
    if (i + 1 < runes.length) {
      final composed = _nfdPolish['$ch${String.fromCharCode(runes[i + 1])}'];
      if (composed != null) {
        ch = composed;
        i++;
      }
    }
    if (_separators.contains(ch) || ch.trim().isEmpty) continue;
    final u = ch.toUpperCase();
    // Only plain A–Z or the explicit Polish table; "ı", "ſ", "ß" etc. need user transliteration.
    if (RegExp(r'^[A-Za-z]$').hasMatch(ch)) {
      letters.add(u);
    } else if (_polish[u] != null && _polishLetters.contains(ch)) {
      letters.add(_polish[u]!);
    } else {
      bad.add(ch);
    }
  }
  return NormalizedName(input, letters, bad);
}

NumerologyResult _nameNumber(
  Indicator ind,
  String method,
  NormalizedName n,
  bool Function(String) pick,
) {
  if (!n.isValid) {
    throw ArgumentError(
      'Name has unsupported characters: ${n.unsupported.join()}',
    );
  }
  final used = n.letters.where(pick).toList();
  final sum = used.fold(0, (a, l) => a + letterValue(l));
  final inputs = {'Zapis': n.original, 'Po normalizacji': n.letters.join()};
  if (sum == 0) {
    return NumerologyResult(ind, method, inputs, [
      'Brak liter tej grupy — brak podstaw do obliczenia.',
    ], null);
  }
  final seen = reduceSteps(sum, mastersAll);
  return NumerologyResult(ind, method, inputs, [
    'Litery: ${used.map((l) => '$l=${letterValue(l)}').join(', ')}.',
    'Suma: $sum.',
    _reductionLine(seen) + _masterNote(seen.last, mastersAll),
  ], seen.last);
}

NumerologyResult expression(NormalizedName n) => _nameNumber(
  Indicator.expression,
  'Suma wartości wszystkich liter (tabela A–Z cyklicznie 1–9), redukcja z 11, 22, 33.',
  n,
  (_) => true,
);

NumerologyResult soulUrge(NormalizedName n) => _nameNumber(
  Indicator.soulUrge,
  'Suma wartości samogłosek A, E, I, O, U, Y, redukcja z 11, 22, 33.',
  n,
  vowels.contains,
);

NumerologyResult personality(NormalizedName n) => _nameNumber(
  Indicator.personality,
  'Suma wartości spółgłosek (litery inne niż A, E, I, O, U, Y), redukcja z 11, 22, 33.',
  n,
  (l) => !vowels.contains(l),
);

// ---- Pythagoras square (psychomatrix, Aleksandrov method) ----

class PythagorasSquare {
  final List<int> working; // the four working numbers
  final Map<int, int> counts; // digit 1–9 → how many times it appears
  final List<String> steps;
  const PythagorasSquare(this.working, this.counts, this.steps);
}

PythagorasSquare pythagorasSquare(CalendarDate d) {
  final dateDigits =
      '${d.day.toString().padLeft(2, '0')}${d.month.toString().padLeft(2, '0')}${d.year}'
          .split('')
          .map(int.parse)
          .toList();
  final a = dateDigits.fold(0, (s, x) => s + x);
  final b = digitSum(a);
  final firstDayDigit = d.day >= 10 ? d.day ~/ 10 : d.day;
  // Born from 2000 on, the school uses +19 instead of − 2 × first digit of the day.
  final c = d.year >= 2000 ? a + 19 : (a - 2 * firstDayDigit).abs();
  final e = digitSum(c);
  final pool = [
    ...dateDigits,
    for (final n in [a, b, c, e]) ...n.toString().split('').map(int.parse),
  ].where((x) => x != 0);
  final counts = {for (var i = 1; i <= 9; i++) i: 0};
  for (final x in pool) {
    counts[x] = counts[x]! + 1;
  }
  return PythagorasSquare(
    [a, b, c, e],
    counts,
    [
      'Cyfry daty: ${dateDigits.join(' + ')} = $a (pierwsza liczba robocza).',
      'Suma cyfr $a = $b (druga).',
      d.year >= 2000
          ? 'Dla urodzonych od 2000 r.: $a + 19 = $c (trzecia).'
          : '$a − 2 × $firstDayDigit (pierwsza cyfra dnia) = $c (trzecia).',
      'Suma cyfr $c = $e (czwarta).',
      'Do siatki trafiają cyfry daty i czterech liczb roboczych, bez zer.',
    ],
  );
}

// ---- Life cycles: pinnacles and challenges ----

class LifePeriod {
  final int fromAge; // inclusive
  final int? toAge; // inclusive; null = rest of life
  final int pinnacle, challenge;
  const LifePeriod(this.fromAge, this.toAge, this.pinnacle, this.challenge);
}

int _single(int n) => reduceSteps(n, const {}).last;

/// Four periods; the first ends at 36 − life path (life path reduced to 1–9).
List<LifePeriod> lifePeriods(CalendarDate d) {
  final m = _single(d.month), day = _single(d.day), y = _single(d.year);
  final lp = _single(lifePath(d).value!);
  final p1 = _single(m + day), p2 = _single(day + y);
  final p3 = _single(p1 + p2), p4 = _single(m + y);
  final c1 = (m - day).abs(), c2 = (day - y).abs();
  final c3 = (c1 - c2).abs(), c4 = (m - y).abs();
  final end1 = 36 - lp;
  return [
    LifePeriod(0, end1, p1, c1),
    LifePeriod(end1 + 1, end1 + 9, p2, c2),
    LifePeriod(end1 + 10, end1 + 18, p3, c3),
    LifePeriod(end1 + 19, null, p4, c4),
  ];
}

// ---- More indicators ----

NumerologyResult personalMonth(CalendarDate birth, int year, int month) {
  final py = personalYear(birth, year).value!;
  final m = digitSum(month);
  final seen = reduceSteps(py + m, const {});
  return NumerologyResult(
    Indicator.personalMonth,
    'Rok osobisty plus cyfry miesiąca, redukcja do 1–9.',
    {'Data urodzenia': birth.display, 'Miesiąc': '$month.$year'},
    [
      'Rok osobisty $year: $py.',
      'Miesiąc: $month → $m.',
      'Suma: $py + $m = ${py + m}.',
      _reductionLine(seen),
    ],
    seen.last,
  );
}

/// Maturity number: life path + expression, reduced (masters kept).
NumerologyResult maturity(CalendarDate birth, NormalizedName n) {
  final lp = lifePath(birth).value!, ex = expression(n).value!;
  final seen = reduceSteps(lp + ex, mastersAll);
  return NumerologyResult(
    Indicator.maturity,
    'Suma drogi życia i liczby ekspresji, redukcja z 11, 22, 33.',
    {'Data urodzenia': birth.display, 'Zapis': n.original},
    [
      'Droga życia $lp + ekspresja $ex = ${lp + ex}.',
      _reductionLine(seen) + _masterNote(seen.last, mastersAll),
    ],
    seen.last,
  );
}

/// House, flat or phone number: digits as they are, letters by the A–Z table, reduced to 1–9.
NumerologyResult? houseNumber(String input) {
  final values = <String>[];
  var sum = 0;
  for (final ch in input.toUpperCase().split('')) {
    if (RegExp(r'[0-9]').hasMatch(ch)) {
      sum += int.parse(ch);
      values.add(ch);
    } else if (RegExp(r'[A-Z]').hasMatch(ch)) {
      sum += letterValue(ch);
      values.add('$ch=${letterValue(ch)}');
    }
  }
  if (sum == 0) return null;
  final seen = reduceSteps(sum, const {});
  return NumerologyResult(
    Indicator.house,
    'Suma cyfr (litery według tabeli A–Z), redukcja do 1–9. Inne znaki pomijamy.',
    {'Zapis': input.trim()},
    ['Wartości: ${values.join(' + ')} = $sum.', _reductionLine(seen)],
    seen.last,
  );
}

const karmicNumbers = {13, 14, 16, 19};

/// Karmic debts: 13, 14, 16 or 19 appearing as a birth day or on the way to a core number.
Set<int> karmicDebts(CalendarDate? d, NormalizedName? n) {
  final sums = <int>[
    if (d != null) ...[
      d.day,
      '${d.day.toString().padLeft(2, '0')}${d.month.toString().padLeft(2, '0')}${d.year}'
          .split('')
          .fold(0, (a, c) => a + int.parse(c)),
    ],
    if (n != null && n.isValid) ...[
      for (final pick in <bool Function(String)>[
        (_) => true,
        vowels.contains,
        (l) => !vowels.contains(l),
      ])
        n.letters.where(pick).fold(0, (a, l) => a + letterValue(l)),
    ],
  ];
  return {
    for (final s in sums)
      for (final v in reduceSteps(s, mastersAll))
        if (karmicNumbers.contains(v)) v,
  };
}

/// Karmic lessons: digits 1–9 that no letter of the name gives.
List<int> karmicLessons(NormalizedName n) {
  final present = {for (final l in n.letters) letterValue(l)};
  return [
    for (var i = 1; i <= 9; i++)
      if (!present.contains(i)) i,
  ];
}
