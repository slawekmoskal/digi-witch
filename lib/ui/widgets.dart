import 'package:flutter/material.dart';

import '../data/content.dart';
import '../data/store.dart';
import '../l10n/app_localizations.dart';
import 'journal_screen.dart';

/// App-wide access to store + content without a state-management package.
class AppScope extends InheritedNotifier<AppStore> {
  final Content content;
  const AppScope({super.key, required AppStore store, required this.content, required super.child})
      : super(notifier: store);

  static AppScope of(BuildContext c) => c.dependOnInheritedWidgetOfExactType<AppScope>()!;
  AppStore get store => notifier!;
}

extension Ctx on BuildContext {
  AppLocalizations get l => AppLocalizations.of(this);
  AppStore get store => AppScope.of(this).store;
  Content get content => AppScope.of(this).content;
  bool get reduceMotion => MediaQuery.of(this).disableAnimations;
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 8),
        child: Semantics(header: true, child: Text(text, style: Theme.of(context).textTheme.titleMedium)),
      );
}

/// Small labelled block; [label] distinguishes "calculation" from "symbolic interpretation".
class LabeledBlock extends StatelessWidget {
  final String label;
  final Widget child;
  const LabeledBlock(this.label, this.child, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.2, color: Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 4),
          child,
        ]),
      );
}

/// Typographic card face — no artwork until image rights are cleared (docs/research/rws-rights.md).
class CardFace extends StatelessWidget {
  final TarotCard card;
  final bool reversed;
  final double width;
  const CardFace(this.card, {super.key, this.reversed = false, this.width = 110});

  static const _suitIcon = {
    'wands': Icons.local_florist_outlined,
    'cups': Icons.wine_bar_outlined,
    'swords': Icons.change_history_outlined,
    'pentacles': Icons.brightness_7_outlined,
  };

  static String roman(int n) {
    if (n == 0) return '0';
    const v = [10, 9, 5, 4, 1], s = ['X', 'IX', 'V', 'IV', 'I'];
    var r = '';
    for (var i = 0; i < v.length; i++) {
      while (n >= v[i]) {
        r += s[i];
        n -= v[i];
      }
    }
    return r;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final face = Container(
      width: width,
      height: width * 1.6,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: card.arcana == 'major' ? cs.primaryContainer : cs.secondaryContainer,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.outline),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(card.arcana == 'major' ? roman(card.rank) : '', style: Theme.of(context).textTheme.labelLarge),
        Expanded(
          child: Icon(card.arcana == 'major' ? Icons.auto_awesome_outlined : _suitIcon[card.suit], size: width * 0.3),
        ),
        Text(card.name,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium),
      ]),
    );
    // Historical 1909 artwork (public domain, provenance in assets/cards/manifest.json); typographic face as fallback.
    final art = ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.asset('assets/cards/${card.id}.webp',
          width: width, height: width * 1.72, fit: BoxFit.cover, errorBuilder: (_, _, _) => face),
    );
    return Semantics(
      label: '${card.name}${reversed ? ', ${context.l.reversed}' : ''}',
      excludeSemantics: true,
      // Face text is decorative (full name is shown next to it / in the label), so cap its scaling.
      child: MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.2,
        child: reversed ? RotatedBox(quarterTurns: 2, child: art) : art,
      ),
    );
  }
}

/// Opens the journal editor pre-linked to a result snapshot.
class SaveReflectionButton extends StatelessWidget {
  final String prompt;
  final Map<String, dynamic>? ref;
  const SaveReflectionButton({super.key, required this.prompt, this.ref});
  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          icon: const Icon(Icons.edit_note),
          label: Text(context.l.writeReflection),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => EntryEditor(promptText: prompt, ref: ref))),
        ),
      );
}
