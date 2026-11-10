/// Tarot draw engine — pure Dart. Randomness is injected for tests.
/// Result never depends on payment, ads, ad ID or user profile.
library;

import 'dart:math';

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
  const Spread(this.id, this.name, this.positions);
}

const spreads = [
  Spread('one', 'Jedna karta', ['Na co warto dziś zwrócić uwagę']),
  Spread('three', 'Trzy karty', ['Sytuacja', 'Możliwa perspektywa', 'Następny krok']),
  Spread('five', 'Pięć kart', ['Sedno sprawy', 'Co mnie wspiera', 'Co mnie ogranicza', 'Czego nie widzę', 'Co mogę zrobić']),
];

class DrawnCard {
  final String cardId;
  final String position;
  final bool reversed;
  const DrawnCard(this.cardId, this.position, this.reversed);

  Map<String, Object> toJson() => {'cardId': cardId, 'position': position, 'reversed': reversed};
  factory DrawnCard.fromJson(Map<String, dynamic> j) =>
      DrawnCard(j['cardId'] as String, j['position'] as String, j['reversed'] as bool);
}

/// Fisher–Yates via List.shuffle (uniform), then the first N cards — no replacement.
/// Reversal rule: if enabled, each card independently reversed with probability 1/2.
List<DrawnCard> draw(Spread spread, {required Random random, required bool allowReversed}) {
  final deck = [...deckIds]..shuffle(random);
  return [
    for (var i = 0; i < spread.positions.length; i++)
      DrawnCard(deck[i], spread.positions[i], allowReversed && random.nextBool()),
  ];
}
