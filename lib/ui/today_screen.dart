import 'package:flutter/material.dart';

import '../engine/numerology.dart';
import 'library_screen.dart';
import 'astro_screens.dart';
import 'numerology_screen.dart';
import 'settings_screen.dart';
import 'tarot_screen.dart';
import 'widgets.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final s = context.store;
    final now = DateTime.now();
    final today = CalendarDate.fromDateTime(now);
    final card = s.cardOfDay(today);
    final prompts = context.content.prompts;
    // Prompt of the day rotates by day-of-year, deterministic, no randomness needed.
    final prompt =
        prompts[(now.difference(DateTime(now.year)).inDays + now.year) %
            prompts.length];
    final birth = s.birthDate;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.appTitle),
        actions: [
          IconButton(
            tooltip: l.settings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
      body: ListView(
        padding: pagePadding(context),
        children: [
          Text(
            MaterialLocalizations.of(context).formatFullDate(now),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (birth != null)
            HoroscopeCard(birth, now)
          else
            TarotFrame(
              child: Column(
                children: [
                  Text(
                    l.horoscopeFor,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(l.horoscopeNeedsBirth, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  const QuickProfile(),
                ],
              ),
            ),
          SectionTitle(l.explore),
          const ExploreGrid(),
          const SizedBox(height: 8),
          MoonCard(now),
          SectionTitle(l.cardOfDay),
          DrawnCardTile(card),
          Text(l.cardOfDayNote, style: Theme.of(context).textTheme.bodySmall),
          SectionTitle(l.promptOfDay),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prompt.text,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SaveReflectionButton(prompt: prompt.text),
                ],
              ),
            ),
          ),
          if (birth != null) ...[
            SectionTitle(l.indicatorName('personalDay')),
            ResultCard(personalDay(birth, today)),
            SectionTitle(l.yourPersonalYear(now.year)),
            ResultCard(personalYear(birth, now.year)),
          ],
        ],
      ),
    );
  }
}

/// Birth date entry right on Today, so the horoscope is one step away.
class QuickProfile extends StatefulWidget {
  const QuickProfile({super.key});
  @override
  State<QuickProfile> createState() => _QuickProfileState();
}

class _QuickProfileState extends State<QuickProfile> {
  final _c = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _save() {
    final l = context.l;
    final d = parseUserDate(_c.text);
    final today = CalendarDate.fromDateTime(DateTime.now());
    setState(() {
      _error = d == null
          ? l.dateInvalid
          : d.compareTo(today) > 0
          ? l.dateFuture
          : null;
    });
    if (_error == null) {
      FocusScope.of(context).unfocus();
      context.store.saveProfile(d, context.store.fullName);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      TextField(
        controller: _c,
        keyboardType: TextInputType.number,
        inputFormatters: [DateMaskFormatter()],
        onSubmitted: (_) => _save(),
        decoration: InputDecoration(
          labelText: context.l.birthDate,
          hintText: 'DD.MM.RRRR',
          errorText: _error,
          prefixIcon: const Icon(Icons.cake_outlined),
        ),
      ),
      const SizedBox(height: 10),
      FilledButton(onPressed: _save, child: Text(context.l.showMyHoroscope)),
      const SizedBox(height: 6),
      Text(
        context.l.privacyShort,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );
}

/// Shortcuts to every part of the app, two per row with equal heights.
class ExploreGrid extends StatelessWidget {
  const ExploreGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    void push(Widget w) =>
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => w));
    final tiles = <(IconData, String, String, VoidCallback)>[
      (
        Icons.brightness_4_outlined,
        l.bigThree,
        l.exploreBigThree,
        () => push(const BirthChartScreen()),
      ),
      (
        Icons.pets_outlined,
        l.chineseTitle,
        l.exploreChinese,
        () => push(const ChineseScreen()),
      ),
      (
        Icons.style_outlined,
        l.exploreTarot,
        l.exploreTarotSub,
        () => homeTab.value = 1,
      ),
      (Icons.tag, l.yourNumbers, l.exploreNumbersSub, () => homeTab.value = 0),
      (
        Icons.dark_mode_outlined,
        l.moonCalendar,
        l.exploreMoon,
        () => push(const MoonCalendarScreen()),
      ),
      (
        Icons.nights_stay_outlined,
        l.dreams,
        l.exploreDreams,
        () => push(const DreamScreen()),
      ),
      (
        Icons.favorite_border,
        l.compatibility,
        l.compatibilityHint,
        () => push(const CompatibilityScreen()),
      ),
      (
        Icons.menu_book_outlined,
        l.exploreLibraryTitle,
        l.exploreLibrary,
        () => homeTab.value = 3,
      ),
    ];
    Widget tile((IconData, String, String, VoidCallback) x) => Expanded(
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
                Text(
                  x.$2,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontSize: 19),
                ),
                const SizedBox(height: 2),
                Text(x.$3, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
    return Column(
      children: [
        for (var i = 0; i < tiles.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  tile(tiles[i]),
                  const SizedBox(width: 10),
                  tile(tiles[i + 1]),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
