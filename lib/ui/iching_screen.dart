import 'dart:math';

import 'package:flutter/material.dart';

import '../engine/iching.dart';
import 'widgets.dart';

// Trigram names in the engine's order (Qian, Zhen, Kan, Gen, Kun, Xun, Li, Dui): nominative / instrumental.
// shortcut: Polish in code like spread names (decisions.md #9); move to ARB with a second language.
const _trigramNom = [
  'Niebo',
  'Grzmot',
  'Woda',
  'Góra',
  'Ziemia',
  'Wiatr',
  'Ogień',
  'Jezioro',
];
const _trigramIns = [
  'Niebem',
  'Grzmotem',
  'Wodą',
  'Górą',
  'Ziemią',
  'Wiatrem',
  'Ogniem',
  'Jeziorem',
];

/// I Ching: a question, six throws of three coins (bottom line first), then the reading.
class IChingScreen extends StatefulWidget {
  const IChingScreen({super.key});
  @override
  State<IChingScreen> createState() => _IChingScreenState();
}

class _IChingScreenState extends State<IChingScreen> {
  final _random = Random.secure();
  final _question = TextEditingController();
  final _lines = <int>[];

  @override
  void dispose() {
    _question.dispose();
    super.dispose();
  }

  void _toss() {
    FocusScope.of(context).unfocus();
    setState(() => _lines.add(tossLine(_random)));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final t = Theme.of(context).textTheme;
    final done = _lines.length == 6;
    final reading = done ? readLines(_lines) : null;
    final hex = context.content.iching;
    final q = _question.text.trim();
    return Scaffold(
      appBar: AppBar(title: Text(l.ichingTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.ichingIntro, style: t.bodySmall),
          const SizedBox(height: 12),
          TextField(
            controller: _question,
            enabled: _lines.isEmpty,
            maxLength: 200,
            minLines: 1,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l.questionLabel,
              prefixIcon: const Icon(Icons.help_outline),
            ),
          ),
          TarotFrame(
            child: Column(
              children: [
                // Lines are drawn top (6th) to bottom (1st), as the hexagram is read.
                for (var i = 5; i >= 0; i--)
                  _HexLine(i < _lines.length ? _lines[i] : null),
                const SizedBox(height: 8),
                if (!done)
                  FilledButton.icon(
                    icon: const Icon(Icons.toll_outlined),
                    onPressed: _toss,
                    label: Text(l.ichingToss(_lines.length + 1)),
                  ),
                if (_lines.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      l.ichingLastToss('${_lines.last}'),
                      textAlign: TextAlign.center,
                      style: t.bodySmall,
                    ),
                  ),
              ],
            ),
          ),
          if (reading != null) ...[
            Text(
              '${reading.$1}. ${hex[reading.$1]!.name}',
              style: t.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            if (q.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '„$q”',
                  style: t.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
            Builder(
              builder: (context) {
                final (up, low) = trigramsOf([
                  for (final x in _lines) isYang(x),
                ]);
                return Text(
                  l.ichingImage(_trigramNom[up], _trigramIns[low]),
                  style: t.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                );
              },
            ),
            LabeledBlock(l.ichingMeaning, Text(hex[reading.$1]!.text)),
            LabeledBlock(l.advice, Text(hex[reading.$1]!.advice)),
            if (_lines.any(isChanging))
              LabeledBlock(
                l.ichingLinesTitle,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < 6; i++)
                      if (isChanging(_lines[i]))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            l.ichingLine(i + 1, hex[reading.$1]!.lines[i]),
                          ),
                        ),
                  ],
                ),
              ),
            if (reading.$2 case final next?)
              LabeledBlock(
                l.ichingChange,
                Text(
                  '${l.ichingChangingLines([for (var i = 0; i < 6; i++)
                    if (isChanging(_lines[i])) i + 1].join(', '))} '
                  '$next. ${hex[next]!.name}: ${hex[next]!.text}',
                ),
              ),
            SaveReflectionButton(
              prompt: l.spreadReflectionPrompt,
              ref: {
                'type': 'iching',
                'label':
                    '${q.isEmpty ? '' : '„$q” — '}I Ching: ${reading.$1}. ${hex[reading.$1]!.name}${reading.$2 == null ? '' : ' → ${reading.$2}. ${hex[reading.$2]!.name}'}',
                'lines': _lines,
              },
            ),
            OutlinedButton(
              onPressed: () => setState(_lines.clear),
              child: Text(l.ichingAgain),
            ),
            const SizedBox(height: 8),
            Text(l.ichingNote, style: t.bodySmall),
          ],
        ],
      ),
    );
  }
}

/// Solid (yang) or broken (yin) bar; changing lines get a gold marker.
class _HexLine extends StatelessWidget {
  final int? line;
  const _HexLine(this.line);
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = line == null ? cs.outlineVariant : cs.primary;
    Widget bar(double w) => Container(
      width: w,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 22,
            child: line != null && isChanging(line!)
                ? Icon(Icons.circle, size: 10, color: cs.tertiary)
                : null,
          ),
          if (line == null || isYang(line!))
            bar(170)
          else ...[
            bar(76),
            const SizedBox(width: 18),
            bar(76),
          ],
          const SizedBox(width: 22),
        ],
      ),
    );
  }
}
