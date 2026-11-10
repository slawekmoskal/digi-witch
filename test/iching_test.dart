import 'dart:math';

import 'package:digi_witch/engine/iching.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('all 64 hexagrams reachable exactly once', () {
    final seen = <int>{};
    for (var m = 0; m < 64; m++) {
      seen.add(hexagram([for (var i = 0; i < 6; i++) (m >> i) & 1 == 1]));
    }
    expect(seen, {for (var i = 1; i <= 64; i++) i});
  });

  test('known hexagrams', () {
    expect(hexagram(List.filled(6, true)), 1); // Heaven
    expect(hexagram(List.filled(6, false)), 2); // Earth
    // 11 Peace: Earth above Heaven → lower three yang
    expect(hexagram([true, true, true, false, false, false]), 11);
    expect(hexagram([false, false, false, true, true, true]), 12);
    // 63: Water above Fire → lines 1..6 = yang yin yang yin yang yin
    expect(hexagram([true, false, true, false, true, false]), 63);
    expect(hexagram([false, true, false, true, false, true]), 64);
  });

  test('changing lines flip into the second hexagram', () {
    expect(readLines([9, 7, 7, 7, 7, 7]), (1, 44)); // bottom yang → yin
    expect(readLines([7, 7, 7, 8, 8, 8]), (11, null));
    expect(readLines([6, 6, 6, 6, 6, 6]), (2, 1));
  });

  test('coin probabilities: 6 and 9 rare, 7 and 8 common', () {
    final r = Random(3);
    final c = <int, int>{};
    for (var i = 0; i < 80000; i++) {
      c.update(tossLine(r), (v) => v + 1, ifAbsent: () => 1);
    }
    expect(c[6]! / 80000, closeTo(1 / 8, 0.01));
    expect(c[9]! / 80000, closeTo(1 / 8, 0.01));
    expect(c[7]! / 80000, closeTo(3 / 8, 0.01));
  });
}
