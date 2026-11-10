import 'package:flutter/material.dart';

import '../engine/numerology.dart';
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
                ],
              ),
            ),
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
