import 'package:flutter/material.dart';

import '../data/places.dart';
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
                      NumberBadge('$n', size: 48),
                  ],
                ),
                const SizedBox(height: 6),
                Text(l.luckyNote, style: t.bodySmall),
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
          _BigThree(l.sunLabel, a.signs[sun].name, a.signs[sun].text),
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
