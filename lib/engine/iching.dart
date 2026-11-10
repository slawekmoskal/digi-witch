/// I Ching with the three-coin method — pure Dart, randomness injected.
library;

import 'dart:math';

/// One throw of three coins: heads = 3, tails = 2 → 6, 7, 8 or 9.
/// 6 = old yin (changing), 7 = yang, 8 = yin, 9 = old yang (changing).
int tossLine(Random r) =>
    [for (var i = 0; i < 3; i++) r.nextBool() ? 3 : 2].reduce((a, b) => a + b);

bool isYang(int line) => line.isOdd;
bool isChanging(int line) => line == 6 || line == 9;

// Trigram index from three lines (bottom → top), each 1 = yang.
// Order: Qian, Zhen, Kan, Gen, Kun, Xun, Li, Dui.
const _trigrams = {
  '111': 0, '100': 1, '010': 2, '001': 3, //
  '000': 4, '011': 5, '101': 6, '110': 7,
};

// King Wen number: [upper][lower] in the order above.
const _kingWen = [
  [1, 25, 6, 33, 12, 44, 13, 10],
  [34, 51, 40, 62, 16, 32, 55, 54],
  [5, 3, 29, 39, 8, 48, 63, 60],
  [26, 27, 4, 52, 23, 18, 22, 41],
  [11, 24, 7, 15, 2, 46, 36, 19],
  [9, 42, 59, 53, 20, 57, 37, 61],
  [14, 21, 64, 56, 35, 50, 30, 38],
  [43, 17, 47, 31, 45, 28, 49, 58],
];

/// Hexagram number 1–64 from six yin/yang flags, bottom line first.
int hexagram(List<bool> yang) {
  String t(int from) =>
      [for (var i = from; i < from + 3; i++) yang[i] ? '1' : '0'].join();
  return _kingWen[_trigrams[t(3)]!][_trigrams[t(0)]!];
}

/// Primary hexagram, and the one it changes into (null when no line changes).
(int, int?) readLines(List<int> lines) {
  final primary = hexagram([for (final l in lines) isYang(l)]);
  if (!lines.any(isChanging)) return (primary, null);
  return (
    primary,
    hexagram([for (final l in lines) isChanging(l) ? !isYang(l) : isYang(l)]),
  );
}

/// (upper, lower) trigram indices in the order Qian, Zhen, Kan, Gen, Kun, Xun, Li, Dui.
(int, int) trigramsOf(List<bool> yang) {
  String t(int from) =>
      [for (var i = from; i < from + 3; i++) yang[i] ? '1' : '0'].join();
  return (_trigrams[t(3)]!, _trigrams[t(0)]!);
}
