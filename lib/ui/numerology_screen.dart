import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/content.dart';
import '../engine/numerology.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final s = context.store;
    if (_date.text.isEmpty && s.birthDate != null) {
      _date.text = s.birthDate!.display;
    }
    if (_name.text.isEmpty && s.fullName != null) _name.text = s.fullName!;
  }

  void _compute() {
    final l = context.l;
    final today = CalendarDate.fromDateTime(DateTime.now());
    final dateText = _date.text.trim(), name = _name.text.trim();
    final d = dateText.isEmpty ? null : parseUserDate(dateText);
    final n = name.isEmpty ? null : normalizeName(name);
    setState(() {
      _results = null;
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
      _results = [
        if (d != null) ...[lifePath(d), birthDay(d), personalYear(d, _year)],
        if (n != null) ...[expression(n), soulUrge(n), personality(n)],
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return Scaffold(
      appBar: AppBar(title: Text(l.tabNumerology)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.numerologyIntro),
          const SizedBox(height: 16),
          TextField(
            controller: _date,
            keyboardType: TextInputType.number,
            inputFormatters: [DateMaskFormatter()],
            decoration: InputDecoration(
              labelText: l.birthDate,
              hintText: 'DD.MM.RRRR',
              helperText: l.birthDateHelp,
              errorText: _dateError,
              border: const OutlineInputBorder(),
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
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(l.personalYearFor),
              IconButton(
                tooltip: l.previousYear,
                onPressed: () => setState(() => _year--),
                icon: const Icon(Icons.remove),
              ),
              Text('$_year', style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                tooltip: l.nextYear,
                onPressed: () => setState(() => _year++),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            children: [
              FilledButton(onPressed: _compute, child: Text(l.calculate)),
              OutlinedButton(
                onPressed: () {
                  context.store.saveProfile(
                    parseUserDate(_date.text),
                    _name.text.trim(),
                  );
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(l.profileSaved)));
                },
                child: Text(l.saveAsProfile),
              ),
            ],
          ),
          if (_results != null) ...[
            SectionTitle(l.portrait),
            Text(l.portraitNote, style: Theme.of(context).textTheme.bodySmall),
            for (final r in _results!) ResultCard(r),
          ],
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
        title: Text(title),
        subtitle: Text(
          r.value == null
              ? l.noBasis
              : '${r.value}${i != null ? ' · ${i.title}' : ''}',
        ),
        leading: CircleAvatar(child: Text(r.value?.toString() ?? '–')),
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
