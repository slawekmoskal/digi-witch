import 'dart:math';

import 'package:flutter/material.dart';

import '../data/content.dart';
import '../data/store.dart';
import '../l10n/app_localizations.dart';
import '../monetization/monetization.dart';
import 'journal_screen.dart';

/// App-wide access to store + content without a state-management package.
class AppScope extends InheritedNotifier<AppStore> {
  final Content content;
  final Monetization? monetization; // null in tests / web
  const AppScope({
    super.key,
    required AppStore store,
    required this.content,
    this.monetization,
    required super.child,
  }) : super(notifier: store);

  static AppScope of(BuildContext c) =>
      c.dependOnInheritedWidgetOfExactType<AppScope>()!;
  AppStore get store => notifier!;
}

/// Current bottom tab (0 Numbers, 1 Tarot, 2 Today, 3 Library, 4 Journal); tiles can switch it.
final homeTab = ValueNotifier<int>(2);

extension Ctx on BuildContext {
  AppLocalizations get l => AppLocalizations.of(this);
  AppStore get store => AppScope.of(this).store;
  Content get content => AppScope.of(this).content;
  Monetization? get monetization => AppScope.of(this).monetization;
  bool get reduceMotion => MediaQuery.of(this).disableAnimations;
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: gap * 2, bottom: gap / 2),
    child: Semantics(
      header: true,
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    ),
  );
}

/// Small labelled block; [label] distinguishes "calculation" from "symbolic interpretation".
class LabeledBlock extends StatelessWidget {
  final String label;
  final Widget child;

  /// Label and content on the centre axis (hero sections such as the day's numbers).
  final bool centered;
  const LabeledBlock(
    this.label,
    this.child, {
    super.key,
    this.centered = false,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24),
    child: Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        // Section label: a step above body text (15) so it reads as a heading.
        Semantics(
          header: true,
          child: Text(
            label.toUpperCase(),
            textAlign: centered ? TextAlign.center : null,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              height: 1.25,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    ),
  );
}

/// Four-pointed star with concave sides, as in the app icon.
Path starPath(Offset c, double r) {
  final p = Path()..moveTo(c.dx, c.dy - r);
  for (var i = 1; i <= 4; i++) {
    final a = -pi / 2 + i * pi / 2;
    p.quadraticBezierTo(c.dx, c.dy, c.dx + r * cos(a), c.dy + r * sin(a));
  }
  return p..close();
}

/// The app's one spacing: page sides and the gap between blocks (each block carries half
/// of it above and below). Change it here, not per screen.
const gap = 12.0;

/// List padding for tab pages: content scrolls under the floating nav bar,
/// so the bottom inset (bar height) is added to the usual margin.
EdgeInsets pagePadding(BuildContext c, {double maxWidth = 720}) {
  final side = _side(c, maxWidth);
  return EdgeInsets.fromLTRB(
    side,
    gap / 2,
    side,
    24 + MediaQuery.paddingOf(c).bottom,
  );
}

/// Padding for pushed screens: [gap] all round, with the same reading-width limit.
EdgeInsets screenPadding(BuildContext c) {
  final side = _side(c, 720);
  return EdgeInsets.fromLTRB(
    side,
    gap,
    side,
    gap + MediaQuery.paddingOf(c).bottom,
  );
}

/// From this window width (foldables unfolded, tablets, landscape) the bottom bar becomes
/// a rail on the right and content keeps a comfortable reading width.
bool isWide(BuildContext c) =>
    MediaQuery.sizeOf(c).width - MediaQuery.paddingOf(c).horizontal >= 600;
const railWidth = 84.0;

/// True when iOS shows the tabs itself in its vertical bar (iPhone Duo: the strip on the
/// right with the clock). The system covers whatever the app draws there, so the app
/// then draws no menu of its own.
final nativeTabs = ValueNotifier<bool>(false);

/// Height the system's bottom tab bar takes from the bottom of the screen (0 when it is
/// hidden or at the side). The system does not put it in the safe area Flutter sees.
final nativeBarInset = ValueNotifier<double>(0);

/// Whether the tabs are the app's own rail on the right (a wide window).
bool hasRail(BuildContext c) => isWide(c) && !nativeTabs.value;

// Side margin that centres content of at most [maxWidth] in what the rail leaves.
double _side(BuildContext c, double maxWidth) {
  final w = MediaQuery.sizeOf(c).width - (hasRail(c) ? railWidth : 0);
  return max(gap, (w - maxWidth) / 2);
}

/// Ornamental double gold frame with star corners — the "tarot card" container.
class TarotFrame extends StatelessWidget {
  final Widget child;
  const TarotFrame({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: gap / 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [cs.surface, cs.surfaceContainerHighest],
        ),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: CustomPaint(
        foregroundPainter: _FramePainter(cs.tertiary),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
          child: child,
        ),
      ),
    );
  }
}

class _FramePainter extends CustomPainter {
  final Color color;
  _FramePainter(this.color);

  @override
  void paint(Canvas canvas, Size s) {
    final line = Paint()
      ..color = color
      ..style = PaintingStyle.stroke;
    final outer = RRect.fromRectAndRadius(
      Offset.zero & s,
      const Radius.circular(26),
    ).deflate(3);
    canvas.drawRRect(outer, line..strokeWidth = 1.4);
    canvas.drawRRect(outer.deflate(5), line..strokeWidth = 0.7);
    final fill = Paint()..color = color;
    for (final c in [
      const Offset(16, 16),
      Offset(s.width - 16, 16),
      Offset(16, s.height - 16),
      Offset(s.width - 16, s.height - 16),
    ]) {
      canvas.drawPath(starPath(c, 7), fill);
    }
    canvas.drawPath(starPath(Offset(s.width / 2, 8), 5), fill);
  }

  @override
  bool shouldRepaint(_FramePainter old) => old.color != color;
}

/// Big serif number in a gold ring — numbers are the app's key results.
class NumberBadge extends StatelessWidget {
  final String text;
  final double size;
  const NumberBadge(this.text, {super.key, this.size = 56});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: cs.primary.withValues(alpha: 0.06),
        border: Border.all(color: cs.tertiary, width: 1.6),
      ),
      child: MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.3,
        child: Text(
          text,
          style: Theme.of(context).textTheme.headlineMedium
              ?.copyWith(fontSize: size * 0.5, color: cs.primary, height: 1),
        ),
      ),
    );
  }
}

/// Typographic card face — no artwork until image rights are cleared (docs/research/rws-rights.md).
class CardFace extends StatelessWidget {
  final TarotCard card;
  final bool reversed;
  final double width;
  const CardFace(
    this.card, {
    super.key,
    this.reversed = false,
    this.width = 110,
  });

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
        color: card.arcana == 'major'
            ? cs.primaryContainer
            : cs.secondaryContainer,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.outline),
      ),
      // Thumbnails (e.g. library list) are too small for text: icon only.
      child: width < 60
          ? Icon(
              card.arcana == 'major'
                  ? Icons.auto_awesome_outlined
                  : _suitIcon[card.suit],
              size: width * 0.5,
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  card.arcana == 'major' ? roman(card.rank) : '',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Expanded(
                  child: Icon(
                    card.arcana == 'major'
                        ? Icons.auto_awesome_outlined
                        : _suitIcon[card.suit],
                    size: width * 0.3,
                  ),
                ),
                Text(
                  card.name,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
    );
    // Historical 1909 artwork (public domain, provenance in assets/cards/manifest.json); typographic face as fallback.
    final art = ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.asset(
        'assets/cards/${card.id}.webp',
        width: width,
        height: width * 1.72,
        cacheWidth: (width * MediaQuery.devicePixelRatioOf(context)).round(),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => face,
      ),
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
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => EntryEditor(promptText: prompt, ref: ref),
        ),
      ),
    ),
  );
}

/// A shortcut tile: icon, title, subtitle (may be empty), action.
typedef Tile = (IconData, String, String, VoidCallback);

/// Shortcut tiles in rows of [columns] with equal heights; a short last row keeps tile widths.
class TileGrid extends StatelessWidget {
  final List<Tile> tiles;
  final int columns;
  const TileGrid(this.tiles, {super.key, this.columns = 2});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    Widget tile(Tile x) => Expanded(
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: x.$4,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  x.$1,
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 28,
                ),
                const SizedBox(height: 8),
                Text(x.$2, style: t.titleMedium?.copyWith(fontSize: 19)),
                if (x.$3.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(x.$3, style: t.bodySmall),
                ],
              ],
            ),
          ),
        ),
      ),
    );
    return Column(
      children: [
        for (var i = 0; i < tiles.length; i += columns)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var j = i; j < i + columns; j++) ...[
                    if (j > i) const SizedBox(width: 10),
                    j < tiles.length
                        ? tile(tiles[j])
                        : const Expanded(child: SizedBox()),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

void pushScreen(BuildContext context, Widget w) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => w));
