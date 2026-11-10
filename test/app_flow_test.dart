import 'package:digi_witch/data/content.dart';
import 'package:digi_witch/data/store.dart';
import 'package:digi_witch/main.dart';
import 'package:digi_witch/ui/journal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late Content content;
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    content = await Content.load();
  });

  Future<AppStore> pump(WidgetTester t, {bool onboarded = true}) async {
    SharedPreferences.setMockInitialValues({'onboarded': onboarded});
    final store = AppStore(await SharedPreferences.getInstance());
    t.view.physicalSize = const Size(1080, 2400);
    t.view.devicePixelRatio = 2.75;
    addTearDown(t.view.reset);
    await t.pumpWidget(DigiWitchApp(store: store, content: content));
    await t.pumpAndSettle();
    return store;
  }

  testWidgets(
    'onboarding without registration leads to Today with a card of the day',
    (t) async {
      await pump(t, onboarded: false);
      expect(find.textContaining('Nie potrzebujesz konta'), findsOneWidget);
      await t.tap(find.text('Zaczynamy'));
      await t.pumpAndSettle();
      expect(find.text('Karta dnia'), findsOneWidget);
    },
  );

  testWidgets(
    'numerology: date only computes, shows steps and interpretation',
    (t) async {
      await pump(t);
      await t.tap(find.text('Liczby'));
      await t.pumpAndSettle();
      await t.enterText(
        find.widgetWithText(TextField, 'Data urodzenia'),
        '29051975',
      );
      expect(find.text('29.05.1975'), findsOneWidget); // mask
      await t.tap(find.text('Oblicz'));
      await t.pumpAndSettle();
      expect(find.text('Droga życia'), findsOneWidget);
      await t.tap(find.text('Droga życia'));
      await t.pumpAndSettle();
      expect(
        find.text('Cyfry daty: 2 + 9 + 0 + 5 + 1 + 9 + 7 + 5 = 38.'),
        findsOneWidget,
      );
      expect(find.text('INTERPRETACJA SYMBOLICZNA'), findsWidgets);
      expect(
        find.text('Liczba ekspresji'),
        findsNothing,
      ); // no name -> no name indicators
    },
  );

  testWidgets('numerology: invalid date and unsupported letters are reported', (
    t,
  ) async {
    await pump(t);
    await t.tap(find.text('Liczby'));
    await t.pumpAndSettle();
    await t.enterText(
      find.widgetWithText(TextField, 'Data urodzenia'),
      '29022023',
    );
    await t.tap(find.text('Oblicz'));
    await t.pumpAndSettle();
    expect(find.textContaining('Taka data nie istnieje'), findsOneWidget);
    await t.enterText(find.widgetWithText(TextField, 'Data urodzenia'), '');
    await t.enterText(
      find.widgetWithText(TextField, 'Imię i nazwisko (opcjonalnie)'),
      'Jürgen',
    );
    await t.tap(find.text('Oblicz'));
    await t.pumpAndSettle();
    expect(find.textContaining('Nieobsługiwane znaki: ü'), findsOneWidget);
  });

  testWidgets(
    'tarot three-card spread and saving a reflection to the journal',
    (t) async {
      final store = await pump(t);
      await t.tap(find.text('Tarot').last);
      await t.pumpAndSettle();
      await t.tap(find.text('Wylosuj karty'));
      await t.pumpAndSettle();
      expect(find.text('Sytuacja'), findsOneWidget);
      expect(find.text('Następny krok'), findsOneWidget);
      await t.ensureVisible(find.text('Zapisz refleksję w dzienniku'));
      await t.pumpAndSettle();
      await t.tap(find.text('Zapisz refleksję w dzienniku'));
      await t.pumpAndSettle();
      expect(find.byType(EntryEditor), findsOneWidget);
      await t.enterText(
        find.descendant(
          of: find.byType(EntryEditor),
          matching: find.byType(TextField),
        ),
        'Moja myśl',
      );
      await t.tap(find.text('Zapisz'));
      await t.pumpAndSettle();
      expect(store.journal.single.text, 'Moja myśl');
      expect(store.journal.single.ref!['cards'].length, 3);
    },
  );

  testWidgets('library search finds a card and opens its detail', (t) async {
    await pump(t);
    await t.tap(find.text('Biblioteka'));
    await t.pumpAndSettle();
    await t.enterText(find.byType(TextField), 'wieża');
    await t.pumpAndSettle();
    await t.tap(find.text('Wieża'));
    await t.pumpAndSettle();
    expect(find.text('INTERPRETACJA PROSTA'), findsOneWidget);
    await t.scrollUntilVisible(
      find.text('INTERPRETACJA ODWRÓCONA'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('INTERPRETACJA ODWRÓCONA'), findsOneWidget);
  });

  testWidgets('dark theme and 2x text scale render without overflow', (
    t,
  ) async {
    SharedPreferences.setMockInitialValues({
      'onboarded': true,
      'themeMode': 'dark',
    });
    final store = AppStore(await SharedPreferences.getInstance());
    t.view.physicalSize = const Size(1080, 2400);
    t.view.devicePixelRatio = 2.75;
    addTearDown(t.view.reset);
    await t.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: DigiWitchApp(store: store, content: content),
      ),
    );
    await t.pumpAndSettle();
    for (final tab in ['Liczby', 'Tarot', 'Biblioteka', 'Dziennik']) {
      await t.tap(find.text(tab).last);
      await t.pumpAndSettle();
    }
    expect(t.takeException(), isNull);
  });

  testWidgets('Pro spreads are locked for free users and open for Pro', (
    t,
  ) async {
    final store = await pump(t);
    await t.tap(find.text('Tarot').last);
    await t.pumpAndSettle();
    await t.tap(find.text('Krzyż refleksji'));
    await t.pumpAndSettle();
    expect(
      find.textContaining('Zakup jest w tej chwili niedostępny'),
      findsOneWidget,
    ); // no store in tests
    expect(find.textContaining('nie wpływa na losowanie'), findsOneWidget);
    await t.tapAt(const Offset(10, 10)); // dismiss sheet
    await t.pumpAndSettle();

    store.isPro = true;
    await t.pumpAndSettle();
    await t.tap(find.text('Krzyż refleksji'));
    await t.pumpAndSettle();
    await t.tap(find.text('Wylosuj karty'));
    await t.pumpAndSettle();
    expect(find.text('Możliwy kierunek', skipOffstage: false), findsOneWidget);
  });

  testWidgets(
    'saving profile with an invalid date shows an error and keeps the old date',
    (t) async {
      SharedPreferences.setMockInitialValues({
        'onboarded': true,
        'birthDate': '1990-07-15',
      });
      final store = AppStore(await SharedPreferences.getInstance());
      t.view.physicalSize = const Size(1080, 2400);
      t.view.devicePixelRatio = 2.75;
      addTearDown(t.view.reset);
      await t.pumpWidget(DigiWitchApp(store: store, content: content));
      await t.pumpAndSettle();
      await t.tap(find.text('Liczby'));
      await t.pumpAndSettle();
      await t.enterText(
        find.widgetWithText(TextField, 'Data urodzenia'),
        '1507199',
      );
      await t.tap(find.text('Zapamiętaj jako mój profil'));
      await t.pumpAndSettle();
      expect(find.textContaining('Taka data nie istnieje'), findsOneWidget);
      expect(store.birthDate?.iso, '1990-07-15');
      await t.enterText(
        find.widgetWithText(TextField, 'Data urodzenia'),
        '01012099',
      );
      await t.tap(find.text('Zapamiętaj jako mój profil'));
      await t.pumpAndSettle();
      expect(find.textContaining('z przyszłości'), findsOneWidget);
      expect(store.birthDate?.iso, '1990-07-15');
    },
  );
}
