/// Tarot draw engine — pure Dart. Randomness is injected for tests.
/// Result never depends on payment, ads, ad ID or user profile.
library;

import 'dart:math';

import 'numerology.dart';

const suits = ['wands', 'cups', 'swords', 'pentacles'];

/// Canonical 78 ids: `major_00`..`major_21`, `<suit>_01`..`<suit>_14`.
final List<String> deckIds = List.unmodifiable([
  for (var i = 0; i <= 21; i++) 'major_${i.toString().padLeft(2, '0')}',
  for (final s in suits)
    for (var r = 1; r <= 14; r++) '${s}_${r.toString().padLeft(2, '0')}',
]);

class Spread {
  final String id, name;
  final List<String> positions;
  final bool pro;
  const Spread(this.id, this.name, this.positions, {this.pro = false});
}

const spreads = [
  Spread('one', 'Jedna karta', ['Na co warto dziś zwrócić uwagę']),
  Spread('three', 'Trzy karty', [
    'Sytuacja',
    'Możliwa perspektywa',
    'Następny krok',
  ]),
  Spread('five', 'Pięć kart', [
    'Sedno sprawy',
    'Co mnie wspiera',
    'Co mnie ogranicza',
    'Czego nie widzę',
    'Co mogę zrobić',
  ]),
  Spread('relation', 'Relacja', [
    'Ja w tej relacji',
    'Jak widzę drugą osobę',
    'Co nas łączy',
    'Co nas różni',
    'Czego potrzebuję',
    'Co mogę zaproponować',
  ], pro: true),
  Spread('cross', 'Krzyż refleksji', [
    'Sedno',
    'Co je przecina',
    'Podstawa',
    'Co odchodzi',
    'Świadomy cel',
    'Najbliższy krok',
    'Moja postawa',
    'Otoczenie',
    'Nadzieje i obawy',
    'Możliwy kierunek',
  ], pro: true),
  Spread('yesno', 'Tak/Nie', ['Odpowiedź']),
];

class DrawnCard {
  final String cardId;
  final String position;
  final bool reversed;
  const DrawnCard(this.cardId, this.position, this.reversed);

  Map<String, Object> toJson() => {
    'cardId': cardId,
    'position': position,
    'reversed': reversed,
  };
  factory DrawnCard.fromJson(Map<String, dynamic> j) => DrawnCard(
    j['cardId'] as String,
    j['position'] as String,
    j['reversed'] as bool,
  );
}

/// Fisher–Yates via List.shuffle (uniform), then the first N cards — no replacement.
/// Reversal rule: if enabled, each card independently reversed with probability 1/2.
List<DrawnCard> draw(
  Spread spread, {
  required Random random,
  required bool allowReversed,
}) {
  final deck = [...deckIds]..shuffle(random);
  return [
    for (var i = 0; i < spread.positions.length; i++)
      DrawnCard(
        deck[i],
        spread.positions[i],
        allowReversed && random.nextBool(),
      ),
  ];
}

/// Spread-level patterns for the reading summary. Counts only — wording lives in l10n.
class SpreadSummary {
  final bool majorsDominate, mostlyReversed;
  final String? dominantSuit; // strictly most frequent suit, at least 2 cards
  const SpreadSummary(
    this.majorsDominate,
    this.mostlyReversed,
    this.dominantSuit,
  );
}

SpreadSummary summarize(List<DrawnCard> cards) {
  final n = cards.length;
  final suitCounts = <String, int>{};
  for (final c in cards) {
    if (!c.cardId.startsWith('major_')) {
      suitCounts.update(
        c.cardId.split('_').first,
        (v) => v + 1,
        ifAbsent: () => 1,
      );
    }
  }
  final ranked = suitCounts.entries.toList()..sort((a, b) => b.value - a.value);
  final top = ranked.isEmpty ? null : ranked.first;
  final unique =
      top != null &&
      top.value >= 2 &&
      (ranked.length == 1 || ranked[1].value < top.value);
  // Patterns need at least 3 cards to mean anything.
  return SpreadSummary(
    n >= 3 && cards.where((c) => c.cardId.startsWith('major_')).length * 2 > n,
    n >= 3 && cards.where((c) => c.reversed).length * 2 > n,
    unique ? top.key : null,
  );
}

enum YesNo { yes, no, unclear }

// Upright cards traditionally read as "no" or "unclear"; every other upright card is "yes".
const _noCards = {
  'major_15', 'major_16', 'swords_03', 'swords_05', 'swords_08', //
  'swords_09', 'swords_10', 'cups_05', 'pentacles_05', 'wands_10',
};
const _unclearCards = {
  'major_12',
  'major_18',
  'swords_02',
  'swords_07',
  'cups_04',
  'cups_07',
};

/// Reversal weakens the answer: yes → no, no → unclear.
YesNo yesNo(DrawnCard c) {
  final base = _noCards.contains(c.cardId)
      ? YesNo.no
      : _unclearCards.contains(c.cardId)
      ? YesNo.unclear
      : YesNo.yes;
  if (!c.reversed) return base;
  return base == YesNo.yes ? YesNo.no : YesNo.unclear;
}

/// Birth card (Major Arcana) from a birth date: day + month + year, digit sums down to ≤ 22.
class BirthCard {
  final int major; // 0–21; 22 maps to the Fool (0)
  final int? second; // paired card for two-digit results
  final List<String> steps;
  const BirthCard(this.major, this.second, this.steps);
  String get id => 'major_${major.toString().padLeft(2, '0')}';
  String? get secondId =>
      second == null ? null : 'major_${second!.toString().padLeft(2, '0')}';
}

BirthCard birthCard(CalendarDate d) {
  final sum = d.day + d.month + d.year;
  final steps = [
    'Dzień + miesiąc + rok: ${d.day} + ${d.month} + ${d.year} = $sum.',
  ];
  var n = sum;
  while (n > 22) {
    final m = digitSum(n);
    steps.add('Suma cyfr $n = $m.');
    n = m;
  }
  final second = n > 9 ? digitSum(n) : null;
  if (n == 22) steps.add('22 odpowiada Głupcowi (0).');
  if (second != null) steps.add('Druga karta pary: suma cyfr $n = $second.');
  return BirthCard(n == 22 ? 0 : n, second, steps);
}
