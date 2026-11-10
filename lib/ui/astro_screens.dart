import 'package:flutter/material.dart';

import '../data/places.dart';
import '../l10n/app_localizations.dart';
import '../reminders.dart';
import '../engine/astro.dart';
import '../engine/numerology.dart';
import 'numerology_screen.dart';
import 'widgets.dart';

/// Moon position used for "today": local noon, so the text is stable all day.
DateTime noonOf(DateTime now) => DateTime(now.year, now.month, now.day, 12);

/// "Dziś dla Ciebie": sun sign × today's Moon × personal day number.
class HoroscopeCard extends StatelessWidget {
  final CalendarDate birth;
  final DateTime now;
  const HoroscopeCard(this.birth, this.now, {super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final a = context.content.astro;
    final t = Theme.of(context).textTheme;
    final today = CalendarDate.fromDateTime(now);
    final noon = noonOf(now);
    final sign = sunSign(birth), moon = moonSign(noon);
    final relation = elementRelation(elementOf(sign), elementOf(moon));
    final variants = a.today[relation]!;
    final day = personalDay(birth, today).value!;
    final chinese = a.chinese[chineseSign(birth)];
    final phase = a.phases[moonPhase(noon)];

    final cs = Theme.of(context).colorScheme;
    Widget block(String label, String text) => LabeledBlock(label, Text(text));
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
          block(
            l.horoscopeToday,
            variants[(today.day + today.month * 31 + sign) % variants.length],
          ),
          block(
            l.horoscopeStars,
            '${l.moonIn(a.signs[moon].locative, phase.name.toLowerCase())} ${phase.text}',
          ),
          block(l.horoscopeCaution, a.caution[day]!),
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
          const SizedBox(height: 16),
          Row(
            children: [
              NumberBadge('$day', size: 64),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.indicatorName('personalDay'), style: t.titleMedium),
                    Text(
                      context.content
                              .interpretation(Indicator.personalDay, day)
                              ?.title ??
                          '',
                      style: t.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          LabeledBlock(
            l.luckyNumbers,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Wrap(
                  spacing: 10,
                  children: [
                    for (final n in luckyNumbers(birth, today))
                      InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          final r = reduceSteps(n, const {}).last;
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                content: Text(
                                  l.luckyMeaning(
                                    n,
                                    r,
                                    context
                                        .content
                                        .numerologyExtra
                                        .keywords[r]!,
                                  ),
                                ),
                              ),
                            );
                        },
                        child: NumberBadge('$n', size: 48),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  l.dayColor(context.content.numerologyExtra.dayColors[day]!),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text('${l.luckyTap} ${l.luckyNote}', style: t.bodySmall),
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
        padding: const EdgeInsets.all(16),
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
                    '${l.moonDayLine(a.signs[sign].locative, a.phases[moonPhase(day)].name.toLowerCase())}\n'
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
          hintText: 'DD.MM.RRRR',
          errorText: err,
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
        padding: const EdgeInsets.all(16),
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

String _ddmm(DateTime t) =>
    '${t.day.toString().padLeft(2, '0')}.${t.month.toString().padLeft(2, '0')}';
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
            placeLabel(place!),
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
                DropdownMenuEntry(value: placeLabel(c), label: placeLabel(c)),
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
        padding: const EdgeInsets.all(16),
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
          padding: const EdgeInsets.all(16),
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
        padding: const EdgeInsets.all(16),
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
        padding: const EdgeInsets.all(16),
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
          padding: const EdgeInsets.all(16),
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
              padding: const EdgeInsets.all(16),
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
                            '${l.moonDayLine(a.signs[moonSign(noonOf(d))].locative, a.phases[moonPhase(noonOf(d))].name.toLowerCase())}',
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
              ],
            ),
            ListView(
              padding: const EdgeInsets.all(16),
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
