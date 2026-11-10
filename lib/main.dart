import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/content.dart';
import 'data/store.dart';
import 'l10n/app_localizations.dart';
import 'monetization/monetization.dart';
import 'reminders.dart';
import 'ui/journal_screen.dart';
import 'ui/library_screen.dart';
import 'ui/numerology_screen.dart';
import 'ui/tarot_screen.dart';
import 'ui/theme.dart';
import 'ui/today_screen.dart';
import 'ui/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final results = await Future.wait([AppStore.open(), Content.load()]);
  final store = results[0] as AppStore;
  final m = monetizationSupported ? Monetization(store) : null;
  runApp(
    DigiWitchApp(store: store, content: results[1] as Content, monetization: m),
  );
  if (store.onboarded) {
    m?.init(); // first run: started from onboarding, so consent never covers it
  }
}

class DigiWitchApp extends StatelessWidget {
  final AppStore store;
  final Content content;
  final Monetization? monetization;
  const DigiWitchApp({
    super.key,
    required this.store,
    required this.content,
    this.monetization,
  });

  @override
  Widget build(BuildContext context) => AppScope(
    store: store,
    content: content,
    monetization: monetization,
    child: ListenableBuilder(
      listenable: Listenable.merge([store, monetization]),
      builder: (context, _) => MaterialApp(
        onGenerateTitle: (c) => AppLocalizations.of(c).appTitle,
        debugShowCheckedModeBanner: false,
        theme: buildTheme(Brightness.light),
        darkTheme: buildTheme(Brightness.dark),
        themeMode: ThemeMode.values.byName(store.themeMode),
        locale: const Locale('pl'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: store.onboarded ? const HomeShell() : const Onboarding(),
      ),
    ),
  );
}

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 24),
            Semantics(
              header: true,
              child: Text(
                l.appTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 16),
            Text(l.onboardWhat),
            const SizedBox(height: 12),
            Text(l.onboardNot),
            const SizedBox(height: 12),
            Text(l.onboardPrivacy),
            const SizedBox(height: 12),
            Text(l.onboardAdults),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                context.store.onboarded = true;
                context.monetization?.init();
              },
              child: Text(l.start),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _i = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final m = context.store.reminderMinutes;
      if (m != null) {
        Reminders.reschedule(
          m,
          title: context.l.reminderTitle,
          body: context.l.reminderBody,
        );
      }
    });
  }

  static const _pages = [
    TodayScreen(),
    NumerologyScreen(),
    TarotScreen(),
    LibraryScreen(),
    JournalScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return Scaffold(
      body: IndexedStack(index: _i, children: _pages),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // No ads in the private journal or for Pro.
          if (context.monetization case final m?)
            Offstage(
              offstage: _i == 4,
              child: ListenableBuilder(
                listenable: m,
                builder: (_, _) => m.isPro || !m.canShowAds
                    ? const SizedBox.shrink()
                    : AdBanner(m),
              ),
            ),
          NavigationBar(
            selectedIndex: _i,
            onDestinationSelected: (i) => setState(() => _i = i),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.wb_twilight_outlined),
                label: l.tabToday,
              ),
              NavigationDestination(
                icon: const Icon(Icons.tag),
                label: l.tabNumerology,
              ),
              NavigationDestination(
                icon: const Icon(Icons.style_outlined),
                label: l.tabTarot,
              ),
              NavigationDestination(
                icon: const Icon(Icons.menu_book_outlined),
                label: l.tabLibrary,
              ),
              NavigationDestination(
                icon: const Icon(Icons.edit_note),
                label: l.tabJournal,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
