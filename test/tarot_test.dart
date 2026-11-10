import 'dart:math';

import 'package:digi_witch/engine/tarot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('deck has 78 unique ids: 22 major + 4x14 minor', () {
    expect(deckIds.length, 78);
    expect(deckIds.toSet().length, 78);
    expect(deckIds.where((i) => i.startsWith('major_')).length, 22);
  });

  test('no card repeats within a spread, positions kept', () {
    final r = Random(1);
    for (var i = 0; i < 500; i++) {
      final d = draw(spreads[2], random: r, allowReversed: true);
      expect(d.map((c) => c.cardId).toSet().length, 5);
      expect(d.map((c) => c.position).toList(), spreads[2].positions);
    }
  });

  test('reversals off -> never reversed', () {
    final d = [for (var i = 0; i < 200; i++) ...draw(spreads[1], random: Random(i), allowReversed: false)];
    expect(d.any((c) => c.reversed), isFalse);
  });

  test('seeded random is reproducible', () {
    final a = draw(spreads[1], random: Random(42), allowReversed: true);
    final b = draw(spreads[1], random: Random(42), allowReversed: true);
    expect(a.map((c) => c.toJson()).toList(), b.map((c) => c.toJson()).toList());
  });

  test('first card is roughly uniform over 78 cards and reversal ~50%', () {
    final counts = <String, int>{};
    var rev = 0;
    const n = 78 * 400;
    final r = Random(7);
    for (var i = 0; i < n; i++) {
      final c = draw(spreads[0], random: r, allowReversed: true).single;
      counts[c.cardId] = (counts[c.cardId] ?? 0) + 1;
      if (c.reversed) rev++;
    }
    expect(counts.length, 78);
    // chi-square, df=77; critical value at p=0.001 is ~117.6
    final chi = counts.values.fold<double>(0, (a, o) => a + (o - 400) * (o - 400) / 400);
    expect(chi, lessThan(117.6));
    expect(rev / n, closeTo(0.5, 0.02));
  });
}
