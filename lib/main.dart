import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks([
      'Cormorant Garamond',
    ], await rootBundle.loadString('assets/fonts/OFL.txt'));
  });
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
  int _i = 2; // Today, the centre button

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
    NumerologyScreen(),
    TarotScreen(),
    TodayScreen(),
    LibraryScreen(),
    JournalScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return Scaffold(
      extendBody: true, // pages scroll under the floating bar
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
          FloatingNav(
            index: _i,
            onSelect: (i) => setState(() => _i = i),
            items: [
              (Icons.tag, l.tabNumerology),
              (Icons.style_outlined, l.tabTarot),
              (Icons.wb_sunny_outlined, l.tabToday),
              (Icons.menu_book_outlined, l.tabLibrary),
              (Icons.edit_note, l.tabJournal),
            ],
          ),
        ],
      ),
    );
  }
}

/// Floating rounded bar with side margins; the middle item (Today) is a raised gold disc.
class FloatingNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onSelect;
  final List<(IconData, String)> items;
  const FloatingNav({
    super.key,
    required this.index,
    required this.onSelect,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final light = Theme.of(context).brightness == Brightness.light;
    // iOS: Liquid Glass look (blurred, translucent, bright rim) over scrolling content.
    // shortcut: Flutter imitation (blur + tint), not Apple's native material; native needs a UIKit platform view.
    final glass = Theme.of(context).platform == TargetPlatform.iOS;
    final on = glass
        ? (light ? cs.primary : cs.onSurface)
        : (light ? cs.onPrimary : cs.onSurface);
    final mid = items.length ~/ 2;
    final radius = BorderRadius.circular(35);
    final row = Row(
      children: [
        for (var i = 0; i < items.length; i++)
          Expanded(
            child: Semantics(
              button: true,
              selected: i == index,
              child: InkResponse(
                onTap: () => onSelect(i),
                radius: 36,
                child: i == mid
                    ? _centre(context, items[i], i == index)
                    : _item(context, items[i], i == index, on),
              ),
            ),
          ),
      ],
    );
    final shadow = [
      BoxShadow(
        color: Colors.black.withValues(alpha: glass ? 0.12 : 0.18),
        blurRadius: 18,
        offset: const Offset(0, 6),
      ),
    ];
    const box = BoxConstraints(minHeight: 70);
    const pad = EdgeInsets.symmetric(vertical: 6);
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(12, 6, 12, 10),
      child: MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.3,
        child: glass
            ? DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: radius,
                  boxShadow: shadow,
                ),
                child: ClipRRect(
                  borderRadius: radius,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                    child: Container(
                      constraints: box,
                      padding: pad,
                      decoration: BoxDecoration(
                        borderRadius: radius,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: light
                              ? [
                                  Colors.white.withValues(alpha: 0.62),
                                  Colors.white.withValues(alpha: 0.34),
                                ]
                              : [
                                  Colors.white.withValues(alpha: 0.16),
                                  Colors.white.withValues(alpha: 0.06),
                                ],
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(
                            alpha: light ? 0.75 : 0.22,
                          ),
                        ),
                      ),
                      child: row,
                    ),
                  ),
                ),
              )
            : Container(
                constraints: box,
                padding: pad,
                decoration: BoxDecoration(
                  color: light ? cs.primary : cs.surfaceContainerHighest,
                  borderRadius: radius,
                  boxShadow: shadow,
                ),
                child: row,
              ),
      ),
    );
  }

  Widget _item(BuildContext c, (IconData, String) it, bool sel, Color on) {
    final color = sel ? on : on.withValues(alpha: 0.78);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(it.$1, color: color, size: 24),
        const SizedBox(height: 2),
        Text(
          it.$2,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11.5,
            color: color,
            fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(top: 3),
          width: sel ? 18 : 0,
          height: 2.5,
          decoration: BoxDecoration(
            color: Theme.of(c).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _centre(BuildContext c, (IconData, String) it, bool sel) {
    final cs = Theme.of(c).colorScheme;
    return Center(
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: cs.tertiary,
          border: Border.all(
            color: sel ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(6),
        child: FittedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(it.$1, color: const Color(0xFF2B2140), size: 22),
              Text(
                it.$2,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2B2140),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
