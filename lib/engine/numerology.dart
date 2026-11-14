/// Numerology engine — pure Dart, no UI, no interpretation texts.
/// Convention is documented in docs/numerology-method.md. Bump [algorithmVersion]
/// on any rule change: saved results keep the version they were computed with.
library;

import 'lang.dart';

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
  if (seen.length == 1) {
    return tr(
      pl: 'Wynik ${seen.first} nie wymaga redukcji.',
      en: 'Result ${seen.first} needs no reduction.',
      de: 'Das Ergebnis ${seen.first} muss nicht reduziert werden.',
      fr: 'Le résultat ${seen.first} n’a pas besoin d’être réduit.',
      es: 'El resultado ${seen.first} no necesita reducción.',
      uk: 'Результат ${seen.first} не потребує зведення.',
      it: 'Il risultato ${seen.first} non richiede riduzione.',
      pt: 'O resultado ${seen.first} não precisa de redução.',
      nl: 'Het resultaat ${seen.first} hoeft niet te worden herleid.',
    );
  }
  final parts = <String>[];
  for (var i = 0; i < seen.length - 1; i++) {
    parts.add('${seen[i].toString().split('').join(' + ')} = ${seen[i + 1]}');
  }
  return tr(
    pl: 'Redukcja: ${parts.join('; ')}.',
    en: 'Reduction: ${parts.join('; ')}.',
    de: 'Reduktion: ${parts.join('; ')}.',
    fr: 'Réduction : ${parts.join('; ')}.',
    es: 'Reducción: ${parts.join('; ')}.',
    uk: 'Зведення: ${parts.join('; ')}.',
    it: 'Riduzione: ${parts.join('; ')}.',
    pt: 'Redução: ${parts.join('; ')}.',
    nl: 'Herleiding: ${parts.join('; ')}.',
  );
}

String _masterNote(int v, Set<int> masters) => masters.contains(v)
    ? tr(
        pl: ' $v to liczba mistrzowska w przyjętej konwencji — nie redukujemy jej dalej.',
        en: ' $v is a master number in this convention, so it is not reduced further.',
        de: ' $v ist nach der gewählten Konvention eine Meisterzahl und wird nicht weiter reduziert.',
        fr: ' $v est un nombre maître selon la convention retenue : on ne le réduit pas davantage.',
        es: ' $v es un número maestro según la convención adoptada, así que no se reduce más.',
        uk: ' $v — майстер-число за прийнятою конвенцією, тому далі не зводиться.',
        it: ' $v è un numero maestro secondo la convenzione adottata, quindi non viene ridotto ulteriormente.',
        pt: ' $v é um número mestre na convenção adotada, por isso não é reduzido mais.',
        nl: ' $v is volgens de gekozen conventie een meestergetal en wordt niet verder herleid.',
      )
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
    tr(
      pl: 'Suma wszystkich cyfr pełnej daty, następnie redukcja (zachowujemy 11, 22, 33).',
      en: 'Sum of all digits of the full date, then reduced (11, 22 and 33 are kept).',
      de: 'Summe aller Ziffern des vollständigen Datums, dann Reduktion (11, 22 und 33 bleiben erhalten).',
      fr: 'Somme de tous les chiffres de la date complète, puis réduction (11, 22 et 33 sont conservés).',
      es: 'Suma de todas las cifras de la fecha completa y después reducción (se conservan 11, 22 y 33).',
      uk: 'Сума всіх цифр повної дати, потім зведення (11, 22 і 33 зберігаємо).',
      it: 'Somma di tutte le cifre della data completa, poi riduzione (si conservano 11, 22 e 33).',
      pt: 'Soma de todos os algarismos da data completa e, depois, redução (11, 22 e 33 são mantidos).',
      nl: 'Som van alle cijfers van de volledige datum, daarna herleid (11, 22 en 33 blijven staan).',
    ),
    {
      tr(
        pl: 'Data urodzenia',
        en: 'Date of birth',
        de: 'Geburtsdatum',
        fr: 'Date de naissance',
        es: 'Fecha de nacimiento',
        uk: 'Дата народження',
        it: 'Data di nascita',
        pt: 'Data de nascimento',
        nl: 'Geboortedatum',
      ): d.display,
    },
    [
      tr(
        pl: 'Cyfry daty: ${digits.join(' + ')} = $sum.',
        en: 'Date digits: ${digits.join(' + ')} = $sum.',
        de: 'Ziffern des Datums: ${digits.join(' + ')} = $sum.',
        fr: 'Chiffres de la date : ${digits.join(' + ')} = $sum.',
        es: 'Cifras de la fecha: ${digits.join(' + ')} = $sum.',
        uk: 'Цифри дати: ${digits.join(' + ')} = $sum.',
        it: 'Cifre della data: ${digits.join(' + ')} = $sum.',
        pt: 'Algarismos da data: ${digits.join(' + ')} = $sum.',
        nl: 'Cijfers van de datum: ${digits.join(' + ')} = $sum.',
      ),
      _reductionLine(seen) + _masterNote(seen.last, mastersAll),
    ],
    seen.last,
  );
}

NumerologyResult birthDay(CalendarDate d) {
  final seen = reduceSteps(d.day, mastersBirthDay);
  return NumerologyResult(
    Indicator.birthDay,
    tr(
      pl: 'Redukcja samego dnia miesiąca (zachowujemy 11 i 22).',
      en: 'The day of the month alone, reduced (11 and 22 are kept).',
      de: 'Nur der Tag des Monats, reduziert (11 und 22 bleiben erhalten).',
      fr: 'Le jour du mois seul, réduit (11 et 22 sont conservés).',
      es: 'Solo el día del mes, reducido (se conservan 11 y 22).',
      uk: 'Лише день місяця, зведений (11 і 22 зберігаємо).',
      it: 'Solo il giorno del mese, ridotto (si conservano 11 e 22).',
      pt: 'Apenas o dia do mês, reduzido (11 e 22 são mantidos).',
      nl: 'Alleen de dag van de maand, herleid (11 en 22 blijven staan).',
    ),
    {
      tr(
        pl: 'Dzień urodzenia',
        en: 'Day of birth',
        de: 'Geburtstag',
        fr: 'Jour de naissance',
        es: 'Día de nacimiento',
        uk: 'День народження',
        it: 'Giorno di nascita',
        pt: 'Dia de nascimento',
        nl: 'Geboortedag',
      ): '${d.day}',
    },
    [_reductionLine(seen) + _masterNote(seen.last, mastersBirthDay)],
    seen.last,
  );
}

NumerologyResult personalYear(CalendarDate birth, int year) {
  final a = digitSum(birth.day), b = digitSum(birth.month), c = digitSum(year);
  final seen = reduceSteps(a + b + c, const {});
  return NumerologyResult(
    Indicator.personalYear,
    tr(
      pl: 'Suma cyfr dnia i miesiąca urodzenia oraz wybranego roku, redukcja do 1–9. Rok zaczyna się 1 stycznia.',
      en: 'Sum of the digits of your birth day and month and of the chosen year, reduced to 1–9. The year starts on 1 January.',
      de: 'Summe der Ziffern von Geburtstag und -monat sowie des gewählten Jahres, reduziert auf 1–9. Das Jahr beginnt am 1. Januar.',
      fr: 'Somme des chiffres du jour et du mois de naissance et de l’année choisie, réduite à 1–9. L’année commence le 1er janvier.',
      es: 'Suma de las cifras del día y el mes de nacimiento y del año elegido, reducida a 1–9. El año empieza el 1 de enero.',
      uk: 'Сума цифр дня й місяця народження та обраного року, зведена до 1–9. Рік починається 1 січня.',
      it: 'Somma delle cifre del giorno e del mese di nascita e dell’anno scelto, ridotta a 1–9. L’anno inizia il 1° gennaio.',
      pt: 'Soma dos algarismos do dia e do mês de nascimento e do ano escolhido, reduzida a 1–9. O ano começa em 1º de janeiro.',
      nl: 'Som van de cijfers van geboortedag, geboortemaand en het gekozen jaar, herleid tot 1–9. Het jaar begint op 1 januari.',
    ),
    {
      tr(
        pl: 'Dzień i miesiąc',
        en: 'Day and month',
        de: 'Tag und Monat',
        fr: 'Jour et mois',
        es: 'Día y mes',
        uk: 'День і місяць',
        it: 'Giorno e mese',
        pt: 'Dia e mês',
        nl: 'Dag en maand',
      ): '${birth.day}.${birth.month}',
      tr(
        pl: 'Rok',
        en: 'Year',
        de: 'Jahr',
        fr: 'Année',
        es: 'Año',
        uk: 'Рік',
        it: 'Anno',
        pt: 'Ano',
        nl: 'Jaar',
      ): '$year',
    },
    [
      tr(
        pl: 'Dzień: ${birth.day} → $a; miesiąc: ${birth.month} → $b; rok: $year → $c.',
        en: 'Day: ${birth.day} → $a; month: ${birth.month} → $b; year: $year → $c.',
        de: 'Tag: ${birth.day} → $a; Monat: ${birth.month} → $b; Jahr: $year → $c.',
        fr: 'Jour : ${birth.day} → $a ; mois : ${birth.month} → $b ; année : $year → $c.',
        es: 'Día: ${birth.day} → $a; mes: ${birth.month} → $b; año: $year → $c.',
        uk: 'День: ${birth.day} → $a; місяць: ${birth.month} → $b; рік: $year → $c.',
        it: 'Giorno: ${birth.day} → $a; mese: ${birth.month} → $b; anno: $year → $c.',
        pt: 'Dia: ${birth.day} → $a; mês: ${birth.month} → $b; ano: $year → $c.',
        nl: 'Dag: ${birth.day} → $a; maand: ${birth.month} → $b; jaar: $year → $c.',
      ),
      tr(
        pl: 'Suma: $a + $b + $c = ${a + b + c}.',
        en: 'Sum: $a + $b + $c = ${a + b + c}.',
        de: 'Summe: $a + $b + $c = ${a + b + c}.',
        fr: 'Somme : $a + $b + $c = ${a + b + c}.',
        es: 'Suma: $a + $b + $c = ${a + b + c}.',
        uk: 'Сума: $a + $b + $c = ${a + b + c}.',
        it: 'Somma: $a + $b + $c = ${a + b + c}.',
        pt: 'Soma: $a + $b + $c = ${a + b + c}.',
        nl: 'Som: $a + $b + $c = ${a + b + c}.',
      ),
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
    tr(
      pl: 'Rok osobisty plus cyfry bieżącego miesiąca i dnia, redukcja do 1–9.',
      en: 'Personal year plus the digits of the current month and day, reduced to 1–9.',
      de: 'Persönliches Jahr plus die Ziffern des aktuellen Monats und Tages, reduziert auf 1–9.',
      fr: 'Année personnelle plus les chiffres du mois et du jour en cours, réduite à 1–9.',
      es: 'Año personal más las cifras del mes y el día actuales, reducido a 1–9.',
      uk: 'Особистий рік плюс цифри поточного місяця й дня, зведено до 1–9.',
      it: 'Anno personale più le cifre del mese e del giorno in corso, ridotto a 1–9.',
      pt: 'Ano pessoal mais os algarismos do mês e do dia atuais, reduzido a 1–9.',
      nl: 'Persoonlijk jaar plus de cijfers van de huidige maand en dag, herleid tot 1–9.',
    ),
    {
      tr(
        pl: 'Data urodzenia',
        en: 'Date of birth',
        de: 'Geburtsdatum',
        fr: 'Date de naissance',
        es: 'Fecha de nacimiento',
        uk: 'Дата народження',
        it: 'Data di nascita',
        pt: 'Data de nascimento',
        nl: 'Geboortedatum',
      ): birth.display,
      tr(
        pl: 'Dzień',
        en: 'Day',
        de: 'Tag',
        fr: 'Jour',
        es: 'Día',
        uk: 'День',
        it: 'Giorno',
        pt: 'Dia',
        nl: 'Dag',
      ): day.display,
    },
    [
      tr(
        pl: 'Rok osobisty ${day.year}: $py.',
        en: 'Personal year ${day.year}: $py.',
        de: 'Persönliches Jahr ${day.year}: $py.',
        fr: 'Année personnelle ${day.year} : $py.',
        es: 'Año personal ${day.year}: $py.',
        uk: 'Особистий рік ${day.year}: $py.',
        it: 'Anno personale ${day.year}: $py.',
        pt: 'Ano pessoal ${day.year}: $py.',
        nl: 'Persoonlijk jaar ${day.year}: $py.',
      ),
      tr(
        pl: 'Miesiąc: ${day.month} → $m; dzień: ${day.day} → $dd.',
        en: 'Month: ${day.month} → $m; day: ${day.day} → $dd.',
        de: 'Monat: ${day.month} → $m; Tag: ${day.day} → $dd.',
        fr: 'Mois : ${day.month} → $m ; jour : ${day.day} → $dd.',
        es: 'Mes: ${day.month} → $m; día: ${day.day} → $dd.',
        uk: 'Місяць: ${day.month} → $m; день: ${day.day} → $dd.',
        it: 'Mese: ${day.month} → $m; giorno: ${day.day} → $dd.',
        pt: 'Mês: ${day.month} → $m; dia: ${day.day} → $dd.',
        nl: 'Maand: ${day.month} → $m; dag: ${day.day} → $dd.',
      ),
      tr(
        pl: 'Suma: $py + $m + $dd = ${py + m + dd}.',
        en: 'Sum: $py + $m + $dd = ${py + m + dd}.',
        de: 'Summe: $py + $m + $dd = ${py + m + dd}.',
        fr: 'Somme : $py + $m + $dd = ${py + m + dd}.',
        es: 'Suma: $py + $m + $dd = ${py + m + dd}.',
        uk: 'Сума: $py + $m + $dd = ${py + m + dd}.',
        it: 'Somma: $py + $m + $dd = ${py + m + dd}.',
        pt: 'Soma: $py + $m + $dd = ${py + m + dd}.',
        nl: 'Som: $py + $m + $dd = ${py + m + dd}.',
      ),
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
    tr(
      pl: 'Suma liczb drogi życia obu osób, redukcja do 1–9.',
      en: 'Sum of both life path numbers, reduced to 1–9.',
      de: 'Summe der Lebenszahlen beider Personen, reduziert auf 1–9.',
      fr: 'Somme des chemins de vie des deux personnes, réduite à 1–9.',
      es: 'Suma de los caminos de vida de ambas personas, reducida a 1–9.',
      uk: 'Сума чисел життєвого шляху обох людей, зведена до 1–9.',
      it: 'Somma dei numeri del cammino di vita delle due persone, ridotta a 1–9.',
      pt: 'Soma dos números do caminho de vida das duas pessoas, reduzida a 1–9.',
      nl: 'Som van de levenspadgetallen van beide personen, herleid tot 1–9.',
    ),
    {
      tr(
        pl: 'Osoba 1',
        en: 'Person 1',
        de: 'Person 1',
        fr: 'Personne 1',
        es: 'Persona 1',
        uk: 'Особа 1',
        it: 'Persona 1',
        pt: 'Pessoa 1',
        nl: 'Persoon 1',
      ): a.display,
      tr(
        pl: 'Osoba 2',
        en: 'Person 2',
        de: 'Person 2',
        fr: 'Personne 2',
        es: 'Persona 2',
        uk: 'Особа 2',
        it: 'Persona 2',
        pt: 'Pessoa 2',
        nl: 'Persoon 2',
      ): b.display,
    },
    [
      tr(
        pl: 'Drogi życia: $x + $y = ${x + y}.',
        en: 'Life paths: $x + $y = ${x + y}.',
        de: 'Lebenszahlen: $x + $y = ${x + y}.',
        fr: 'Chemins de vie : $x + $y = ${x + y}.',
        es: 'Caminos de vida: $x + $y = ${x + y}.',
        uk: 'Життєві шляхи: $x + $y = ${x + y}.',
        it: 'Cammini di vita: $x + $y = ${x + y}.',
        pt: 'Caminhos de vida: $x + $y = ${x + y}.',
        nl: 'Levenspaden: $x + $y = ${x + y}.',
      ),
      _reductionLine(seen),
    ],
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
// German, French, Spanish, Italian, Portuguese and Dutch letters by their usual plain spelling (ß = SS, æ = AE, ĳ = IJ).
// Other scripts (Cyrillic, Turkish ı…) still need the user's own transliteration.
final _western = <String, String>{
  for (final (from, to) in [
    ('àáâãäåÀÁÂÃÄÅ', 'A'),
    ('çÇ', 'C'),
    ('èéêëÈÉÊË', 'E'),
    ('ìíîïÌÍÎÏ', 'I'),
    ('ñÑ', 'N'),
    ('òôõöøÒÔÕÖØ', 'O'),
    ('ùúûüÙÚÛÜ', 'U'),
    ('ýÿÝŸ', 'Y'),
    ('ß', 'SS'),
    ('æÆ', 'AE'),
    ('œŒ', 'OE'),
    ('ĳĲ', 'IJ'),
  ])
    for (final c in from.split('')) c: to,
};
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
    // Only plain A–Z or the explicit tables; "ı", "ſ", Cyrillic etc. need user transliteration.
    if (RegExp(r'^[A-Za-z]$').hasMatch(ch)) {
      letters.add(u);
    } else if (_polish[u] != null && _polishLetters.contains(ch)) {
      letters.add(_polish[u]!);
    } else if (_western[ch] != null) {
      letters.addAll(_western[ch]!.split(''));
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
  final inputs = {
    tr(
      pl: 'Zapis',
      en: 'As written',
      de: 'Schreibweise',
      fr: 'Graphie',
      es: 'Grafía',
      uk: 'Написання',
      it: 'Grafia',
      pt: 'Grafia',
      nl: 'Spelling',
    ): n.original,
    tr(
      pl: 'Po normalizacji',
      en: 'Normalised',
      de: 'Nach der Normalisierung',
      fr: 'Après normalisation',
      es: 'Tras normalizar',
      uk: 'Після нормалізації',
      it: 'Dopo la normalizzazione',
      pt: 'Após a normalização',
      nl: 'Na normalisatie',
    ): n.letters
        .join(),
  };
  if (sum == 0) {
    return NumerologyResult(ind, method, inputs, [
      tr(
        pl: 'Brak liter tej grupy — brak podstaw do obliczenia.',
        en: 'No letters of this group, so there is nothing to calculate.',
        de: 'Keine Buchstaben dieser Gruppe, also gibt es nichts zu berechnen.',
        fr: 'Aucune lettre de ce groupe : il n’y a rien à calculer.',
        es: 'No hay letras de este grupo, así que no hay nada que calcular.',
        uk: 'Немає літер цієї групи, тож рахувати нічого.',
        it: 'Nessuna lettera di questo gruppo, quindi non c’è nulla da contare.',
        pt: 'Não há letras deste grupo, então não há nada a contar.',
        nl: 'Geen letters in deze groep, dus er valt niets te tellen.',
      ),
    ], null);
  }
  final seen = reduceSteps(sum, mastersAll);
  return NumerologyResult(ind, method, inputs, [
    tr(
      pl: 'Litery: ${used.map((l) => '$l=${letterValue(l)}').join(', ')}.',
      en: 'Letters: ${used.map((l) => '$l=${letterValue(l)}').join(', ')}.',
      de: 'Buchstaben: ${used.map((l) => '$l=${letterValue(l)}').join(', ')}.',
      fr: 'Lettres : ${used.map((l) => '$l=${letterValue(l)}').join(', ')}.',
      es: 'Letras: ${used.map((l) => '$l=${letterValue(l)}').join(', ')}.',
      uk: 'Літери: ${used.map((l) => '$l=${letterValue(l)}').join(', ')}.',
      it: 'Lettere: ${used.map((l) => '$l=${letterValue(l)}').join(', ')}.',
      pt: 'Letras: ${used.map((l) => '$l=${letterValue(l)}').join(', ')}.',
      nl: 'Letters: ${used.map((l) => '$l=${letterValue(l)}').join(', ')}.',
    ),
    tr(
      pl: 'Suma: $sum.',
      en: 'Sum: $sum.',
      de: 'Summe: $sum.',
      fr: 'Somme : $sum.',
      es: 'Suma: $sum.',
      uk: 'Сума: $sum.',
      it: 'Somma: $sum.',
      pt: 'Soma: $sum.',
      nl: 'Som: $sum.',
    ),
    _reductionLine(seen) + _masterNote(seen.last, mastersAll),
  ], seen.last);
}

NumerologyResult expression(NormalizedName n) => _nameNumber(
  Indicator.expression,
  tr(
    pl: 'Suma wartości wszystkich liter (tabela A–Z cyklicznie 1–9), redukcja z 11, 22, 33.',
    en: 'Sum of the values of all letters (A–Z cycling through 1–9), reduced, keeping 11, 22 and 33.',
    de: 'Summe der Werte aller Buchstaben (A–Z zyklisch 1–9), reduziert; 11, 22 und 33 bleiben erhalten.',
    fr: 'Somme des valeurs de toutes les lettres (A–Z de 1 à 9 en boucle), réduite ; 11, 22 et 33 sont conservés.',
    es: 'Suma de los valores de todas las letras (A–Z del 1 al 9 en ciclo), reducida; se conservan 11, 22 y 33.',
    uk: 'Сума значень усіх літер (A–Z циклічно 1–9), зведена; 11, 22 і 33 зберігаємо.',
    it: 'Somma dei valori di tutte le lettere (A–Z ciclicamente 1–9), ridotta; si conservano 11, 22 e 33.',
    pt: 'Soma dos valores de todas as letras (A–Z ciclicamente 1–9), reduzida; 11, 22 e 33 são mantidos.',
    nl: 'Som van de waarden van alle letters (A–Z cyclisch 1–9), herleid; 11, 22 en 33 blijven staan.',
  ),
  n,
  (_) => true,
);

NumerologyResult soulUrge(NormalizedName n) => _nameNumber(
  Indicator.soulUrge,
  tr(
    pl: 'Suma wartości samogłosek A, E, I, O, U, Y, redukcja z 11, 22, 33.',
    en: 'Sum of the values of the vowels A, E, I, O, U, Y, reduced, keeping 11, 22 and 33.',
    de: 'Summe der Werte der Vokale A, E, I, O, U, Y, reduziert; 11, 22 und 33 bleiben erhalten.',
    fr: 'Somme des valeurs des voyelles A, E, I, O, U, Y, réduite ; 11, 22 et 33 sont conservés.',
    es: 'Suma de los valores de las vocales A, E, I, O, U, Y, reducida; se conservan 11, 22 y 33.',
    uk: 'Сума значень голосних A, E, I, O, U, Y, зведена; 11, 22 і 33 зберігаємо.',
    it: 'Somma dei valori delle vocali A, E, I, O, U, Y, ridotta; si conservano 11, 22 e 33.',
    pt: 'Soma dos valores das vogais A, E, I, O, U, Y, reduzida; 11, 22 e 33 são mantidos.',
    nl: 'Som van de waarden van de klinkers A, E, I, O, U, Y, herleid; 11, 22 en 33 blijven staan.',
  ),
  n,
  vowels.contains,
);

NumerologyResult personality(NormalizedName n) => _nameNumber(
  Indicator.personality,
  tr(
    pl: 'Suma wartości spółgłosek (litery inne niż A, E, I, O, U, Y), redukcja z 11, 22, 33.',
    en: 'Sum of the values of the consonants (letters other than A, E, I, O, U, Y), reduced, keeping 11, 22 and 33.',
    de: 'Summe der Werte der Konsonanten (alle Buchstaben außer A, E, I, O, U, Y), reduziert; 11, 22 und 33 bleiben erhalten.',
    fr: 'Somme des valeurs des consonnes (lettres autres que A, E, I, O, U, Y), réduite ; 11, 22 et 33 sont conservés.',
    es: 'Suma de los valores de las consonantes (letras distintas de A, E, I, O, U, Y), reducida; se conservan 11, 22 y 33.',
    uk: 'Сума значень приголосних (літери, крім A, E, I, O, U, Y), зведена; 11, 22 і 33 зберігаємо.',
    it: 'Somma dei valori delle consonanti (le lettere tranne A, E, I, O, U, Y), ridotta; si conservano 11, 22 e 33.',
    pt: 'Soma dos valores das consoantes (letras exceto A, E, I, O, U, Y), reduzida; 11, 22 e 33 são mantidos.',
    nl: 'Som van de waarden van de medeklinkers (alle letters behalve A, E, I, O, U, Y), herleid; 11, 22 en 33 blijven staan.',
  ),
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
      tr(
        pl: 'Cyfry daty: ${dateDigits.join(' + ')} = $a (pierwsza liczba robocza).',
        en: 'Date digits: ${dateDigits.join(' + ')} = $a (first working number).',
        de: 'Ziffern des Datums: ${dateDigits.join(' + ')} = $a (erste Arbeitszahl).',
        fr: 'Chiffres de la date : ${dateDigits.join(' + ')} = $a (premier nombre de travail).',
        es: 'Cifras de la fecha: ${dateDigits.join(' + ')} = $a (primer número auxiliar).',
        uk: 'Цифри дати: ${dateDigits.join(' + ')} = $a (перше робоче число).',
        it: 'Cifre della data: ${dateDigits.join(' + ')} = $a (primo numero di lavoro).',
        pt: 'Algarismos da data: ${dateDigits.join(' + ')} = $a (primeiro número de trabalho).',
        nl: 'Cijfers van de datum: ${dateDigits.join(' + ')} = $a (eerste werkgetal).',
      ),
      tr(
        pl: 'Suma cyfr $a = $b (druga).',
        en: 'Digit sum of $a = $b (second).',
        de: 'Quersumme von $a = $b (zweite).',
        fr: 'Somme des chiffres de $a = $b (deuxième).',
        es: 'Suma de las cifras de $a = $b (segundo).',
        uk: 'Сума цифр $a = $b (друге).',
        it: 'Somma delle cifre di $a = $b (secondo).',
        pt: 'Soma dos algarismos de $a = $b (segundo).',
        nl: 'Som van de cijfers van $a = $b (tweede).',
      ),
      d.year >= 2000
          ? tr(
              pl: 'Dla urodzonych od 2000 r.: $a + 19 = $c (trzecia).',
              en: 'For births from 2000 on: $a + 19 = $c (third).',
              de: 'Für Geburten ab 2000: $a + 19 = $c (dritte).',
              fr: 'Pour les naissances à partir de 2000 : $a + 19 = $c (troisième).',
              es: 'Para nacimientos desde el 2000: $a + 19 = $c (tercero).',
              uk: 'Для народжених від 2000 року: $a + 19 = $c (третє).',
              it: 'Per i nati dal 2000: $a + 19 = $c (terzo).',
              pt: 'Para nascidos a partir de 2000: $a + 19 = $c (terceiro).',
              nl: 'Voor wie vanaf 2000 geboren is: $a + 19 = $c (derde).',
            )
          : tr(
              pl: '$a − 2 × $firstDayDigit (pierwsza cyfra dnia) = $c (trzecia).',
              en: '$a − 2 × $firstDayDigit (first digit of the day) = $c (third).',
              de: '$a − 2 × $firstDayDigit (erste Ziffer des Tages) = $c (dritte).',
              fr: '$a − 2 × $firstDayDigit (premier chiffre du jour) = $c (troisième).',
              es: '$a − 2 × $firstDayDigit (primera cifra del día) = $c (tercero).',
              uk: '$a − 2 × $firstDayDigit (перша цифра дня) = $c (третє).',
              it: '$a − 2 × $firstDayDigit (prima cifra del giorno) = $c (terzo).',
              pt: '$a − 2 × $firstDayDigit (primeiro algarismo do dia) = $c (terceiro).',
              nl: '$a − 2 × $firstDayDigit (eerste cijfer van de dag) = $c (derde).',
            ),
      tr(
        pl: 'Suma cyfr $c = $e (czwarta).',
        en: 'Digit sum of $c = $e (fourth).',
        de: 'Quersumme von $c = $e (vierte).',
        fr: 'Somme des chiffres de $c = $e (quatrième).',
        es: 'Suma de las cifras de $c = $e (cuarto).',
        uk: 'Сума цифр $c = $e (четверте).',
        it: 'Somma delle cifre di $c = $e (quarto).',
        pt: 'Soma dos algarismos de $c = $e (quarto).',
        nl: 'Som van de cijfers van $c = $e (vierde).',
      ),
      tr(
        pl: 'Do siatki trafiają cyfry daty i czterech liczb roboczych, bez zer.',
        en: 'The grid takes the digits of the date and of the four working numbers, without zeros.',
        de: 'In das Raster kommen die Ziffern des Datums und der vier Arbeitszahlen, ohne Nullen.',
        fr: 'La grille reprend les chiffres de la date et des quatre nombres de travail, sans les zéros.',
        es: 'En la cuadrícula entran las cifras de la fecha y de los cuatro números auxiliares, sin ceros.',
        uk: 'До таблиці потрапляють цифри дати й чотирьох робочих чисел, без нулів.',
        it: 'Nella tabella entrano le cifre della data e dei quattro numeri di lavoro, senza gli zeri.',
        pt: 'Entram na tabela os algarismos da data e dos quatro números de trabalho, sem os zeros.',
        nl: 'In de tabel komen de cijfers van de datum en van de vier werkgetallen, zonder nullen.',
      ),
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
    tr(
      pl: 'Rok osobisty plus cyfry miesiąca, redukcja do 1–9.',
      en: 'Personal year plus the digits of the month, reduced to 1–9.',
      de: 'Persönliches Jahr plus die Ziffern des Monats, reduziert auf 1–9.',
      fr: 'Année personnelle plus les chiffres du mois, réduite à 1–9.',
      es: 'Año personal más las cifras del mes, reducido a 1–9.',
      uk: 'Особистий рік плюс цифри місяця, зведено до 1–9.',
      it: 'Anno personale più le cifre del mese, ridotto a 1–9.',
      pt: 'Ano pessoal mais os algarismos do mês, reduzido a 1–9.',
      nl: 'Persoonlijk jaar plus de cijfers van de maand, herleid tot 1–9.',
    ),
    {
      tr(
        pl: 'Data urodzenia',
        en: 'Date of birth',
        de: 'Geburtsdatum',
        fr: 'Date de naissance',
        es: 'Fecha de nacimiento',
        uk: 'Дата народження',
        it: 'Data di nascita',
        pt: 'Data de nascimento',
        nl: 'Geboortedatum',
      ): birth.display,
      tr(
        pl: 'Miesiąc',
        en: 'Month',
        de: 'Monat',
        fr: 'Mois',
        es: 'Mes',
        uk: 'Місяць',
        it: 'Mese',
        pt: 'Mês',
        nl: 'Maand',
      ): '$month.$year',
    },
    [
      tr(
        pl: 'Rok osobisty $year: $py.',
        en: 'Personal year $year: $py.',
        de: 'Persönliches Jahr $year: $py.',
        fr: 'Année personnelle $year : $py.',
        es: 'Año personal $year: $py.',
        uk: 'Особистий рік $year: $py.',
        it: 'Anno personale $year: $py.',
        pt: 'Ano pessoal $year: $py.',
        nl: 'Persoonlijk jaar $year: $py.',
      ),
      tr(
        pl: 'Miesiąc: $month → $m.',
        en: 'Month: $month → $m.',
        de: 'Monat: $month → $m.',
        fr: 'Mois : $month → $m.',
        es: 'Mes: $month → $m.',
        uk: 'Місяць: $month → $m.',
        it: 'Mese: $month → $m.',
        pt: 'Mês: $month → $m.',
        nl: 'Maand: $month → $m.',
      ),
      tr(
        pl: 'Suma: $py + $m = ${py + m}.',
        en: 'Sum: $py + $m = ${py + m}.',
        de: 'Summe: $py + $m = ${py + m}.',
        fr: 'Somme : $py + $m = ${py + m}.',
        es: 'Suma: $py + $m = ${py + m}.',
        uk: 'Сума: $py + $m = ${py + m}.',
        it: 'Somma: $py + $m = ${py + m}.',
        pt: 'Soma: $py + $m = ${py + m}.',
        nl: 'Som: $py + $m = ${py + m}.',
      ),
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
    tr(
      pl: 'Suma drogi życia i liczby ekspresji, redukcja z 11, 22, 33.',
      en: 'Sum of the life path and the expression number, reduced, keeping 11, 22 and 33.',
      de: 'Summe aus Lebenszahl und Ausdruckszahl, reduziert; 11, 22 und 33 bleiben erhalten.',
      fr: 'Somme du chemin de vie et du nombre d’expression, réduite ; 11, 22 et 33 sont conservés.',
      es: 'Suma del camino de vida y del número de expresión, reducida; se conservan 11, 22 y 33.',
      uk: 'Сума життєвого шляху й числа вираження, зведена; 11, 22 і 33 зберігаємо.',
      it: 'Somma del cammino di vita e del numero di espressione, ridotta; si conservano 11, 22 e 33.',
      pt: 'Soma do caminho de vida e do número de expressão, reduzida; 11, 22 e 33 são mantidos.',
      nl: 'Som van het levenspad en het uitdrukkingsgetal, herleid; 11, 22 en 33 blijven staan.',
    ),
    {
      tr(
        pl: 'Data urodzenia',
        en: 'Date of birth',
        de: 'Geburtsdatum',
        fr: 'Date de naissance',
        es: 'Fecha de nacimiento',
        uk: 'Дата народження',
        it: 'Data di nascita',
        pt: 'Data de nascimento',
        nl: 'Geboortedatum',
      ): birth.display,
      tr(
        pl: 'Zapis',
        en: 'As written',
        de: 'Schreibweise',
        fr: 'Graphie',
        es: 'Grafía',
        uk: 'Написання',
        it: 'Grafia',
        pt: 'Grafia',
        nl: 'Spelling',
      ): n.original,
    },
    [
      tr(
        pl: 'Droga życia $lp + ekspresja $ex = ${lp + ex}.',
        en: 'Life path $lp + expression $ex = ${lp + ex}.',
        de: 'Lebenszahl $lp + Ausdruckszahl $ex = ${lp + ex}.',
        fr: 'Chemin de vie $lp + expression $ex = ${lp + ex}.',
        es: 'Camino de vida $lp + expresión $ex = ${lp + ex}.',
        uk: 'Життєвий шлях $lp + вираження $ex = ${lp + ex}.',
        it: 'Cammino di vita $lp + espressione $ex = ${lp + ex}.',
        pt: 'Caminho de vida $lp + expressão $ex = ${lp + ex}.',
        nl: 'Levenspad $lp + uitdrukking $ex = ${lp + ex}.',
      ),
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
    tr(
      pl: 'Suma cyfr (litery według tabeli A–Z), redukcja do 1–9. Inne znaki pomijamy.',
      en: 'Sum of the digits (letters by the A–Z table), reduced to 1–9. Other characters are skipped.',
      de: 'Summe der Ziffern (Buchstaben nach der Tabelle A–Z), reduziert auf 1–9. Andere Zeichen werden übersprungen.',
      fr: 'Somme des chiffres (lettres selon la table A–Z), réduite à 1–9. Les autres caractères sont ignorés.',
      es: 'Suma de las cifras (letras según la tabla A–Z), reducida a 1–9. Los demás caracteres se omiten.',
      uk: 'Сума цифр (літери за таблицею A–Z), зведена до 1–9. Інші символи пропускаємо.',
      it: 'Somma delle cifre (lettere secondo la tabella A–Z), ridotta a 1–9. Gli altri simboli vengono ignorati.',
      pt: 'Soma dos algarismos (letras pela tabela A–Z), reduzida a 1–9. Os demais símbolos são ignorados.',
      nl: 'Som van de cijfers (letters volgens de A–Z-tabel), herleid tot 1–9. Andere tekens worden overgeslagen.',
    ),
    {
      tr(
        pl: 'Zapis',
        en: 'As written',
        de: 'Schreibweise',
        fr: 'Graphie',
        es: 'Grafía',
        uk: 'Написання',
        it: 'Grafia',
        pt: 'Grafia',
        nl: 'Spelling',
      ): input
          .trim(),
    },
    [
      tr(
        pl: 'Wartości: ${values.join(' + ')} = $sum.',
        en: 'Values: ${values.join(' + ')} = $sum.',
        de: 'Werte: ${values.join(' + ')} = $sum.',
        fr: 'Valeurs : ${values.join(' + ')} = $sum.',
        es: 'Valores: ${values.join(' + ')} = $sum.',
        uk: 'Значення: ${values.join(' + ')} = $sum.',
        it: 'Valori: ${values.join(' + ')} = $sum.',
        pt: 'Valores: ${values.join(' + ')} = $sum.',
        nl: 'Waarden: ${values.join(' + ')} = $sum.',
      ),
      _reductionLine(seen),
    ],
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
