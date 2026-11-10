import 'dart:math';

import 'package:digi_witch/engine/numerology.dart';
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
    final d = [
      for (var i = 0; i < 200; i++)
        ...draw(spreads[1], random: Random(i), allowReversed: false),
    ];
    expect(d.any((c) => c.reversed), isFalse);
  });

  test('seeded random is reproducible', () {
    final a = draw(spreads[1], random: Random(42), allowReversed: true);
    final b = draw(spreads[1], random: Random(42), allowReversed: true);
    expect(
      a.map((c) => c.toJson()).toList(),
      b.map((c) => c.toJson()).toList(),
    );
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
    final chi = counts.values.fold<double>(
      0,
      (a, o) => a + (o - 400) * (o - 400) / 400,
    );
    expect(chi, lessThan(117.6));
    expect(rev / n, closeTo(0.5, 0.02));
  });

  test('summary: majors, dominant suit, reversals', () {
    DrawnCard c(String id, [bool r = false]) => DrawnCard(id, 'p', r);
    var s = summarize([c('major_00'), c('major_13'), c('cups_02', true)]);
    expect(s.majorsDominate, isTrue);
    expect(s.dominantSuit, isNull); // single minor card is not a pattern
    expect(s.mostlyReversed, isFalse);

    s = summarize([c('cups_01', true), c('cups_05', true), c('swords_02')]);
    expect(s.majorsDominate, isFalse);
    expect(s.dominantSuit, 'cups');
    expect(s.mostlyReversed, isTrue);

    // tie between suits -> no dominant suit
    s = summarize([c('cups_01'), c('cups_02'), c('wands_01'), c('wands_02')]);
    expect(s.dominantSuit, isNull);

    // one-card spread: no patterns
    s = summarize([c('major_16', true)]);
    expect([s.majorsDominate, s.mostlyReversed], [false, false]);
  });

  test('yes/no answers', () {
    expect(yesNo(const DrawnCard('major_19', 'p', false)), YesNo.yes);
    expect(yesNo(const DrawnCard('major_19', 'p', true)), YesNo.no);
    expect(yesNo(const DrawnCard('major_16', 'p', false)), YesNo.no);
    expect(yesNo(const DrawnCard('major_16', 'p', true)), YesNo.unclear);
    expect(yesNo(const DrawnCard('major_18', 'p', false)), YesNo.unclear);
  });

  test('birth card', () {
    CalendarDate d(int y, int m, int day) => CalendarDate.tryCreate(y, m, day)!;
    // 15 + 7 + 1990 = 2012 → 5
    var b = birthCard(d(1990, 7, 15));
    expect([b.major, b.second], [5, null]);
    // 28 + 12 + 1979 = 2019 → 12, paired with 1 + 2 = 3
    b = birthCard(d(1979, 12, 28));
    expect([b.id, b.secondId], ['major_12', 'major_03']);
    // 1 + 1 + 1991 = 1993 → 22 = Fool, paired with 4
    b = birthCard(d(1991, 1, 1));
    expect([b.id, b.secondId], ['major_00', 'major_04']);
  });
}
