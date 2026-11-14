import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/content.dart';
import '../engine/numerology.dart';
import '../engine/tarot.dart';
import 'astro_screens.dart';
import 'tarot_screen.dart';
import 'journal_screen.dart';
import 'widgets.dart';

/// Accepts "15.07.1990", "15-07-1990", "15071990" — digits only keyboard friendly.
CalendarDate? parseUserDate(String s) {
  final d = s.replaceAll(RegExp(r'\D'), '');
  if (d.length != 8) return null;
  return CalendarDate.tryCreate(
    int.parse(d.substring(4)),
    int.parse(d.substring(2, 4)),
    int.parse(d.substring(0, 2)),
  );
}

/// Inserts dots as the user types digits: 15071990 → 15.07.1990.
class DateMaskFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue o, TextEditingValue n) {
    final d = n.text.replaceAll(RegExp(r'\D'), '');
    final b = StringBuffer();
    for (var i = 0; i < d.length && i < 8; i++) {
      if (i == 2 || i == 4) b.write('.');
      b.write(d[i]);
    }
    final t = b.toString();
    return TextEditingValue(
      text: t,
      selection: TextSelection.collapsed(offset: t.length),
    );
  }
}

class NumerologyScreen extends StatefulWidget {
  const NumerologyScreen({super.key});
  @override
  State<NumerologyScreen> createState() => _NumerologyScreenState();
}

class _NumerologyScreenState extends State<NumerologyScreen> {
  final _date = TextEditingController();
  final _name = TextEditingController();
  String? _dateError, _nameError;
  int _year = DateTime.now().year;
  List<NumerologyResult>? _results;
  CalendarDate? _birth; // for the birth card, set with results

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final s = context.store;
    if (_date.text.isEmpty && s.birthDate != null) {
      _date.text = s.birthDate!.display;
    }
    if (_name.text.isEmpty && s.fullName != null) _name.text = s.fullName!;
  }

  /// Validates input, shows errors or results; returns true when input is valid.
  bool _compute() {
    final l = context.l;
    final today = CalendarDate.fromDateTime(DateTime.now());
    final dateText = _date.text.trim(), name = _name.text.trim();
    final d = dateText.isEmpty ? null : parseUserDate(dateText);
    final n = name.isEmpty ? null : normalizeName(name);
    setState(() {
      _results = null;
      _birth = null;
      _dateError = dateText.isEmpty
          ? (name.isEmpty ? l.enterDateOrName : null)
          : d == null
          ? l.dateInvalid
          : d.compareTo(today) > 0
          ? l.dateFuture
          : null;
      _nameError = n == null || n.isValid
          ? null
          : n.unsupported.isEmpty
          ? l.nameNoLetters
          : l.nameUnsupported(n.unsupported.join(' '));
      if (_dateError != null || _nameError != null) return;
      _birth = d;
      _results = [
        if (d != null) ...[
          lifePath(d),
          birthDay(d),
          personalYear(d, _year),
          personalMonth(d, _year, DateTime.now().month),
        ],
        if (n != null) ...[expression(n), soulUrge(n), personality(n)],
        if (d != null && n != null) maturity(d, n),
      ];
    });
    return _results != null;
  }

  bool _editing = false; // form shown over a saved profile

  void _saveProfile() {
    final l = context.l;
    // Never overwrite the saved profile with an invalid or future date.
    if (!_compute()) return;
    context.store.saveProfile(parseUserDate(_date.text), _name.text.trim());
    setState(() => _editing = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l.profileSaved)));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final t = Theme.of(context).textTheme;
    final s = context.store;
    final birth = s.birthDate;
    final showForm = birth == null || _editing;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.tabNumerology),
        leadingWidth: topLeadingWidth,
        leading: topLeading(context),
      ),
      body: ListView(
        padding: pagePadding(context),
        children: [
          if (!showForm) ...[
            ProfileNumbers(
              birth,
              name: s.fullName,
              onEdit: () => setState(() => _editing = true),
            ),
            SectionTitle(l.portrait),
            Text(l.portraitNote, style: t.bodySmall),
            for (final r in profileResults(birth, s.fullName)) ResultCard(r),
            BirthCardSection(birthCard(birth)),
            PythagorasSection(birth),
            LifeCyclesSection(birth),
            KarmicSection(
              birth,
              s.fullName == null || s.fullName!.isEmpty
                  ? null
                  : normalizeName(s.fullName!),
            ),
          ] else ...[
            TarotFrame(
              child: Column(
                children: [
                  Text(
                    birth == null ? l.numbersStartTitle : l.numbersEditTitle,
                    textAlign: TextAlign.center,
                    style: t.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(l.numerologyIntro, textAlign: TextAlign.center),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _date,
              keyboardType: TextInputType.number,
              inputFormatters: [DateMaskFormatter()],
              decoration: InputDecoration(
                labelText: l.birthDate,
                hintText: context.l.dateHint,
                helperText: l.birthDateHelp,
                errorText: _dateError,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: l.fullNameOptional,
                helperText: l.fullNameHelp,
                helperMaxLines: 3,
                errorText: _nameError,
                errorMaxLines: 3,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text(l.personalYearFor)),
                IconButton(
                  tooltip: l.previousYear,
                  onPressed: () => setState(() => _year--),
                  icon: const Icon(Icons.remove),
                ),
                Text('$_year', style: t.titleMedium),
                IconButton(
                  tooltip: l.nextYear,
                  onPressed: () => setState(() => _year++),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Full-width, stacked: no wrapping or glued buttons on narrow phones.
            FilledButton.icon(
              icon: const Icon(Icons.bookmark_add_outlined),
              onPressed: _saveProfile,
              label: Text(l.saveAsProfile),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => _compute(),
              child: Text(l.calculateOnce),
            ),
            if (_editing)
              TextButton(
                onPressed: () => setState(() {
                  _editing = false;
                  _results = null;
                }),
                child: Text(
                  MaterialLocalizations.of(context).cancelButtonLabel,
                ),
              ),
            if (_results != null) ...[
              SectionTitle(l.portrait),
              Text(l.portraitNote, style: t.bodySmall),
              for (final r in _results!) ResultCard(r),
              if (_birth case final b?) ...[
                BirthCardSection(birthCard(b)),
                PythagorasSection(b),
                LifeCyclesSection(b),
              ],
              KarmicSection(
                _birth,
                _name.text.trim().isEmpty
                    ? null
                    : normalizeName(_name.text.trim()),
              ),
            ],
          ],
          const HouseNumberCard(),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.favorite_border,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              title: Text(l.compatibility, style: t.titleMedium),
              subtitle: Text(l.compatibilityHint),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CompatibilityScreen()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Results for the saved profile (current personal year).
List<NumerologyResult> profileResults(CalendarDate birth, String? name) {
  final n = name == null || name.isEmpty ? null : normalizeName(name);
  final now = DateTime.now();
  return [
    lifePath(birth),
    birthDay(birth),
    personalDay(birth, CalendarDate.fromDateTime(now)),
    personalYear(birth, now.year),
    personalMonth(birth, now.year, now.month),
    if (n != null && n.isValid) ...[
      expression(n),
      soulUrge(n),
      personality(n),
      maturity(birth, n),
    ],
  ];
}

/// Header for a saved profile: the three key numbers, large. In Numbers it offers editing;
/// on Today it links to the full numerology instead.
class ProfileNumbers extends StatelessWidget {
  final CalendarDate birth;
  final String? name;
  final VoidCallback? onEdit, onOpen;
  const ProfileNumbers(
    this.birth, {
    super.key,
    this.name,
    this.onEdit,
    this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    Widget n(int? v, String label) => Expanded(
      child: Column(
        children: [
          NumberBadge('${v ?? '–'}', size: 64),
          const SizedBox(height: 6),
          Text(label, textAlign: TextAlign.center, style: t.bodySmall),
        ],
      ),
    );
    return TarotFrame(
      child: Column(
        children: [
          Text(
            l.yourNumbers.toUpperCase(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: cs.secondary,
            ),
          ),
          if (name != null && name!.isNotEmpty)
            Text(name!, textAlign: TextAlign.center, style: t.headlineSmall),
          Text(birth.display, style: t.bodyMedium),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              n(lifePath(birth).value, l.indicatorName('lifePath')),
              n(birthDay(birth).value, l.indicatorName('birthDay')),
              n(
                personalYear(birth, DateTime.now().year).value,
                l.indicatorName('personalYear'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (onEdit != null)
            TextButton.icon(
              icon: const Icon(Icons.edit_outlined),
              onPressed: onEdit,
              label: Text(l.editOrOther),
            ),
          if (onOpen != null)
            FilledButton.tonal(
              onPressed: onOpen,
              child: Text(l.fullNumerology),
            ),
        ],
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  final NumerologyResult r;
  const ResultCard(this.r, {super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final Interpretation? i = context.content.interpretation(
      r.indicator,
      r.value,
    );
    final title = l.indicatorName(r.indicator.name);
    return Card(
      child: ExpansionTile(
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(
          r.value == null
              ? l.noBasis
              : '${r.value}${i != null ? ' · ${i.title}' : ''}',
        ),
        leading: NumberBadge(r.value?.toString() ?? '–'),
        minTileHeight: 76,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabeledBlock(
            l.calculation,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.method, style: Theme.of(context).textTheme.bodySmall),
                for (final e in r.inputs.entries) Text('${e.key}: ${e.value}'),
                for (final s in r.steps) Text(s),
              ],
            ),
          ),
          if (i != null) ...[
            LabeledBlock(l.symbolicInterpretation, Text(i.text)),
            LabeledBlock(l.reflectionQuestion, Text(i.reflection)),
            SaveReflectionButton(
              prompt: i.reflection,
              ref: {
                'type': 'numerology',
                'label': '$title: ${r.value}',
                'result': r.toJson(),
              },
            ),
          ],
        ],
      ),
    );
  }
}

class BirthCardSection extends StatelessWidget {
  final BirthCard b;
  const BirthCardSection(this.b, {super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(l.birthCardTitle),
        Text(l.birthCardNote, style: Theme.of(context).textTheme.bodySmall),
        for (final s in b.steps) Text(s),
        DrawnCardTile(DrawnCard(b.id, l.birthCardTitle, false)),
        if (b.secondId case final id?)
          DrawnCardTile(DrawnCard(id, l.birthCardSecond, false)),
      ],
    );
  }
}

/// 3×3 psychomatrix grid; tap a cell to read what that digit's count means.
class PythagorasSection extends StatefulWidget {
  final CalendarDate birth;
  const PythagorasSection(this.birth, {super.key});
  @override
  State<PythagorasSection> createState() => _PythagorasSectionState();
}

class _PythagorasSectionState extends State<PythagorasSection> {
  int _picked = 1;
  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final sq = pythagorasSquare(widget.birth);
    final texts = context.content.numerologyExtra.square;
    Widget cell(int digit) {
      final n = sq.counts[digit]!;
      final sel = digit == _picked;
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Semantics(
            button: true,
            selected: sel,
            label:
                '${texts[digit]!.title}: ${n == 0 ? l.squareEmpty : '$digit × $n'}',
            excludeSemantics: true,
            child: Material(
              color: sel ? cs.primary.withValues(alpha: 0.10) : cs.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: sel ? cs.tertiary : cs.outlineVariant,
                  width: sel ? 2 : 1,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => setState(() => _picked = digit),
                child: SizedBox(
                  height: 76,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        child: Text(
                          n == 0 ? '—' : '$digit' * n,
                          style: t.headlineSmall?.copyWith(color: cs.primary),
                        ),
                      ),
                      Text(
                        texts[digit]!.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.labelSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    final n = sq.counts[_picked]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(l.squareTitle),
        Text(l.squareIntro, style: t.bodySmall),
        const SizedBox(height: 8),
        for (final row in const [
          [1, 4, 7],
          [2, 5, 8],
          [3, 6, 9],
        ])
          Row(children: [for (final d in row) cell(d)]),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${texts[_picked]!.title} · ${n == 0 ? l.squareEmpty : '$_picked' * n}',
                  style: t.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(texts[_picked]!.levels[n.clamp(0, 4)]),
              ],
            ),
          ),
        ),
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: Text(l.calculation),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [for (final s in sq.steps) Text(s)],
        ),
      ],
    );
  }
}

/// Four life periods with pinnacle and challenge; the current one is highlighted.
class LifeCyclesSection extends StatelessWidget {
  final CalendarDate birth;
  const LifeCyclesSection(this.birth, {super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final x = context.content.numerologyExtra;
    final now = DateTime.now();
    var age = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--; // birthday not reached yet this year
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(l.cyclesTitle),
        Text(l.cyclesIntro, style: t.bodySmall),
        const SizedBox(height: 8),
        for (final p in lifePeriods(birth))
          Builder(
            builder: (context) {
              final current =
                  age >= p.fromAge && (p.toAge == null || age <= p.toAge!);
              final pin = x.pinnacles[p.pinnacle]!,
                  ch = x.challenges[p.challenge]!;
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: current ? cs.tertiary : cs.outlineVariant,
                    width: current ? 2 : 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NumberBadge('${p.pinnacle}', size: 52),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.toAge == null
                                  ? l.ageFrom(p.fromAge)
                                  : l.ageRange(p.fromAge, p.toAge!),
                              style: t.labelLarge?.copyWith(
                                color: cs.secondary,
                              ),
                            ),
                            if (current)
                              Text(
                                l.cyclesNow,
                                style: t.labelLarge?.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            Text(pin.name, style: t.titleMedium),
                            Text(pin.text),
                            const SizedBox(height: 6),
                            Text(
                              '${ch.name} (${p.challenge})',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(ch.text),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

/// Karmic debts (13/14/16/19 on the way to core numbers) and lessons (digits missing from the name).
class KarmicSection extends StatelessWidget {
  final CalendarDate? birth;
  final NormalizedName? name;
  const KarmicSection(this.birth, this.name, {super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final x = context.content.numerologyExtra;
    final valid = name != null && name!.isValid ? name : null;
    if (birth == null && valid == null) return const SizedBox.shrink();
    final debts = karmicDebts(birth, valid).toList()..sort();
    final lessons = valid == null ? <int>[] : karmicLessons(valid);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(l.karmicTitle),
        Text(l.karmicIntro, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 6),
        if (debts.isEmpty) Text(l.karmicNone),
        for (final d in debts)
          Card(
            child: ListTile(
              leading: NumberBadge('$d', size: 46),
              title: Text(x.karmicDebts[d]!.name),
              subtitle: Text(x.karmicDebts[d]!.text),
            ),
          ),
        if (lessons.isNotEmpty)
          LabeledBlock(
            l.karmicLessonsTitle,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final n in lessons) Text('• ${x.karmicLessons[n]}'),
              ],
            ),
          ),
      ],
    );
  }
}

/// Numerology of a house, flat or phone number.
class HouseNumberCard extends StatefulWidget {
  const HouseNumberCard({super.key});
  @override
  State<HouseNumberCard> createState() => _HouseNumberCardState();
}

class _HouseNumberCardState extends State<HouseNumberCard> {
  NumerologyResult? _r;
  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(l.houseTitle),
        TextField(
          decoration: InputDecoration(
            labelText: l.houseHint,
            prefixIcon: const Icon(Icons.home_outlined),
          ),
          onChanged: (v) => setState(() => _r = houseNumber(v)),
        ),
        if (_r case final r?) ResultCard(r),
      ],
    );
  }
}
