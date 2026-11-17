import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/places.dart';
import '../l10n/app_localizations.dart';
import '../reminders.dart';
import '../data/content.dart' show Daily;
import '../engine/astro.dart';
import '../engine/daily.dart';
import '../engine/lang.dart';
import '../engine/numerology.dart';
import '../engine/tarot.dart' show DrawnCard;
import 'iching_screen.dart';
import 'journal_screen.dart';
import 'numerology_screen.dart';
import 'today_screen.dart' show BirthPrompt;
import 'widgets.dart';

/// Moon position used for "today": local noon, so the text is stable all day.
DateTime noonOf(DateTime now) => DateTime(now.year, now.month, now.day, 12);

/// Lucky numbers; a tap opens the number's meaning in a panel right below (tap again or
/// the X closes it).
class _LuckyNumbers extends StatefulWidget {
  final List<int> numbers;
  const _LuckyNumbers(this.numbers);
  @override
  State<_LuckyNumbers> createState() => _LuckyNumbersState();
}

class _LuckyNumbersState extends State<_LuckyNumbers> {
  int? _open;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final n = widget.numbers.contains(_open) ? _open : null;
    final r = n == null ? 0 : reduceSteps(n, const {}).last;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Three equal thirds of the width, each a large tap target with a hint under it.
        Row(
          children: [
            for (final x in widget.numbers)
              Expanded(
                child: Semantics(
                  button: true,
                  selected: x == n,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => setState(() => _open = x == n ? null : x),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: x == n
                                  ? cs.tertiary.withValues(alpha: 0.28)
                                  : Colors.transparent,
                            ),
                            child: NumberBadge('$x', size: 72),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.l.tapHint,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        AnimatedSize(
          duration: context.reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: n == null
              ? const SizedBox(width: double.infinity)
              : Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          liveRegion: true,
                          child: Text(
                            context.l.luckyMeaning(
                              n,
                              r,
                              context.content.numerologyExtra.keywords[r]!,
                            ),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        tooltip: context.l.hide,
                        onPressed: () => setState(() => _open = null),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

/// "Dziś dla Ciebie": sun sign × today's Moon × personal day number.
class HoroscopeCard extends StatelessWidget {
  final CalendarDate birth;
  final DateTime now;

  /// Today shows the short version (day + caution) with a link to the full one in Stars.
  final bool short;
  const HoroscopeCard(this.birth, this.now, {super.key, this.short = false});

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final a = context.content.astro;
    final t = Theme.of(context).textTheme;
    final today = CalendarDate.fromDateTime(now);
    final noon = noonOf(now);
    final sign = sunSign(birth), moon = moonSign(noon);
    final relation = elementRelation(elementOf(sign), elementOf(moon));
    final day = personalDay(birth, today).value!;
    final chinese = a.chinese[chineseSign(birth)];
    final phase = a.phases[moonPhase(noon)];

    final cs = Theme.of(context).colorScheme;
    Widget block(String label, String text) => LabeledBlock(label, Text(text));
    // Today shows these two; in Stars they follow the parts Today leaves out.
    final (todayLine, cautionLine) = dayHoroscope(context, birth, now);
    final reading = dailyReading(context, birth, now);
    // The reading leads the card; languages without it keep the older two blocks. The
    // dots are numbers, not text, so every language shows them: on Today in the day's
    // message at the top, in Stars here with a sentence each.
    final dots = metersFor(birth, now);
    final lead = reading == null
        ? [
            block(l.horoscopeToday, todayLine),
            block(l.horoscopeCaution, cautionLine),
            if (!short) ...[
              const SizedBox(height: 24),
              Meter(l.loveLabel, dots.love, null),
              Meter(l.workLabel, dots.work, null),
              Meter(l.energyLabel, dots.energy, null),
            ],
          ]
        : [
            if (birth.month == today.month && birth.day == today.day)
              block(l.yourBirthday, context.content.daily!.birthday),
            // Today opens with the mood; Stars with what may happen, then the three areas.
            // Today is the short read: mood and advice (the dots are in the day's message).
            // Stars opens with what may happen and says a sentence about each area.
            if (short) block(l.dailyMood, reading.mood),
            if (!short) ...[
              block(l.dailyEvents, reading.events),
              const SizedBox(height: 24),
              Meter(l.loveLabel, reading.meters.love, reading.love),
              Meter(l.workLabel, reading.meters.work, reading.work),
              Meter(l.energyLabel, reading.meters.energy, reading.energy),
              block(l.dailyMood, reading.mood),
            ],
            block(l.dailyAdvice, reading.advice),
          ];
    return TarotFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              l.horoscopeFor.toUpperCase(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: cs.secondary,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              a.signs[sign].name,
              style: t.displaySmall?.copyWith(color: cs.primary),
            ),
          ),
          Center(
            child: Text(
              '${a.elements[elementOf(sign)]} · ${a.signs[sign].dates}',
              style: t.bodySmall,
            ),
          ),
          const SizedBox(height: 8),
          if (short) ...[
            ...lead,
            const SizedBox(height: 8),
            // What the text is based on: the Moon (opens its calendar) and the day's colour.
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.dark_mode_outlined, size: 18),
                  label: Text(
                    '${phase.name} · ${l.notifMoon(a.signs[moon].locative)}',
                  ),
                  onPressed: () =>
                      pushScreen(context, const MoonCalendarScreen()),
                ),
                Chip(
                  avatar: const Icon(Icons.palette_outlined, size: 18),
                  label: Text(
                    l.dayColor(context.content.numerologyExtra.dayColors[day]!),
                  ),
                ),
              ],
            ),
          ],
          if (short) ...[
            const SizedBox(height: 12),
            Center(
              child: FilledButton.tonal(
                onPressed: () => homeTab.value = 0,
                child: Text(l.fullHoroscope),
              ),
            ),
          ] else ...[
            // Most wanted first: the reading, then the numbers, the sky behind it last.
            ...lead,
            const SizedBox(height: 16),
            // The day's number as the centrepiece, the lucky numbers centred under it.
            Center(
              child: Column(
                children: [
                  NumberBadge('$day', size: 104),
                  const SizedBox(height: 10),
                  Text(
                    l.indicatorName('personalDay'),
                    style: t.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    context.content
                            .interpretation(Indicator.personalDay, day)
                            ?.title ??
                        '',
                    style: t.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            LabeledBlock(
              l.luckyNumbers,
              centered: true,
              Column(
                children: [
                  _LuckyNumbers(luckyNumbers(birth, today)),
                  const SizedBox(height: 10),
                  Text(
                    l.dayColor(context.content.numerologyExtra.dayColors[day]!),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l.luckyNote,
                    style: t.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            block(
              l.horoscopeStars,
              '${l.moonIn(a.signs[moon].locative, phase.name.midSentence)} ${phase.text}',
            ),
            if (personalTransits(context, birth, noon) case final tr
                when tr.isNotEmpty)
              LabeledBlock(
                l.forYouToday,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final x in tr)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(x),
                      ),
                  ],
                ),
              ),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text(l.whyThis),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.whySign(
                    a.signs[sign].name,
                    a.signs[sign].dates,
                    a.elements[elementOf(sign)]!,
                    chinese.name,
                    chinese.text,
                  ),
                ),
                const SizedBox(height: 8),
                Text(a.signs[sign].text),
                const SizedBox(height: 4),
                Text(
                  l.signExtras(
                    a.signs[sign].color,
                    a.signs[sign].stone,
                    a.signs[sign].day,
                    a.signs[sign].planet,
                  ),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  l.whyMoon(
                    a.signs[moon].name,
                    a.elements[elementOf(moon)]!,
                    relation,
                  ),
                ),
                const SizedBox(height: 8),
                Text(l.whyMethod, style: t.bodySmall),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class MoonCard extends StatelessWidget {
  final DateTime now;
  const MoonCard(this.now, {super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final a = context.content.astro;
    final noon = noonOf(now);
    return Card(
      child: ListTile(
        leading: const Icon(Icons.dark_mode_outlined),
        title: Text(l.moonToday),
        subtitle: Text(
          [
            l.moonState(
              a.phases[moonPhase(noon)].name,
              (illumination(noon) * 100).round(),
              a.signs[moonSign(noon)].locative,
            ),
            for (final (start, end) in mercuryRetrogrades(noon, noon))
              if (!start.isAfter(noon)) l.mercuryNow(_ddmm(end.toLocal())),
            for (final e in eclipses(
              noon.toUtc(),
              noon.toUtc().add(const Duration(days: 7)),
            ))
              l.eclipseSoon(
                '${l.evEclipse(_eclipseKind(e.kind))}, ${_ddmm(e.utc.toLocal())}',
              ),
          ].join('\n'),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const MoonCalendarScreen())),
      ),
    );
  }
}

class MoonCalendarScreen extends StatelessWidget {
  const MoonCalendarScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final a = context.content.astro;
    final loc = MaterialLocalizations.of(context);
    final events = phaseEvents(DateTime.now().toUtc(), 12);
    return Scaffold(
      appBar: AppBar(title: Text(l.moonCalendar)),
      body: ListView(
        padding: screenPadding(context),
        children: [
          LabeledBlock(
            l.mercuryRetro,
            Builder(
              builder: (context) {
                final now = DateTime.now();
                final periods = mercuryRetrogrades(
                  now,
                  now.add(const Duration(days: 365)),
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.mercury),
                    const SizedBox(height: 6),
                    if (periods.isEmpty) Text(l.mercuryNone),
                    for (final (s, e) in periods)
                      Text(
                        '${loc.formatMediumDate(s.toLocal())} – ${loc.formatMediumDate(e.toLocal())}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                  ],
                );
              },
            ),
          ),
          LabeledBlock(
            l.eclipsesTitle,
            Builder(
              builder: (context) {
                final now = DateTime.now().toUtc();
                final list = eclipses(now, now.add(const Duration(days: 365)));
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final e in list)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          '${loc.formatMediumDate(e.utc.toLocal())} — ${l.evEclipse(_eclipseKind(e.kind))}\n'
                          '${a.eclipseText[e.kind == EclipseKind.solar ? 'solar' : 'lunar']}',
                        ),
                      ),
                    Text(
                      l.eclipseVisibility,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                );
              },
            ),
          ),
          SectionTitle(l.upcomingPhases),
          Text(l.moonCalendarIntro),
          for (final e in events)
            Card(
              child: ListTile(
                title: Text(a.phases[e.phase].name),
                subtitle: Text(
                  '${loc.formatFullDate(e.utc.toLocal())}, '
                  '${loc.formatTimeOfDay(TimeOfDay.fromDateTime(e.utc.toLocal()), alwaysUse24HourFormat: true)}\n'
                  '${a.phases[e.phase].text}',
                ),
                isThreeLine: true,
              ),
            ),
          SectionTitle(l.dayByDay),
          for (var i = 0; i < 30; i++)
            Builder(
              builder: (context) {
                final n = DateTime.now();
                final day = noonOf(DateTime(n.year, n.month, n.day + i));
                final sign = moonSign(day);
                final type = a.dayTypes[elementOf(sign)]!;
                final waxing = elongation(day) < 180;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(loc.formatFullDate(day)),
                  subtitle: Text(
                    '${l.moonDayLine(a.signs[sign].locative, a.phases[moonPhase(day)].name.midSentence)}\n'
                    '${type.name}: ${type.text}\n'
                    '${a.haircut[waxing ? 'waxing' : 'waning']}',
                  ),
                  isThreeLine: true,
                );
              },
            ),
        ],
      ),
    );
  }
}

class CompatibilityScreen extends StatefulWidget {
  const CompatibilityScreen({super.key});
  @override
  State<CompatibilityScreen> createState() => _CompatibilityScreenState();
}

class _CompatibilityScreenState extends State<CompatibilityScreen> {
  final _a = TextEditingController(), _b = TextEditingController();
  String? _errA, _errB;
  (CalendarDate, CalendarDate)? _pair;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final birth = context.store.birthDate;
    if (_a.text.isEmpty && birth != null) _a.text = birth.display;
  }

  @override
  void dispose() {
    _a.dispose();
    _b.dispose();
    super.dispose();
  }

  String? _validate(CalendarDate? d) {
    final l = context.l;
    if (d == null) return l.dateInvalid;
    return d.compareTo(CalendarDate.fromDateTime(DateTime.now())) > 0
        ? l.dateFuture
        : null;
  }

  void _check() {
    final a = parseUserDate(_a.text), b = parseUserDate(_b.text);
    setState(() {
      _errA = _validate(a);
      _errB = _validate(b);
      _pair = _errA == null && _errB == null ? (a!, b!) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final astro = context.content.astro;
    Widget field(TextEditingController c, int n, String? err) => Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextField(
        controller: c,
        keyboardType: TextInputType.number,
        inputFormatters: [DateMaskFormatter()],
        decoration: InputDecoration(
          labelText: l.personDate(n),
          hintText: context.l.dateHint,
          errorText: err,
          suffixIcon: datePickerButton(context, c),
        ),
      ),
    );
    String person(int n, CalendarDate d) {
      final s = sunSign(d);
      return l.personLine(
        n,
        astro.signs[s].name,
        astro.elements[elementOf(s)]!,
        astro.chinese[chineseSign(d)].name,
        lifePath(d).value!,
      );
    }

    final p = _pair;
    return Scaffold(
      appBar: AppBar(title: Text(l.compatibility)),
      body: ListView(
        padding: screenPadding(context),
        children: [
          Text(l.compatIntro),
          field(_a, 1, _errA),
          field(_b, 2, _errB),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(onPressed: _check, child: Text(l.check)),
          ),
          if (p != null) ...[
            const SizedBox(height: 12),
            Text(person(1, p.$1)),
            Text(person(2, p.$2)),
            LabeledBlock(
              l.compatElements,
              Text(
                astro.compat[elementRelation(
                  elementOf(sunSign(p.$1)),
                  elementOf(sunSign(p.$2)),
                )]!,
              ),
            ),
            LabeledBlock(
              l.chineseCompatTitle,
              Text(
                '${astro.chinese[chineseSign(p.$1)].name} + ${astro.chinese[chineseSign(p.$2)].name}: '
                '${astro.chineseCompat[chineseRelation(chineseSign(p.$1), chineseSign(p.$2))]}',
              ),
            ),
            const SizedBox(height: 8),
            ResultCard(relation(p.$1, p.$2)),
          ],
        ],
      ),
    );
  }
}

// Short date: "13.11" in Polish; other languages spell the month ("Nov 13") to avoid day/month confusion.
String _ddmm(DateTime t) => appLang != 'pl'
    ? DateFormat.MMMd(appLang).format(t)
    : '${t.day.toString().padLeft(2, '0')}.${t.month.toString().padLeft(2, '0')}';
String _hhmm(int minutes) =>
    '${(minutes ~/ 60).toString().padLeft(2, '0')}:${(minutes % 60).toString().padLeft(2, '0')}';
String _deg(double d) => d.toStringAsFixed(1).replaceAll('.', ',');

/// Sun, Moon and ascendant ("big three") from the saved birth date, time and place.
class BirthChartScreen extends StatelessWidget {
  const BirthChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final s = context.store;
    final a = context.content.astro;
    final t = Theme.of(context).textTheme;
    final birth = s.birthDate;
    final minutes = s.birthMinutes;
    final place = placeNamed(s.birthPlace);

    Widget body;
    if (birth == null) {
      body = Text(l.needBirthDate);
    } else {
      final sun = sunSign(birth);
      // Without a place the Moon is still useful: assume Polish time.
      final zone = place?.tz ?? 'Europe/Warsaw';
      final utc = minutes == null ? null : localToUtc(birth, minutes, zone);
      final moonA = moonSign(utc ?? localToUtc(birth, 0, zone));
      final moonB = utc == null
          ? moonSign(localToUtc(birth, 1439, zone))
          : moonA;
      final asc = utc != null && place != null
          ? ascendant(utc, place.lat, place.lon)
          : null;
      final trace = <String>[
        if (utc != null)
          l.traceTime(_hhmm(minutes!), _hhmm(utc.hour * 60 + utc.minute), zone),
        if (utc != null)
          l.traceMoon(_deg(moonLongitude(utc)), a.signs[moonA].name),
        if (asc != null)
          l.traceAsc(
            _deg(asc),
            a.signs[asc ~/ 30].name,
            placeDisplay(place!),
            _deg(place.lat),
            _deg(place.lon),
          ),
      ];
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.schedule),
            title: Text(l.birthTime),
            subtitle: Text(minutes == null ? l.notGiven : _hhmm(minutes)),
            trailing: minutes == null
                ? null
                : TextButton(
                    onPressed: () => s.saveBirthDetails(null, s.birthPlace),
                    child: Text(l.clear),
                  ),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                  hour: (minutes ?? 720) ~/ 60,
                  minute: (minutes ?? 720) % 60,
                ),
                builder: (c, child) => MediaQuery(
                  data: MediaQuery.of(c).copyWith(alwaysUse24HourFormat: true),
                  child: child!,
                ),
              );
              if (picked != null) {
                s.saveBirthDetails(
                  picked.hour * 60 + picked.minute,
                  s.birthPlace,
                );
              }
            },
          ),
          const SizedBox(height: 8),
          DropdownMenu<String>(
            // Key forces a rebuild when a custom place replaces the selection.
            key: ValueKey(s.birthPlace),
            expandedInsets: EdgeInsets.zero,
            initialSelection: place != null && cities.contains(place)
                ? placeLabel(place)
                : null,
            enableFilter: true,
            requestFocusOnTap: true,
            leadingIcon: const Icon(Icons.place_outlined),
            label: Text(l.birthPlace),
            onSelected: (v) => s.saveBirthDetails(minutes, v),
            dropdownMenuEntries: [
              for (final c in cities)
                DropdownMenuEntry(value: placeLabel(c), label: placeDisplay(c)),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              icon: const Icon(Icons.edit_location_alt_outlined),
              label: Text(
                place != null && !cities.contains(place)
                    ? l.otherPlaceSet(placeLabel(place), place.tz)
                    : l.otherPlace,
              ),
              onPressed: () async {
                final v = await showDialog<String>(
                  context: context,
                  builder: (_) => const OtherPlaceDialog(),
                );
                if (v != null) s.saveBirthDetails(minutes, v);
              },
            ),
          ),
          Text(l.placesNote, style: t.bodySmall),
          _BigThree(
            l.sunLabel,
            a.signs[sun].name,
            '${a.signs[sun].text}\n\n'
            '${l.loveLabel}: ${a.signs[sun].love}\n\n'
            '${l.workLabel}: ${a.signs[sun].work}\n\n'
            '${l.wellbeingLabel}: ${a.signs[sun].wellbeing}\n\n'
            '${l.signExtras(a.signs[sun].color, a.signs[sun].stone, a.signs[sun].day, a.signs[sun].planet)}',
          ),
          _BigThree(
            l.moonLabel,
            moonA == moonB
                ? a.signs[moonA].name
                : '${a.signs[moonA].name} / ${a.signs[moonB].name}',
            moonA == moonB
                ? a.moonSigns[moonA]
                : l.moonTwoSigns(a.signs[moonA].name, a.signs[moonB].name),
          ),
          _BigThree(
            l.ascLabel,
            asc == null ? '—' : a.signs[asc ~/ 30].name,
            asc == null ? l.ascNeeds : a.ascSigns[asc ~/ 30],
          ),
          if (trace.isNotEmpty)
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text(l.whyThis),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [for (final x in trace) Text(x)],
            ),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(l.bigThree)),
      body: ListView(
        padding: screenPadding(context),
        children: [
          Text(l.bigThreeIntro, style: t.bodySmall),
          body,
        ],
      ),
    );
  }
}

class _BigThree extends StatelessWidget {
  final String label, sign, text;
  const _BigThree(this.label, this.sign, this.text);
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
                color: cs.primary,
              ),
            ),
            Text(sign, style: t.headlineMedium?.copyWith(color: cs.primary)),
            const SizedBox(height: 6),
            Text(text),
          ],
        ),
      ),
    );
  }
}

class ChineseScreen extends StatelessWidget {
  const ChineseScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final a = context.content.astro;
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final birth = context.store.birthDate;
    if (birth == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.chineseTitle)),
        body: Padding(
          padding: screenPadding(context),
          child: Text(l.needBirthDate),
        ),
      );
    }
    final today = CalendarDate.fromDateTime(DateTime.now());
    final y = chineseYearOf(birth), sign = chineseSign(birth);
    final el = a.elements5[yearElement(y)]!;
    final cy = chineseYearOf(today), cySign = (cy - 4) % 12;
    String names(String rel) => [
      for (var i = 0; i < 12; i++)
        if (i != sign && chineseRelation(sign, i) == rel) a.chinese[i].name,
    ].join(', ');
    return Scaffold(
      appBar: AppBar(title: Text(l.chineseTitle)),
      body: ListView(
        padding: screenPadding(context),
        children: [
          TarotFrame(
            child: Column(
              children: [
                Text(
                  a.chinese[sign].name,
                  style: t.displaySmall?.copyWith(color: cs.primary),
                ),
                Text(
                  l.chineseBirthYear(
                    y,
                    el.name,
                    yearIsYang(y) ? 'yang' : 'yin',
                  ),
                  textAlign: TextAlign.center,
                  style: t.bodySmall,
                ),
                const SizedBox(height: 10),
                Text(a.chinese[sign].long),
              ],
            ),
          ),
          LabeledBlock(l.loveLabel, Text(a.chinese[sign].love)),
          LabeledBlock(l.workLabel, Text(a.chinese[sign].work)),
          LabeledBlock(l.chineseElement, Text('${el.name}. ${el.text}')),
          LabeledBlock(
            l.chineseCurrentYear(
              cy,
              a.chinese[cySign].name,
              a.elements5[yearElement(cy)]!.name,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a.yearForecast[chineseRelation(sign, cySign)]!),
                const SizedBox(height: 4),
                Text(
                  l.chineseYearSince(chineseNewYear(cy).display),
                  style: t.bodySmall,
                ),
              ],
            ),
          ),
          LabeledBlock(
            l.chineseCompatTitle,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${l.chineseFriend}: ${names('friend')}'),
                Text('${l.chineseTrine}: ${names('trine')}'),
                Text('${l.chineseClash}: ${names('clash')}'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(l.chineseNewYearNote, style: t.bodySmall),
        ],
      ),
    );
  }
}

/// Hand-typed place for births outside the list: latitude, longitude, time zone.
class OtherPlaceDialog extends StatefulWidget {
  const OtherPlaceDialog({super.key});
  @override
  State<OtherPlaceDialog> createState() => _OtherPlaceDialogState();
}

class _OtherPlaceDialogState extends State<OtherPlaceDialog> {
  final _lat = TextEditingController(), _lon = TextEditingController();
  String? _zone, _error;

  @override
  void dispose() {
    _lat.dispose();
    _lon.dispose();
    super.dispose();
  }

  double? _num(TextEditingController c) =>
      double.tryParse(c.text.trim().replaceAll(',', '.'));

  void _save() {
    final lat = _num(_lat), lon = _num(_lon);
    if (lat == null || lon == null || _zone == null) {
      setState(() => _error = context.l.otherPlaceMissing);
    } else if (lat.abs() >= 66 || lon.abs() > 180) {
      // Above the polar circles the ascendant is undefined part of the day.
      setState(() => _error = context.l.otherPlaceRange);
    } else {
      Navigator.of(context).pop(customPlace(lat, lon, _zone!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    const numKeys = TextInputType.numberWithOptions(
      decimal: true,
      signed: true,
    );
    return AlertDialog(
      title: Text(l.otherPlace),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.otherPlaceHelp,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _lat,
              keyboardType: numKeys,
              decoration: InputDecoration(
                labelText: l.latitude,
                hintText: '-12,05',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _lon,
              keyboardType: numKeys,
              decoration: InputDecoration(
                labelText: l.longitude,
                hintText: '-77,04',
              ),
            ),
            const SizedBox(height: 8),
            DropdownMenu<String>(
              expandedInsets: EdgeInsets.zero,
              enableFilter: true,
              requestFocusOnTap: true,
              menuHeight: 300,
              label: Text(l.timeZone),
              onSelected: (v) => _zone = v,
              dropdownMenuEntries: [
                for (final z in allZones())
                  DropdownMenuEntry(value: z, label: z),
              ],
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        FilledButton(onPressed: _save, child: Text(l.save)),
      ],
    );
  }
}

/// Moon sign at birth, or null when it is ambiguous (no time and the Moon changed sign that day).
int? birthMoonSign(CalendarDate birth, int? minutes, Place? place) {
  final zone = place?.tz ?? 'Europe/Warsaw';
  if (minutes != null) return moonSign(localToUtc(birth, minutes, zone));
  final a = moonSign(localToUtc(birth, 0, zone));
  return a == moonSign(localToUtc(birth, 1439, zone)) ? a : null;
}

/// Ascendant sign, only with both birth time and place.
int? birthAscSign(CalendarDate birth, int? minutes, Place? place) =>
    minutes == null || place == null
    ? null
    : ascendant(localToUtc(birth, minutes, place.tz), place.lat, place.lon) ~/
          30;

/// Today's sky against the user's chart: Moon over Sun/Moon/ascendant, opposite Moon, solar season, Mercury retrograde in the Sun sign.
List<String> personalTransits(
  BuildContext context,
  CalendarDate birth,
  DateTime noon,
) {
  final s = context.store;
  final tr = context.content.astro.transits;
  final place = placeNamed(s.birthPlace);
  final sun = sunSign(birth), moon = moonSign(noon);
  final bm = birthMoonSign(birth, s.birthMinutes, place);
  final asc = birthAscSign(birth, s.birthMinutes, place);
  final retro = mercuryRetrogrades(noon, noon).any((p) => !p.$1.isAfter(noon));
  return [
    if (moon == sun) tr['moonInSun']!,
    if (bm != null && moon == bm && bm != sun) tr['moonInMoon']!,
    if (asc != null && moon == asc && asc != sun && asc != bm) tr['moonInAsc']!,
    if (moon == (sun + 6) % 12) tr['moonOpposite']!,
    if (sunLongitude(noon) ~/ 30 == sun) tr['sunSeason']!,
    if (retro && mercuryLongitude(noon) ~/ 30 == sun) tr['mercuryInSun']!,
  ];
}

/// Next two new and two full moons, at 9:00 local on the day.
List<(DateTime, String, String)> moonReminderEvents(AppLocalizations l) => [
  for (final e in phaseEvents(DateTime.now().toUtc(), 8))
    if (e.phase == 0 || e.phase == 4)
      (
        DateTime(
          e.utc.toLocal().year,
          e.utc.toLocal().month,
          e.utc.toLocal().day,
          9,
        ),
        e.phase == 0 ? l.moonReminderNewTitle : l.moonReminderFullTitle,
        e.phase == 0 ? l.moonReminderNewBody : l.moonReminderFullBody,
      ),
];

/// Daily reminder texts for the next 30 days at [minutes] after midnight: that day's Moon,
/// new/full moon, personal day number. Everything is computed on the device.
List<(DateTime, String, String)> dailyReminderEvents(
  BuildContext context,
  int minutes,
) {
  final l = context.l;
  final a = context.content.astro;
  final birth = context.store.birthDate;
  final now = DateTime.now();
  final phases = {
    for (final e in phaseEvents(now.toUtc(), 8))
      if (e.phase == 0 || e.phase == 4)
        CalendarDate.fromDateTime(e.utc.toLocal()): a.phases[e.phase].name,
  };
  return [
    for (var i = 0; i < 31; i++)
      () {
        final d = DateTime(now.year, now.month, now.day + i);
        final day = CalendarDate.fromDateTime(d);
        return (
          d.add(Duration(minutes: minutes)),
          l.reminderTitle,
          [
            ?phases[day],
            l.notifMoon(a.signs[moonSign(noonOf(d))].locative),
            if (birth != null) l.notifDayNumber(personalDay(birth, day).value!),
            l.notifCard,
          ].join(' · '),
        );
      }(),
  ];
}

/// Upcoming moments worth a glance, as (what, days from today): next new and full moon,
/// an eclipse within 60 days, Mercury turning retrograde within 30, a birthday within 30.
List<(String, int?)> countdowns(BuildContext context, DateTime now) {
  final l = context.l;
  final a = context.content.astro;
  final today = DateTime(now.year, now.month, now.day);
  int days(DateTime t) =>
      DateTime(t.year, t.month, t.day).difference(today).inDays;
  final u = today.toUtc();
  final out = <(String, int?)>[];
  final ph = phaseEvents(u, 4);
  for (final p in [4, 0]) {
    final e = ph.firstWhere((e) => e.phase == p);
    out.add((a.phases[p].name, days(e.utc.toLocal())));
  }
  for (final e in eclipses(u, u.add(const Duration(days: 60))).take(1)) {
    out.add((l.evEclipse(_eclipseKind(e.kind)), days(e.utc.toLocal())));
  }
  for (final (s, e) in mercuryRetrogrades(u, u.add(const Duration(days: 30)))) {
    out.add(
      s.isAfter(u)
          ? (l.mercuryRetro, days(s.toLocal()))
          : (l.mercuryNow(_ddmm(e.toLocal())), null), // already retrograde
    );
  }
  if (context.store.birthDate case final b?) {
    var next = DateTime(now.year, b.month, b.day);
    if (next.isBefore(today)) next = DateTime(now.year + 1, b.month, b.day);
    final n = days(next);
    if (n <= 30) out.add((l.yourBirthday, n));
  }
  return out..sort((p, q) => (p.$2 ?? -1).compareTo(q.$2 ?? -1));
}

/// One area of the day: label, five dots and the sentence that goes with the level.
class Meter extends StatelessWidget {
  final String label;
  final String? text; // null: the dots alone
  final int value;
  const Meter(this.label, this.value, this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(bottom: text == null ? 10 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            label: context.l.meterValue(label, value),
            excludeSemantics: true,
            child: Row(
              children: [
                Expanded(child: Text(label, style: t.titleMedium)),
                for (var i = 1; i <= 5; i++)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      i <= value ? Icons.circle : Icons.circle_outlined,
                      size: 14,
                      color: i <= value ? cs.secondary : cs.outline,
                    ),
                  ),
              ],
            ),
          ),
          if (text case final text?) ...[const SizedBox(height: 6), Text(text)],
        ],
      ),
    );
  }
}

typedef DailyReading = ({
  DayMeters meters,
  String mood,
  String events,
  String love,
  String work,
  String energy,
  String advice,
});

/// Kind words for everyone on [date], whatever the day's reading says.
String dayMessage(BuildContext context, DateTime date) {
  final m = context.content.messages;
  return m[messageIndex(dayIndex(CalendarDate.fromDateTime(date)), m.length)];
}

/// The day's greeting as the page's highlight: dark card, gold frame ([dayGreeting]).
class DayMessage extends StatelessWidget {
  final DateTime now;

  /// Today adds the three areas as dots; Stars has them in the horoscope card below.
  final bool dots;
  const DayMessage(this.now, {super.key, this.dots = false});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final greeting = dayGreeting(context, now);
    const goldLight = Color(0xFFF1D98A);
    final l = context.l;
    final birth = context.store.birthDate;
    final m = birth == null || !dots ? null : metersFor(birth, now);
    // One area as a column: its name over five small dots.
    Widget area(String label, int value) => Expanded(
      child: Semantics(
        label: l.meterValue(label, value),
        excludeSemantics: true,
        child: Column(
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: t.bodyMedium?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 1; i <= 5; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.5),
                    child: Icon(
                      i <= value ? Icons.circle : Icons.circle_outlined,
                      size: 10,
                      color: i <= value ? goldLight : const Color(0x80FFFFFF),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
    return Container(
      margin: const EdgeInsets.symmetric(vertical: gap / 2),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5A4D8A), Color(0xFF2E2652)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFC9A44C), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x332B2140),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text('✦', style: TextStyle(fontSize: 18, color: goldLight)),
          const SizedBox(height: 8),
          Text(
            greeting.lead,
            textAlign: TextAlign.center,
            style: t.headlineSmall?.copyWith(color: Colors.white, height: 1.25),
          ),
          const SizedBox(height: 16),
          Container(height: 1, width: 56, color: const Color(0x66F1D98A)),
          const SizedBox(height: 14),
          Text(
            greeting.support,
            textAlign: TextAlign.center,
            style: t.titleMedium?.copyWith(
              color: goldLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (m != null) ...[
            const SizedBox(height: 18),
            Row(
              children: [
                area(l.loveLabel, m.love),
                area(l.workLabel, m.work),
                area(l.energyLabel, m.energy),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// What greets the person on [date]. Good news from the reading (an area at 4–5, or one
/// better than yesterday) leads, with the kind message under it. On other days, and
/// without a birth date, the message leads and what the Moon favours stands under it.
({String lead, String support}) dayGreeting(
  BuildContext context,
  DateTime date,
) {
  final l = context.l;
  final birth = context.store.birthDate;
  final message = dayMessage(context, date);
  final day = dayIndex(CalendarDate.fromDateTime(date));
  final moon = moonCheer(l, moonPhase(noonOf(date)), day);
  if (birth == null) return (lead: message, support: moon);
  final m = metersFor(birth, date);
  final before = metersFor(birth, date.subtract(const Duration(days: 1)));
  return hasGoodNews(m, before)
      ? (lead: dayCheer(l, birth, date), support: message)
      : (lead: message, support: moon);
}

/// The reading itself has something good to say: an area at 4–5 or one that improved.
bool hasGoodNews(DayMeters m, DayMeters before) =>
    max(m.love, max(m.work, m.energy)) >= 4 ||
    m.love > before.love ||
    m.work > before.work ||
    m.energy > before.energy;

/// Love, work and energy for [birth] on [date]; language-independent.
DayMeters metersFor(CalendarDate birth, DateTime date) {
  final noon = noonOf(date);
  return dayMeters(
    sun: sunSign(birth),
    moon: moonSign(noon),
    phase: moonPhase(noon),
    dayNumber: personalDay(birth, CalendarDate.fromDateTime(date)).value!,
  );
}

/// A warm headline for [birth] on [date] that never claims more than the meters say.
String dayCheer(AppLocalizations l, CalendarDate birth, DateTime date) =>
    cheerFor(
      l,
      metersFor(birth, date),
      metersFor(birth, date.subtract(const Duration(days: 1))),
      moonPhase(noonOf(date)),
      dayIndex(CalendarDate.fromDateTime(date)),
    );

/// Good days name their strongest area (4–5). Other days still get something true and
/// kind: an area that improved since yesterday, otherwise what the Moon phase favours.
String cheerFor(
  AppLocalizations l,
  DayMeters m,
  DayMeters before,
  int phase,
  int day,
) {
  final best = [m.love, m.work, m.energy].reduce(max);
  if (m.love >= 4 && m.work >= 4 && m.energy >= 4) return l.cheerAll;
  // Ties: love first, then work, then energy.
  String pick(int love, int work, int energy, List<String> t) {
    final top = [love, work, energy].reduce(max);
    return t[[love, work, energy].indexOf(top)];
  }

  if (best >= 4) {
    return pick(m.love, m.work, m.energy, [
      l.cheerLove,
      l.cheerWork,
      l.cheerEnergy,
    ]);
  }
  final up = (
    love: m.love - before.love,
    work: m.work - before.work,
    energy: m.energy - before.energy,
  );
  if (max(up.love, max(up.work, up.energy)) > 0) {
    return pick(up.love, up.work, up.energy, [
      l.cheerUpLove,
      l.cheerUpWork,
      l.cheerUpEnergy,
    ]);
  }
  return moonCheer(l, phase, day);
}

/// What the Moon phase favours; true for everyone on the day. A phase lasts for days,
/// so three wordings take turns by [day].
String moonCheer(AppLocalizations l, int phase, int day) => (switch (phase) {
  0 => [l.cheerNewMoon, l.cheerNewMoon2, l.cheerNewMoon3],
  <= 3 => [l.cheerWaxing, l.cheerWaxing2, l.cheerWaxing3],
  4 => [l.cheerFullMoon, l.cheerFullMoon2, l.cheerFullMoon3],
  _ => [l.cheerWaning, l.cheerWaning2, l.cheerWaning3],
})[day % 3];

/// The personal reading for [birth] on [date]: how the day may feel (Moon sign against the
/// person's element), what it may bring and the advice (personal day number), and three
/// areas whose text follows their meter. Null in a language without these texts.
DailyReading? dailyReading(
  BuildContext context,
  CalendarDate birth,
  DateTime date,
) {
  final Daily? d = context.content.daily;
  if (d == null) return null;
  final day = CalendarDate.fromDateTime(date);
  final noon = noonOf(date);
  final sun = sunSign(birth), moon = moonSign(noon);
  final number = personalDay(birth, day).value!;
  final m = metersFor(birth, date);
  final n = dayIndex(day);
  final relation = elementRelation(elementOf(sun), elementOf(moon));
  // The Moon stays in a sign for two or three days: alternate so neighbours differ.
  final moods = d.mood[signIds[moon]]![relation]!;
  String area(Map<String, List<String>> texts, int meter, int shift) {
    final v = texts[meterLevel(meter)]!;
    return v[(n + shift) % v.length];
  }

  return (
    meters: m,
    mood: moods[n % moods.length],
    events: d.events[number]![nineDayVariant(day, 3)],
    love: area(d.love, m.love, 0),
    work: area(d.work, m.work, 1),
    energy: area(d.energy, m.energy, 2),
    // Offset from the events so the pair differs on each return of the number.
    advice: d.advice[number]![(nineDayVariant(day, 3) + 1) % 3],
  );
}

/// Day horoscope texts (today's line, caution or advice) for [birth] on [date] — shared by
/// the horoscope card and the home-screen widget so both always say the same thing.
(String, String) dayHoroscope(
  BuildContext context,
  CalendarDate birth,
  DateTime date,
) {
  if (dailyReading(context, birth, date) case final r?) {
    return (r.mood, r.advice);
  }
  final a = context.content.astro;
  final day = CalendarDate.fromDateTime(date);
  final sign = sunSign(birth);
  final variants =
      a.today[elementRelation(
        elementOf(sign),
        elementOf(moonSign(noonOf(date))),
      )]!;
  return (
    variants[(day.day + day.month * 31 + sign) % variants.length],
    a.caution[personalDay(birth, day).value!]!,
  );
}

/// Texts for the three home-screen widgets (horoscope, card of the day, Moon): a week of
/// days — each widget picks its date — plus today's card once turned. Stays on the device.
Map<String, String> widgetPayload(BuildContext context, DateTime now) {
  final l = context.l;
  final a = context.content.astro;
  final s = context.store;
  final birth = s.birthDate;
  final today = CalendarDate.fromDateTime(now);
  // Free: the card shows once turned in the app. Pro: at once, today and on the coming days.
  final drawn = s.isPro || s.cardRevealed(today) ? s.cardOfDay(today) : null;
  String cardName(DrawnCard c) =>
      '${context.content.cards[c.cardId]!.name}${c.reversed ? ' (${l.reversed})' : ''}';
  String cardAdvice(DrawnCard c) {
    final face = context.content.cards[c.cardId]!;
    return l.widgetCardSays(c.reversed ? face.adviceReversed : face.advice);
  }
  final dates = DateFormat.MMMMEEEEd(
    Localizations.localeOf(context).toLanguageTag(),
  );
  return {
    'days': jsonEncode([
      for (var i = 0; i < 8; i++)
        () {
          final d = DateTime(now.year, now.month, now.day + i);
          final noon = noonOf(d);
          final day = birth == null
              ? null
              : personalDay(birth, CalendarDate.fromDateTime(d)).value!;
          final horoscope = birth == null
              ? null
              : dayHoroscope(context, birth, d);
          // 0 = no meters (no birth date).
          final meters = birth == null ? null : metersFor(birth, d);
          final soon = countdowns(context, d);
          final next = soon.where((c) => c.$2 != null);
          final running = soon.where((c) => c.$2 == null);
          final dayCard = i == 0
              ? drawn
              : (s.isPro ? s.cardAhead(CalendarDate.fromDateTime(d)) : null);
          return {
            'cardId': dayCard?.cardId ?? '',
            'cardName': dayCard == null ? '' : cardName(dayCard),
            'cardAdvice': dayCard == null ? '' : cardAdvice(dayCard),
            'cardReversed': dayCard?.reversed == true,
            'date': CalendarDate.fromDateTime(d).iso,
            'label': dates.format(d),
            'sign': birth == null ? '' : a.signs[sunSign(birth)].name,
            'text': horoscope?.$1 ?? '',
            'caution': horoscope?.$2 ?? '',
            'cheer': birth == null ? '' : dayCheer(l, birth, d),
            'moonCheer': moonCheer(
              l,
              moonPhase(noon),
              dayIndex(CalendarDate.fromDateTime(d)),
            ),
            'message': dayMessage(context, d),
            'lead': dayGreeting(context, d).lead,
            'support': dayGreeting(context, d).support,
            'love': meters?.love ?? 0,
            'work': meters?.work ?? 0,
            'energy': meters?.energy ?? 0,
            'number': day == null
                ? ''
                : '$day · ${context.content.interpretation(Indicator.personalDay, day)?.title ?? ''}',
            'color': day == null
                ? ''
                : l.dayColor(context.content.numerologyExtra.dayColors[day]!),
            'phase': moonPhase(noon),
            'phaseName': a.phases[moonPhase(noon)].name,
            'moonIn': l.notifMoon(a.signs[moonSign(noon)].locative),
            'next': next.isEmpty
                ? ''
                : l.countdown(next.first.$1, next.first.$2!),
            'mercury': running.isEmpty ? '' : running.first.$1,
          };
        }(),
    ]),
    'cardDate': today.iso,
    'cardId': drawn?.cardId ?? '',
    'cardName': drawn == null ? '' : cardName(drawn),
    'cardAdvice': drawn == null ? '' : cardAdvice(drawn),
    'cardReversed': drawn?.reversed == true ? '1' : '0',
    'cardTitle': l.cardOfDay,
    'cardWaiting': l.widgetCardWaiting,
    'needBirth': l.widgetNeedBirth,
    'stale': l.widgetStale,
    'loveLabel': l.loveLabel,
    'workLabel': l.workLabel,
    'energyLabel': l.energyLabel,
  };
}

/// One line about tomorrow, shown once today's ritual is done: a new/full moon,
/// the Moon changing sign, or simply the next day number.
String tomorrowTeaser(BuildContext context, DateTime now) {
  final l = context.l;
  final a = context.content.astro;
  final today = DateTime(now.year, now.month, now.day);
  final next = DateTime(now.year, now.month, now.day + 1);
  for (final e in phaseEvents(today.toUtc(), 2)) {
    final d = e.utc.toLocal();
    if ((e.phase == 0 || e.phase == 4) &&
        DateTime(d.year, d.month, d.day) == next) {
      return l.tomorrowIs(a.phases[e.phase].name.midSentence);
    }
  }
  final m = moonSign(noonOf(next));
  if (m != moonSign(noonOf(now))) return l.tomorrowMoon(a.signs[m].locative);
  final birth = context.store.birthDate;
  return birth == null
      ? l.tomorrowCard
      : l.tomorrowNumber(
          personalDay(birth, CalendarDate.fromDateTime(next)).value!,
        );
}

/// Two context tiles for Today: moon rituals before a new/full moon, Mercury,
/// a missing birth time, the week on Mondays, then a daily rotation of the other features.
List<Tile> suggestions(BuildContext context, DateTime now) {
  final l = context.l;
  final s = context.store;
  void go(Widget w) => pushScreen(context, w);
  final rituals = (
    Icons.brightness_3_outlined,
    l.ritualsTitle,
    l.exploreRituals,
    () => go(const MoonRitualsScreen()),
  );
  final moon = (
    Icons.dark_mode_outlined,
    l.moonCalendar,
    l.exploreMoon,
    () => go(const MoonCalendarScreen()),
  );
  final bigThree = (
    Icons.brightness_4_outlined,
    l.bigThree,
    l.suggestBigThree,
    () => go(const BirthChartScreen()),
  );
  final week = (
    Icons.calendar_month_outlined,
    l.periodTitle,
    l.explorePeriod,
    () => go(const PeriodHoroscopeScreen()),
  );
  final rotation = <Tile>[
    (
      Icons.blur_on,
      l.ichingTitle,
      l.exploreIching,
      () => go(const IChingScreen()),
    ),
    (
      Icons.nights_stay_outlined,
      l.dreams,
      l.exploreDreams,
      () => homeTab.value = 4,
    ),
    (
      Icons.favorite_border,
      l.compatibility,
      l.compatibilityHint,
      () => go(const CompatibilityScreen()),
    ),
    (
      Icons.pets_outlined,
      l.chineseTitle,
      l.exploreChinese,
      () => go(const ChineseScreen()),
    ),
    (
      Icons.style_outlined,
      l.exploreTarot,
      l.exploreTarotSub,
      () => homeTab.value = 1,
    ),
    week,
  ];
  final u = DateTime(now.year, now.month, now.day).toUtc();
  final soon = u.add(const Duration(days: 4));
  final out = <Tile>[
    if (phaseEvents(
      u,
      4,
    ).any((e) => (e.phase == 0 || e.phase == 4) && e.utc.isBefore(soon)))
      rituals,
    if (mercuryRetrogrades(u, u.add(const Duration(days: 7))).isNotEmpty) moon,
    if (s.birthDate != null && s.birthMinutes == null) bigThree,
    if (now.weekday == DateTime.monday) week,
  ];
  final start = now.difference(DateTime(now.year)).inDays;
  for (var i = 0; out.length < 2 && i < rotation.length; i++) {
    final x = rotation[(start + i) % rotation.length];
    if (!out.any((o) => o.$2 == x.$2)) out.add(x);
  }
  return out.take(2).toList(); // one full row
}

/// Stars tab: the full horoscope and everything astrological.
class StarsScreen extends StatelessWidget {
  const StarsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final now = DateTime.now();
    final birth = context.store.birthDate;
    void go(Widget w) => pushScreen(context, w);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.tabStars),
        leadingWidth: topLeadingWidth,
        leading: topLeading(context),
      ),
      body: ListView(
        padding: pagePadding(context),
        children: [
          DayMessage(now),
          const SizedBox(height: 12),
          if (birth != null) HoroscopeCard(birth, now) else const BirthPrompt(),
          SectionTitle(l.starsMore),
          TileGrid([
            (
              Icons.calendar_month_outlined,
              l.periodTitle,
              l.explorePeriod,
              () => go(const PeriodHoroscopeScreen()),
            ),
            (
              Icons.brightness_4_outlined,
              l.bigThree,
              l.exploreBigThree,
              () => go(const BirthChartScreen()),
            ),
            (
              Icons.pets_outlined,
              l.chineseTitle,
              l.exploreChinese,
              () => go(const ChineseScreen()),
            ),
            (
              Icons.favorite_border,
              l.compatibility,
              l.compatibilityHint,
              () => go(const CompatibilityScreen()),
            ),
            (
              Icons.dark_mode_outlined,
              l.moonCalendar,
              l.exploreMoon,
              () => go(const MoonCalendarScreen()),
            ),
            (
              Icons.brightness_3_outlined,
              l.ritualsTitle,
              l.exploreRituals,
              () => go(const MoonRitualsScreen()),
            ),
            (
              Icons.blur_on,
              l.ichingTitle,
              l.exploreIching,
              () => go(const IChingScreen()),
            ),
          ]),
          MoonCard(now),
        ],
      ),
    );
  }
}

class MoonRitualsScreen extends StatelessWidget {
  const MoonRitualsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final a = context.content.astro;
    final t = Theme.of(context).textTheme;
    final s = context.store;
    final loc = MaterialLocalizations.of(context);
    final events = phaseEvents(DateTime.now().toUtc(), 4);
    DateTime next(int phase) =>
        events.firstWhere((e) => e.phase == phase).utc.toLocal();
    Widget ritual(String key, DateTime when) {
      final r = a.rituals[key]!;
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(r.title, style: t.headlineSmall),
              Text(
                loc.formatFullDate(when),
                style: t.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(r.text),
              LabeledBlock(
                l.reflectionQuestions,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [for (final p in r.prompts) Text('• $p')],
                ),
              ),
              SaveReflectionButton(
                prompt: r.prompts.join('\n'),
                ref: {
                  'type': 'ritual',
                  'label': '${r.title} · ${loc.formatMediumDate(when)}',
                },
              ),
            ],
          ),
        ),
      );
    }

    final newFirst = next(0).isBefore(next(4));
    return Scaffold(
      appBar: AppBar(title: Text(l.ritualsTitle)),
      body: ListView(
        padding: screenPadding(context),
        children: [
          Text(l.ritualsIntro, style: t.bodySmall),
          const SizedBox(height: 8),
          if (newFirst) ...[
            ritual('new', next(0)),
            ritual('full', next(4)),
          ] else ...[
            ritual('full', next(4)),
            ritual('new', next(0)),
          ],
          if (Reminders.supported)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.moonRemindersToggle),
              subtitle: Text(l.moonRemindersNote),
              value: s.moonReminders,
              onChanged: (on) async {
                if (!on) {
                  s.moonReminders = false;
                  await Reminders.disableMoon();
                  return;
                }
                final ok = await Reminders.enableMoon(moonReminderEvents(l));
                if (ok) {
                  s.moonReminders = true;
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(l.reminderDenied)));
                }
              },
            ),
        ],
      ),
    );
  }
}

String _eclipseKind(EclipseKind k) => switch (k) {
  EclipseKind.solar => 'solar',
  EclipseKind.lunarPartialOrTotal => 'partial',
  EclipseKind.lunarPenumbral => 'penumbral',
};

/// Sky events between [from] and [to] (local times), sorted.
List<(DateTime, String)> keyEvents(
  BuildContext context,
  DateTime from,
  DateTime to,
  int sun,
) {
  final l = context.l;
  final a = context.content.astro;
  final f = from.toUtc(), t = to.toUtc();
  final ev = <(DateTime, String)>[
    for (final e in phaseEvents(f, 12))
      if (e.utc.isBefore(t)) (e.utc.toLocal(), a.phases[e.phase].name),
    for (final e in eclipses(f, t))
      (e.utc.toLocal(), l.evEclipse(_eclipseKind(e.kind))),
    for (final (s, e) in mercuryRetrogrades(f, t)) ...[
      if (s.isAfter(f)) (s.toLocal(), l.evMercuryStart),
      if (e.isBefore(t)) (e.toLocal(), l.evMercuryEnd),
    ],
  ];
  var x = f;
  while (true) {
    final (at, sign) = nextSunIngress(x);
    if (at.isAfter(t)) break;
    ev.add((at.toLocal(), l.evSunIngress(a.signs[sign].name)));
    x = at.add(const Duration(hours: 1));
  }
  int? prev;
  for (
    var d = DateTime(from.year, from.month, from.day);
    !d.isAfter(to);
    d = DateTime(d.year, d.month, d.day + 1)
  ) {
    final m = moonSign(noonOf(d));
    if (m == sun && prev != sun) {
      ev.add((noonOf(d), l.evMoonInSign(a.signs[sun].name))); // first day only
    }
    prev = m;
  }
  return ev..sort((p, q) => p.$1.compareTo(q.$1));
}

class PeriodHoroscopeScreen extends StatelessWidget {
  const PeriodHoroscopeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final a = context.content.astro;
    final t = Theme.of(context).textTheme;
    final loc = MaterialLocalizations.of(context);
    final birth = context.store.birthDate;
    final now = DateTime.now();
    Widget events(List<(DateTime, String)> ev) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (ev.isEmpty) Text(l.noKeyDays),
        for (final (at, what) in ev)
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: Icon(
              Icons.circle,
              size: 10,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            title: Text(
              what,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(loc.formatMediumDate(at)),
          ),
      ],
    );
    if (birth == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.periodTitle)),
        body: Padding(
          padding: screenPadding(context),
          child: Text(l.needBirthDate),
        ),
      );
    }
    final sun = sunSign(birth);
    final weekEnd = DateTime(now.year, now.month, now.day + 7);
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59);
    final rel = elementRelation(
      elementOf(sun),
      elementOf(sunLongitude(now) ~/ 30),
    );
    final dayTitles = context.content.numerology[Indicator.personalDay]!;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.periodTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: l.tabWeek),
              Tab(text: l.tabMonth),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: screenPadding(context),
              children: [
                Text(l.periodIntro, style: t.bodySmall),
                LabeledBlock(l.weekGeneral, Text(a.week[rel]!)),
                LabeledBlock(
                  l.keyDays,
                  events(keyEvents(context, now, weekEnd, sun)),
                ),
                for (var i = 0; i < 7; i++)
                  Builder(
                    builder: (context) {
                      final d = DateTime(now.year, now.month, now.day + i);
                      final n = personalDay(
                        birth,
                        CalendarDate.fromDateTime(d),
                      ).value!;
                      return Card(
                        child: ListTile(
                          leading: NumberBadge('$n', size: 42),
                          title: Text(loc.formatFullDate(d)),
                          subtitle: Text(
                            '${l.dayNumberLine(n, dayTitles[n]!.title)}\n'
                            '${l.moonDayLine(a.signs[moonSign(noonOf(d))].locative, a.phases[moonPhase(noonOf(d))].name.midSentence)}',
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
              ],
            ),
            ListView(
              padding: screenPadding(context),
              children: [
                Text(l.periodIntro, style: t.bodySmall),
                const SizedBox(height: 8),
                ResultCard(personalMonth(birth, now.year, now.month)),
                LabeledBlock(
                  l.keyDays,
                  events(keyEvents(context, monthStart, monthEnd, sun)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
