import 'astro.dart';
import 'numerology.dart';

/// Day meters, 1–5 each. They only summarise the same inputs the daily texts use
/// (Moon sign and phase against the person's sign, personal day number): a mood gauge,
/// not a measurement.
typedef DayMeters = ({int love, int work, int energy});

DayMeters dayMeters({
  required int sun,
  required int moon,
  required int phase,
  required int dayNumber,
}) {
  final r = elementRelation(elementOf(sun), elementOf(moon));
  int clamp(int v) => v.clamp(1, 5);
  const loveBase = {'same': 4, 'supportive': 5, 'neutral': 3, 'tense': 2};
  // 2 and 6 are the numbers of partnership and care; 7 turns inwards.
  final love =
      loveBase[r]! +
      (dayNumber == 2 || dayNumber == 6 ? 1 : 0) -
      (dayNumber == 7 ? 1 : 0);
  // 1, 4, 8: initiative, groundwork, results. 7 and 9: reflection and closing.
  const workBase = [0, 4, 3, 3, 5, 3, 3, 2, 5, 2];
  final work =
      workBase[dayNumber] +
      (phase >= 1 && phase <= 3 ? 1 : 0) - // waxing Moon: things build up
      (r == 'tense' ? 1 : 0);
  // New Moon lowest, full Moon highest.
  const phaseEnergy = [2, 3, 4, 4, 5, 3, 2, 2];
  final energy =
      phaseEnergy[phase] +
      (r == 'same' || r == 'supportive' ? 1 : 0) -
      (r == 'tense' ? 1 : 0) +
      (moon == sun ? 1 : 0);
  return (love: clamp(love), work: clamp(work), energy: clamp(energy));
}

/// Which text group a meter falls into.
String meterLevel(int meter) => meter <= 2
    ? 'low'
    : meter == 3
    ? 'mid'
    : 'high';

/// Days since 1970-01-01, the same number for everyone on a given date.
int dayIndex(CalendarDate d) =>
    DateTime.utc(d.year, d.month, d.day).millisecondsSinceEpoch ~/ 86400000;

/// Variant for texts keyed by the personal day number, which returns every 9 days:
/// each return shows the next variant.
int nineDayVariant(CalendarDate d, int count) => (dayIndex(d) ~/ 9) % count;

/// The kind of each daily message by its place in `messages.json` (index % 36):
/// K one small step, L people, S kindness to oneself, D noticing good things,
/// M strengths, C curiosity and hope. Small steps come most often because acting has
/// the strongest evidence for lifting mood; see docs/content-sources.md.
const messagePattern = 'KLKDMCKLSDKLMCKSDKLSDKMLCKSDLKMCSDLS';

/// Which of [count] daily messages shows on day [day]: every message once per pass, each
/// pass in a different order, and never the same kind two days running.
int messageIndex(int day, int count) {
  final pass = day ~/ count, k = day % count;
  // Steps of 1 mod 36 keep the pattern of kinds; coprime to the pool they skip nothing.
  const steps = [1, 37, 73, 109];
  final step = steps[pass % steps.length];
  return step.gcd(count) == 1 ? (k * step + pass * 37) % count : k;
}
