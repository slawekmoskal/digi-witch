import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../engine/astro.dart';
import '../engine/numerology.dart';
import '../reminders.dart';
import 'journal_screen.dart';
import 'numerology_screen.dart';
import 'astro_screens.dart';
import 'settings_screen.dart';
import 'tarot_screen.dart';
import 'widgets.dart';

/// Today, ordered for a ten-second visit: greeting, the day's kind words, then the ritual
/// (turn the card, tap the mood) in plain sight. Reading matter follows for those who
/// stay: horoscope / numbers, suggestions, prompt, what's coming.
class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  // The pager keeps its page when the layout switches between one and two columns.
  static final _pagerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final s = context.store;
    final now = DateTime.now();
    final prompts = context.content.prompts;
    // Prompt of the day rotates by day-of-year, deterministic, no randomness needed.
    final prompt =
        prompts[(now.difference(DateTime(now.year)).inDays + now.year) %
            prompts.length];
    final birth = s.birthDate;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.appTitle),
        leadingWidth: topLeadingWidth,
        leading: topLeading(context),
        actions: [
          IconButton(
            tooltip: l.settings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => pushScreen(context, const SettingsScreen()),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, box) {
          final main = <Widget>[
            Text(
              [
                now.hour < 18 ? l.greetDay : l.greetEvening,
                // First name only; the full name is for numerology.
                if (s.fullName?.trim().split(' ').first case final n?
                    when n.isNotEmpty)
                  n,
              ].join(', '),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              MaterialLocalizations.of(context).formatFullDate(now),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: gap / 2),
            DayMessage(now, dots: true),
            const DailyRitual(),
            // Once a week: writing three good things down is the gratitude exercise with
            // the best evidence, and weekly worked better than more often.
            if (now.weekday == DateTime.sunday)
              Center(
                child: TextButton.icon(
                  icon: const Icon(Icons.edit_note),
                  label: Text(l.threeGood),
                  onPressed: () => pushScreen(
                    context,
                    EntryEditor(promptText: l.threeGoodPrompt),
                  ),
                ),
              ),
          ];
          final pager = <Widget>[
            const SizedBox(height: gap / 2),
            DayPager(key: _pagerKey, [
              (
                Icons.auto_awesome_outlined,
                l.dayHoroscope,
                birth != null
                    ? HoroscopeCard(birth, now, short: true)
                    : const BirthPrompt(),
              ),
              if (birth != null)
                (
                  Icons.tag,
                  l.dayNumbers,
                  ProfileNumbers(
                    birth,
                    name: s.fullName,
                    onOpen: () => homeTab.value = 3,
                  ),
                ),
            ]),
          ];
          final side = <Widget>[
            SectionTitle(l.suggested),
            TileGrid(suggestions(context, now)),
            SectionTitle(l.promptOfDay),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prompt.text,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SaveReflectionButton(prompt: prompt.text),
                  ],
                ),
              ),
            ),
            Countdowns(now), // always the last thing on the page
          ];
          // Unfolded / landscape: the ritual on the left, the horoscope and what's next on
          // the right, so the horoscope is there at once.
          final two = box.maxWidth >= 760;
          return ListView(
            padding: pagePadding(context, maxWidth: two ? 1040 : 720),
            children: two
                ? [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: main,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [...pager, ...side],
                          ),
                        ),
                      ],
                    ),
                  ]
                : [...main, ...pager, ...side],
          );
        },
      ),
    );
  }
}

/// One framed card at a time — horoscope, numbers — switched by the buttons above or a
/// sideways swipe. Heights differ per page
/// (and with text scale), hence a switcher that sizes to its child rather than a PageView.
class DayPager extends StatefulWidget {
  /// (icon, label, page)
  final List<(IconData, String, Widget)> pages;
  const DayPager(this.pages, {super.key});
  @override
  State<DayPager> createState() => _DayPagerState();
}

class _DayPagerState extends State<DayPager> {
  var _i = 0;

  void _go(int i) {
    if (i < 0 || i >= widget.pages.length || i == _i) return;
    HapticFeedback.selectionClick();
    setState(() => _i = i);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final pages = widget.pages;
    final i = _i.clamp(0, pages.length - 1); // profile removed → fewer pages
    final still = context.reduceMotion;
    return Column(
      children: [
        // Clear buttons, the chosen one filled; none when there is a single page.
        if (pages.length > 1)
          Row(
            children: [
              for (var k = 0; k < pages.length; k++)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: k == 0 ? 0 : gap),
                    child: Semantics(
                      button: true,
                      selected: k == i,
                      child: Material(
                        color: k == i ? cs.primary : cs.surfaceContainerHigh,
                        elevation: k == i ? 3 : 0,
                        shadowColor: cs.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(
                            color: k == i ? cs.primary : cs.outlineVariant,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => _go(k),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 6,
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  pages[k].$1,
                                  size: 26,
                                  color: k == i ? cs.onPrimary : cs.primary,
                                ),
                                const SizedBox(height: 6),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    pages[k].$2,
                                    style: t.labelLarge?.copyWith(
                                      color: k == i
                                          ? cs.onPrimary
                                          : cs.onSurface,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        const SizedBox(height: gap / 2),
        GestureDetector(
          onHorizontalDragEnd: (d) {
            final v = d.primaryVelocity ?? 0;
            if (v.abs() > 200) _go(i + (v < 0 ? 1 : -1));
          },
          child: AnimatedSize(
            duration: still ? Duration.zero : const Duration(milliseconds: 220),
            alignment: Alignment.topCenter,
            curve: Curves.easeOut,
            child: AnimatedSwitcher(
              duration: still
                  ? Duration.zero
                  : const Duration(milliseconds: 220),
              child: KeyedSubtree(key: ValueKey(i), child: pages[i].$3),
            ),
          ),
        ),
      ],
    );
  }
}

class DayStrip extends StatelessWidget {
  final DateTime now;
  const DayStrip(this.now, {super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final a = context.content.astro;
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final noon = noonOf(now);
    final birth = context.store.birthDate;
    final day = birth == null
        ? null
        : personalDay(birth, CalendarDate.fromDateTime(now)).value!;
    Widget item(Widget top, String value, String label) => Expanded(
      child: Column(
        children: [
          SizedBox(height: 40, child: Center(child: top)),
          const SizedBox(height: 4),
          Text(value, textAlign: TextAlign.center, style: t.titleSmall),
          Text(label, textAlign: TextAlign.center, style: t.bodySmall),
        ],
      ),
    );
    return Card(
      child: InkWell(
        onTap: () => pushScreen(context, const MoonCalendarScreen()),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              item(
                Icon(Icons.dark_mode_outlined, size: 32, color: cs.tertiary),
                a.phases[moonPhase(noon)].name,
                l.notifMoon(a.signs[moonSign(noon)].locative),
              ),
              if (day != null) ...[
                item(
                  NumberBadge('$day', size: 40),
                  context.content
                          .interpretation(Indicator.personalDay, day)
                          ?.title ??
                      '',
                  l.dayNumberShort,
                ),
                item(
                  Icon(Icons.palette_outlined, size: 32, color: cs.tertiary),
                  context.content.numerologyExtra.dayColors[day]!,
                  l.dayColorShort,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// No birth date yet: one field away from the horoscope.
class BirthPrompt extends StatelessWidget {
  const BirthPrompt({super.key});
  @override
  Widget build(BuildContext context) => TarotFrame(
    child: Column(
      children: [
        Text(
          context.l.horoscopeFor,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(context.l.horoscopeNeedsBirth, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        const QuickProfile(),
      ],
    ),
  );
}

/// Birth date entry right on Today, so the horoscope is one step away.
class QuickProfile extends StatefulWidget {
  const QuickProfile({super.key});
  @override
  State<QuickProfile> createState() => _QuickProfileState();
}

class _QuickProfileState extends State<QuickProfile> {
  final _c = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _save() {
    final l = context.l;
    final d = parseUserDate(_c.text);
    final today = CalendarDate.fromDateTime(DateTime.now());
    setState(() {
      _error = d == null
          ? l.dateInvalid
          : d.compareTo(today) > 0
          ? l.dateFuture
          : null;
    });
    if (_error == null) {
      FocusScope.of(context).unfocus();
      context.store.saveProfile(d, context.store.fullName);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      TextField(
        controller: _c,
        keyboardType: TextInputType.number,
        inputFormatters: [DateMaskFormatter()],
        onSubmitted: (_) => _save(),
        decoration: InputDecoration(
          labelText: context.l.birthDate,
          hintText: context.l.dateHint,
          errorText: _error,
          prefixIcon: const Icon(Icons.cake_outlined),
          suffixIcon: datePickerButton(context, _c),
        ),
      ),
      const SizedBox(height: 10),
      FilledButton(onPressed: _save, child: Text(context.l.showMyHoroscope)),
      const SizedBox(height: 6),
      Text(
        context.l.privacyShort,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );
}

/// The ten-second daily ritual: turn today's card, tap how you feel.
class DailyRitual extends StatefulWidget {
  const DailyRitual({super.key});
  @override
  State<DailyRitual> createState() => _DailyRitualState();
}

/// Mood 1…5 as (outlined, filled) faces.
const _moodIcons = [
  (
    Icons.sentiment_very_dissatisfied_outlined,
    Icons.sentiment_very_dissatisfied,
  ),
  (Icons.sentiment_dissatisfied_outlined, Icons.sentiment_dissatisfied),
  (Icons.sentiment_neutral_outlined, Icons.sentiment_neutral),
  (Icons.sentiment_satisfied_outlined, Icons.sentiment_satisfied),
  (Icons.sentiment_very_satisfied_outlined, Icons.sentiment_very_satisfied),
];

class _DailyRitualState extends State<DailyRitual> {
  bool _justRevealed = false;

  // The morning reminder, offered once, right after a card was turned.
  Future<void> _remind() async {
    final s = context.store;
    final denied = context.l.reminderDenied;
    final messenger = ScaffoldMessenger.of(context);
    const at = 8 * 60;
    final ok = await Reminders.enable(dailyReminderEvents(context, at));
    s.reminderAsked = true;
    if (ok) {
      s.reminderMinutes = at;
    } else {
      messenger.showSnackBar(SnackBar(content: Text(denied)));
    }
  }

  Widget _weekDay(BuildContext context, DateTime day) {
    final cs = Theme.of(context).colorScheme;
    final loc = MaterialLocalizations.of(context);
    final m = context.store.moods[CalendarDate.fromDateTime(day).iso];
    return Semantics(
      label:
          '${loc.formatMediumDate(day)}: ${m == null ? '–' : context.l.moodName('$m')}',
      excludeSemantics: true,
      child: Column(
        children: [
          Text(
            loc.narrowWeekdays[day.weekday % 7], // the list starts on Sunday
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(
            height: 24,
            child: m == null
                ? Icon(Icons.circle, size: 6, color: cs.outlineVariant)
                : Icon(_moodIcons[m - 1].$2, size: 22, color: cs.tertiary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final s = context.store;
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final today = CalendarDate.fromDateTime(now);
    final card = s.cardOfDay(today);
    final face = context.content.cards[card.cardId]!;
    // Pro: the widgets already show the card, so the app shows it too, turning once the
    // first time it is seen that day (and logging it in "Your days" as a tap would).
    final autoTurn = s.isPro && !s.cardRevealed(today);
    if (autoTurn) {
      _justRevealed = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => s.revealCard(today));
    }
    final revealed = autoTurn || s.cardRevealed(today);
    final mood = s.moods[today.iso];
    void reveal() {
      HapticFeedback.mediumImpact();
      setState(() => _justRevealed = true);
      s.revealCard(today);
    }

    void details() => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CardDetail(face, reversed: card.reversed),
      ),
    );
    const w = 84.0;
    return TarotFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                button: true,
                label: revealed ? l.cardOfDayMore : l.revealCard,
                child: GestureDetector(
                  onTap: revealed ? details : reveal,
                  child: !revealed
                      ? const CardBack(width: w)
                      : _justRevealed && !context.reduceMotion
                      ? FlipCard(
                          card: card,
                          width: w,
                          duration: const Duration(milliseconds: 700),
                          start: 0,
                        )
                      : CardFace(face, reversed: card.reversed, width: w),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.cardOfDay, style: t.headlineSmall),
                    const SizedBox(height: 4),
                    if (!revealed) ...[
                      Text(l.revealCardHint),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: reveal,
                        child: Text(l.revealCard),
                      ),
                    ] else ...[
                      Text(
                        '${face.name}${card.reversed ? ' (${l.reversed})' : ''}',
                        style: t.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        card.reversed ? face.adviceReversed : face.advice,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      TextButton(
                        onPressed: details,
                        child: Text(l.cardOfDayMore),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l.moodQuestion,
            style: t.titleMedium,
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  tooltip: l.moodName('$i'),
                  isSelected: mood == i,
                  iconSize: 32,
                  color: cs.onSurfaceVariant,
                  selectedIcon: Icon(_moodIcons[i - 1].$2, color: cs.tertiary),
                  icon: Icon(_moodIcons[i - 1].$1),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    s.setMood(today, mood == i ? null : i);
                  },
                ),
            ],
          ),
          if (mood != null) ...[
            Text(
              '${l.moodName('$mood')}. ${l.moodReply('$mood')}',
              textAlign: TextAlign.center,
            ),
            if (mood == 1)
              Center(
                child: TextButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (c) => AlertDialog(
                      title: Text(l.help),
                      content: Text(l.helpBody),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(c),
                          child: Text(
                            MaterialLocalizations.of(c).closeButtonLabel,
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: Text(l.help),
                ),
              ),
            Text(l.moodSaved, textAlign: TextAlign.center, style: t.bodySmall),
            const SizedBox(height: 8),
            // What the tap is for: the last seven days at a glance. A day without a mood
            // is just a dot — nothing is counted, nothing is lost.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var back = 6; back >= 0; back--)
                  _weekDay(
                    context,
                    DateTime(now.year, now.month, now.day - back),
                  ),
              ],
            ),
          ],
          if (revealed && mood != null) ...[
            const SizedBox(height: 8),
            // Closure for today, curiosity for tomorrow; no streaks.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 20, color: cs.tertiary),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    '${l.dayDone} ${tomorrowTeaser(context, now)}',
                    style: t.titleSmall,
                  ),
                ),
              ],
            ),
          ],
          if (revealed &&
              Reminders.supported &&
              s.reminderMinutes == null &&
              !s.reminderAsked) ...[
            const Divider(height: 28),
            Text(
              l.reminderAsk,
              style: t.titleSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              l.reminderAskSub,
              style: t.bodySmall,
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => s.reminderAsked = true,
                  child: Text(l.reminderNo),
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: _remind,
                  child: Text(l.reminderYes),
                ),
              ],
            ),
          ],
          if (s.moods.isNotEmpty || s.cardLog.isNotEmpty)
            Center(
              child: TextButton.icon(
                icon: const Icon(Icons.history),
                label: Text(l.lookBack),
                onPressed: () => pushScreen(context, const LookBackScreen()),
              ),
            ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            icon: const Icon(Icons.style_outlined),
            label: Text(l.layTarot),
            onPressed: () => homeTab.value = 1,
          ),
        ],
      ),
    );
  }
}

/// "Your days": every day with a turned card or a mood, newest first. Only days that
/// have something — no gaps to feel bad about, nothing counted.
class LookBackScreen extends StatelessWidget {
  const LookBackScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final s = context.store;
    final a = context.content.astro;
    final cs = Theme.of(context).colorScheme;
    final moods = s.moods, cards = s.cardLog;
    final days = {...moods.keys, ...cards.keys}.toList()
      ..sort((x, y) => y.compareTo(x));
    return Scaffold(
      appBar: AppBar(title: Text(l.lookBack)),
      body: ListView(
        padding: screenPadding(context),
        children: [
          Text(l.lookBackHint),
          const SizedBox(height: 8),
          for (final iso in days)
            if (DateTime.tryParse(iso) case final day?)
              () {
                final card = cards[iso];
                final face = card == null
                    ? null
                    : context.content.cards[card.cardId];
                final mood = moods[iso];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: SizedBox(
                    width: 40,
                    child: face == null
                        ? null
                        : CardFace(face, reversed: card!.reversed, width: 40),
                  ),
                  title: Text(
                    MaterialLocalizations.of(context).formatFullDate(day),
                  ),
                  subtitle: Text(
                    [
                      if (face != null)
                        '${face.name}${card!.reversed ? ' (${l.reversed})' : ''}',
                      a.phases[moonPhase(noonOf(day))].name,
                    ].join(' · '),
                  ),
                  trailing: mood == null || mood < 1 || mood > 5
                      ? null
                      : Icon(
                          _moodIcons[mood - 1].$2,
                          color: cs.tertiary,
                          semanticLabel: l.moodName('$mood'),
                        ),
                  onTap: face == null
                      ? null
                      : () => pushScreen(
                          context,
                          CardDetail(face, reversed: card!.reversed),
                        ),
                );
              }(),
        ],
      ),
    );
  }
}

/// "Full moon in 3 days" and similar in a framed list, each with its sign (Moon, planet,
/// birthday); a tap opens the Moon calendar.
class Countdowns extends StatelessWidget {
  final DateTime now;
  const Countdowns(this.now, {super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final phases = {for (final p in context.content.astro.phases) p.name};
    return TarotFrame(
      child: Column(
        children: [
          Icon(Icons.nightlight_round, color: cs.tertiary, size: 28),
          const SizedBox(height: 6),
          Semantics(header: true, child: Text(l.upcoming, style: t.titleLarge)),
          const SizedBox(height: 8),
          for (final (what, days) in countdowns(context, now))
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => pushScreen(context, const MoonCalendarScreen()),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 4,
                ),
                child: Row(
                  children: [
                    Icon(
                      what == l.yourBirthday
                          ? Icons.cake_outlined
                          : phases.contains(what)
                          ? Icons.dark_mode_outlined
                          : Icons.public, // eclipses, Mercury
                      color: cs.primary,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        days == null ? what : l.countdown(what, days),
                        style: t.bodyLarge,
                      ),
                    ),
                    Icon(Icons.chevron_right, color: cs.outline, size: 20),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
