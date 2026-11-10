import 'package:flutter/material.dart';

import '../data/content.dart';
import '../engine/tarot.dart';
import 'pro_sheet.dart';
import 'widgets.dart';

Map<String, dynamic> spreadRef(
  BuildContext context,
  String label,
  List<DrawnCard> cards,
) => {
  'type': 'tarot',
  'label': label,
  'cards': [
    for (final c in cards)
      {...c.toJson(), 'name': context.content.cards[c.cardId]!.name},
  ],
};

class TarotScreen extends StatefulWidget {
  const TarotScreen({super.key});
  @override
  State<TarotScreen> createState() => _TarotScreenState();
}

class _TarotScreenState extends State<TarotScreen> {
  Spread _spread = spreads[1];
  List<DrawnCard>? _drawn;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return Scaffold(
      appBar: AppBar(title: Text(l.tabTarot)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.tarotIntro),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (final s in spreads)
                ChoiceChip(
                  label: Text(s.name),
                  avatar: s.pro && !context.store.isPro
                      ? Icon(Icons.lock_outline, semanticLabel: l.proOnly)
                      : null,
                  selected: _spread == s,
                  onSelected: (_) => s.pro && !context.store.isPro
                      ? showProSheet(context)
                      : setState(() {
                          _spread = s;
                          _drawn = null;
                        }),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _spread.positions.join(' — '),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            icon: const Icon(Icons.style_outlined),
            label: Text(_drawn == null ? l.drawCards : l.drawAgain),
            onPressed: () =>
                setState(() => _drawn = context.store.drawSpread(_spread)),
          ),
          Text(
            context.store.allowReversed ? l.reversedOn : l.reversedOff,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          AnimatedSwitcher(
            duration: context.reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 300),
            child: _drawn == null
                ? const SizedBox.shrink()
                : Column(
                    key: ValueKey(_drawn),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final d in _drawn!) DrawnCardTile(d),
                      SaveReflectionButton(
                        prompt: l.spreadReflectionPrompt,
                        ref: spreadRef(
                          context,
                          '${_spread.name}: ${_drawn!.map((d) => context.content.cards[d.cardId]!.name).join(', ')}',
                          _drawn!,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class DrawnCardTile extends StatelessWidget {
  final DrawnCard d;
  const DrawnCardTile(this.d, {super.key});
  @override
  Widget build(BuildContext context) {
    final card = context.content.cards[d.cardId]!;
    return Card(
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CardDetail(card, reversed: d.reversed),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardFace(card, reversed: d.reversed, width: 72),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.position,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      '${card.name}${d.reversed ? ' (${context.l.reversed})' : ''}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      d.reversed ? card.reversed : card.upright,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardDetail extends StatelessWidget {
  final TarotCard card;
  final bool? reversed; // null = opened from library, show both
  const CardDetail(this.card, {super.key, this.reversed});

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final bookmarked = context.store.bookmarks.contains(card.id);
    return Scaffold(
      appBar: AppBar(
        title: Text(card.name),
        actions: [
          IconButton(
            tooltip: bookmarked ? l.removeBookmark : l.addBookmark,
            icon: Icon(bookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () => context.store.toggleBookmark(card.id),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CardFace(card, reversed: reversed ?? false, width: 140),
          ),
          LabeledBlock(l.group, Text(card.group)),
          LabeledBlock(l.keywords, Text(card.keywords.join(' · '))),
          LabeledBlock(l.symbolism, Text(card.symbolism)),
          if (reversed != true) LabeledBlock(l.upright, Text(card.upright)),
          if (reversed != false)
            LabeledBlock(l.reversedMeaning, Text(card.reversed)),
          LabeledBlock(
            l.reflectionQuestions,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final q in card.reflection)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('• $q'),
                  ),
              ],
            ),
          ),
          SaveReflectionButton(
            prompt: card.reflection.first,
            ref: {
              'type': 'card',
              'label':
                  '${card.name}${reversed == true ? ' (${l.reversed})' : ''}',
              'cardId': card.id,
              'reversed': reversed ?? false,
            },
          ),
          LabeledBlock(
            l.sourcesAndRights,
            Text(
              l.cardSourceNote,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
