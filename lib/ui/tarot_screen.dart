import 'dart:math';

import 'package:flutter/material.dart';

import '../data/content.dart';
import '../engine/tarot.dart';
import 'journal_screen.dart';
import 'library_screen.dart';
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
  String _question = ''; // the question the current draw answers
  final _questionCtl = TextEditingController();

  @override
  void dispose() {
    _questionCtl.dispose();
    super.dispose();
  }

  void _draw() {
    FocusScope.of(context).unfocus();
    setState(() {
      _question = _questionCtl.text.trim();
      _drawn = context.store.drawSpread(_spread);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final t = Theme.of(context).textTheme;
    final drawn = _drawn;
    void openDeck() => pushScreen(context, const LibraryScreen());
    return Scaffold(
      appBar: AppBar(
        title: Text(l.tabTarot),
        leadingWidth: topLeadingWidth,
        leading: topLeading(context),
      ),
      body: ListView(
        padding: pagePadding(context),
        children: [
          if (context.store.tarotWelcome)
            TarotFrame(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          l.tarotWelcomeTitle,
                          style: t.headlineSmall,
                        ),
                      ),
                      // Comes back from Settings.
                      IconButton(
                        tooltip: l.hide,
                        icon: const Icon(Icons.close),
                        onPressed: () => context.store.tarotWelcome = false,
                      ),
                    ],
                  ),
                  Text(l.tarotWelcomeBody),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton.icon(
                      icon: const Icon(Icons.menu_book_outlined),
                      label: Text(l.seeDeck),
                      onPressed: openDeck,
                    ),
                  ),
                ],
              ),
            ),
          Text(l.tarotIntro, style: t.bodySmall),
          SectionTitle(l.chooseSpread),
          LayoutBuilder(
            builder: (context, box) {
              final w = (box.maxWidth - 16) / 3;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final s in spreads)
                    SizedBox(
                      width: w,
                      child: SpreadTile(
                        s,
                        selected: _spread == s,
                        locked: s.pro && !context.store.isPro,
                        onTap: () => s.pro && !context.store.isPro
                            ? showProSheet(context)
                            : setState(() {
                                _spread = s;
                                _drawn = null;
                              }),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          Text(_spread.positions.join(' — '), style: t.bodySmall),
          const SizedBox(height: 14),
          TextField(
            controller: _questionCtl,
            maxLength: 200,
            minLines: 1,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l.questionLabel,
              hintText: l.questionHint,
              prefixIcon: const Icon(Icons.help_outline),
            ),
          ),
          const SizedBox(height: 4),
          AnimatedSwitcher(
            duration: context.reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 350),
            child: drawn == null
                ? Semantics(
                    button: true,
                    label: l.drawCards,
                    excludeSemantics: true,
                    child: GestureDetector(
                      onTap: _draw,
                      child: Column(
                        children: [
                          const DeckStack(),
                          Text(l.tapDeck, style: t.bodySmall),
                        ],
                      ),
                    ),
                  )
                : RevealedSpread(drawn, key: ValueKey(drawn)),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            icon: const Icon(Icons.style_outlined),
            label: Text(drawn == null ? l.drawCards : l.drawAgain),
            onPressed: _draw,
          ),
          const SizedBox(height: 4),
          Text(
            context.store.allowReversed ? l.reversedOn : l.reversedOff,
            style: t.bodySmall,
            textAlign: TextAlign.center,
          ),
          if (drawn != null) ...[
            ReadingSummary(
              drawn,
              question: _question,
              yesNoSpread: _spread.id == 'yesno',
            ),
            for (final d in drawn) DrawnCardTile(d),
            SaveReflectionButton(
              prompt: l.spreadReflectionPrompt,
              ref: spreadRef(
                context,
                '${_question.isEmpty ? '' : '„$_question” — '}${_spread.name}: ${drawn.map((d) => context.content.cards[d.cardId]!.name).join(', ')}',
                drawn,
              ),
            ),
          ],
          const SizedBox(height: 16),
          TileGrid([(Icons.menu_book_outlined, l.deckTitle, '', openDeck)]),
        ],
      ),
    );
  }
}

/// Spread choice: name, card count and a mini map of the card slots.
class SpreadTile extends StatelessWidget {
  final Spread spread;
  final bool selected, locked;
  final VoidCallback onTap;
  const SpreadTile(
    this.spread, {
    super.key,
    required this.selected,
    required this.locked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l = context.l;
    final n = spread.positions.length;
    return Semantics(
      button: true,
      selected: selected,
      label:
          '${spread.name}, ${l.spreadCards(n)}${locked ? ', ${l.proOnly}' : ''}',
      excludeSemantics: true,
      child: Material(
        color: selected ? cs.primary.withValues(alpha: 0.08) : cs.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: selected ? cs.tertiary : cs.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
            child: Column(
              children: [
                SizedBox(
                  height: 34,
                  child: Center(
                    child: Wrap(
                      spacing: 3,
                      runSpacing: 3,
                      alignment: WrapAlignment.center,
                      children: [
                        for (var i = 0; i < n; i++)
                          Container(
                            width: n > 6 ? 6 : 11,
                            height: n > 6 ? 13 : (n > 3 ? 15 : 22),
                            decoration: BoxDecoration(
                              color: selected
                                  ? cs.primary
                                  : cs.primary.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (locked)
                      Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: Icon(
                          Icons.lock_outline,
                          size: 14,
                          color: cs.secondary,
                        ),
                      ),
                    Flexible(
                      // One line in every tile keeps the grid rows even.
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          spread.name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  l.spreadCards(n),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The back of a card: indigo with a gold frame and star (matches the app icon).
class CardBack extends StatelessWidget {
  final double width;
  const CardBack({super.key, this.width = 96});
  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: width * 1.72,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(width * 0.08),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF5A4C8A), Color(0xFF2E2552)],
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x33000000),
          blurRadius: 8,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: CustomPaint(painter: _BackPainter()),
  );
}

class _BackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = const Color(0xFFC9A44C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final r = RRect.fromRectAndRadius(
      Offset.zero & s,
      Radius.circular(s.width * 0.06),
    ).deflate(s.width * 0.07);
    canvas.drawRRect(r, p);
    final fill = Paint()..color = const Color(0xFFF3E9D2);
    canvas.drawPath(starPath(s.center(Offset.zero), s.width * 0.22), fill);
    canvas.drawPath(
      starPath(s.center(Offset(s.width * 0.2, -s.width * 0.3)), s.width * 0.07),
      fill,
    );
  }

  @override
  bool shouldRepaint(_BackPainter old) => false;
}

/// Fanned deck shown before drawing.
class DeckStack extends StatelessWidget {
  const DeckStack({super.key});
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 190,
    child: Stack(
      alignment: Alignment.center,
      children: [
        for (final a in const [-0.12, 0.0, 0.12])
          Transform.rotate(
            angle: a,
            alignment: Alignment.bottomCenter,
            child: const CardBack(width: 96),
          ),
      ],
    ),
  );
}

/// Drawn cards flip face up one after another (instant with reduced motion).
class RevealedSpread extends StatelessWidget {
  final List<DrawnCard> cards;
  const RevealedSpread(this.cards, {super.key});
  @override
  Widget build(BuildContext context) {
    final n = cards.length;
    final w = n == 1 ? 120.0 : (n <= 3 ? 92.0 : (n <= 6 ? 68.0 : 52.0));
    final still = context.reduceMotion;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: [
          for (var i = 0; i < n; i++)
            Column(
              children: [
                FlipCard(
                  card: cards[i],
                  width: w,
                  duration: still
                      ? Duration.zero
                      : Duration(milliseconds: 600 + 220 * i),
                  start: still ? 0 : (220 * i) / (600 + 220 * i),
                ),
                const SizedBox(height: 4),
                Text(
                  '${i + 1}',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// A card turning from its back to its face.
class FlipCard extends StatelessWidget {
  final DrawnCard card;
  final double width, start;
  final Duration duration;
  const FlipCard({
    super.key,
    required this.card,
    required this.width,
    required this.duration,
    required this.start,
  });
  @override
  Widget build(BuildContext context) {
    final face = context.content.cards[card.cardId]!;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: Interval(start, 1, curve: Curves.easeInOut),
      builder: (context, v, _) {
        final angle = v * pi;
        final showFace = angle > pi / 2;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..rotateY(showFace ? angle - pi : angle),
          child: showFace
              ? CardFace(face, reversed: card.reversed, width: width)
              : CardBack(width: width),
        );
      },
    );
  }
}

/// Rule-based answer: question + spread patterns + the last position's card.
class ReadingSummary extends StatelessWidget {
  final List<DrawnCard> cards;
  final String question;
  final bool yesNoSpread;
  const ReadingSummary(
    this.cards, {
    super.key,
    required this.question,
    this.yesNoSpread = false,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final s = summarize(cards);
    final last = cards.last;
    final card = context.content.cards[last.cardId]!;
    final lines = [
      if (yesNoSpread) l.yesNoAnswer(yesNo(last).name),
      if (s.majorsDominate) l.summaryMajors,
      if (s.dominantSuit != null) l.summarySuit(s.dominantSuit!),
      if (s.mostlyReversed) l.summaryReversed,
      if (cards.length >= 3 && !s.majorsDominate && s.dominantSuit == null)
        l.summaryBalanced,
      l.summaryAnswer(
        last.position,
        '${card.name}${last.reversed ? ' (${l.reversed})' : ''}',
        last.reversed ? card.adviceReversed : card.advice,
      ),
    ];
    final t = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.isEmpty ? l.readingTitleNoQuestion : l.readingTitle,
              style: t.titleMedium,
            ),
            if (question.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '„$question”',
                  style: t.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(line),
              ),
          ],
        ),
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
        padding: screenPadding(context),
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
            l.cardAdvice,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (reversed != true) Text(card.advice),
                if (reversed == null) const SizedBox(height: 6),
                if (reversed != false)
                  Text(
                    reversed == null
                        ? '${l.reversed[0].toUpperCase()}${l.reversed.substring(1)}: ${card.adviceReversed}'
                        : card.adviceReversed,
                  ),
              ],
            ),
          ),
          LabeledBlock(l.correspondences, Text(card.astrology)),
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
