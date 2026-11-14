import 'dart:async';
import 'dart:convert';

import 'package:digi_witch/data/content.dart';
import 'package:digi_witch/data/places.dart';
import 'package:digi_witch/data/store.dart';
import 'package:digi_witch/engine/numerology.dart';
import 'package:digi_witch/home_widget_sync.dart'
    show
        clearHomeWidget,
        resetHomeWidgetSyncForTest,
        retryPendingHomeWidgetClear,
        widgetKeys;
import 'package:digi_witch/main.dart';
import 'package:digi_witch/reminders.dart';
import 'package:digi_witch/monetization/monetization.dart'
    show supportedForTest;
import 'package:digi_witch/ui/astro_screens.dart';
import 'package:digi_witch/ui/journal_screen.dart';
import 'package:digi_witch/engine/tarot.dart' show deckIds;
import 'package:digi_witch/ui/today_screen.dart';
import 'package:digi_witch/ui/widgets.dart' show NumberBadge;
import 'package:digi_witch/ui/tarot_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    show AndroidFlutterLocalNotificationsPlugin;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show MethodChannel, PlatformException;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Notification plugin answering on the channel; [hold] can stall each scheduled reminder.
List<String> mockReminders(WidgetTester t, [Future<void>? Function()? hold]) {
  supportedForTest = true;
  AndroidFlutterLocalNotificationsPlugin.registerWith();
  final calls = <String>[];
  final m = t.binding.defaultBinaryMessenger;
  const tzc = MethodChannel('flutter_timezone');
  const nc = MethodChannel('dexterous.com/flutter/local_notifications');
  m.setMockMethodCallHandler(
    tzc,
    (c) async => {'identifier': 'Europe/Warsaw'},
  );
  m.setMockMethodCallHandler(nc, (c) async {
    calls.add(c.method);
    if (c.method == 'zonedSchedule') await hold?.call();
    return c.method == 'initialize' ? true : null;
  });
  addTearDown(() {
    supportedForTest = null;
    m.setMockMethodCallHandler(tzc, null);
    m.setMockMethodCallHandler(nc, null);
  });
  return calls;
}

void main() {
  late Content content;
  tearDown(() {
    // sync only: awaiting futures from the test's FakeAsync zone here would hang the file
    resetHomeWidgetSyncForTest();
    Reminders.resetForTest();
  });
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    content = await Content.load();
  });

  /// Scrolls the visible tab's list until [f] is built, then centres it so the
  /// floating nav bar never covers it.
  Future<void> scrollTo(WidgetTester t, Finder f) async {
    await t.scrollUntilVisible(
      f,
      150,
      scrollable: find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await Scrollable.ensureVisible(t.element(f), alignment: 0.5);
    await t.pumpAndSettle();
  }

  Future<AppStore> pump(WidgetTester t, {bool onboarded = true}) async {
    SharedPreferences.setMockInitialValues({'onboarded': onboarded});
    final store = AppStore(await SharedPreferences.getInstance());
    t.view.physicalSize = const Size(1080, 2400);
    t.view.devicePixelRatio = 2.75;
    addTearDown(t.view.reset);
    await t.pumpWidget(DigiWitchApp(store: store, contents: {'pl': content}));
    await t.pumpAndSettle();
    return store;
  }

  testWidgets(
    'onboarding without registration leads to Today with a card of the day',
    (t) async {
      final store = await pump(t, onboarded: false);
      expect(find.textContaining('Nie potrzebujesz konta'), findsOneWidget);
      // The birth date is optional, but a wrong one does not pass silently.
      await t.enterText(find.byType(TextField), '31022000');
      await scrollTo(t, find.text('Zaczynamy'));
      await t.tap(find.text('Zaczynamy'));
      await t.pumpAndSettle();
      expect(store.onboarded, isFalse);
      await t.enterText(find.byType(TextField), '15071990');
      await t.tap(find.text('Zaczynamy'));
      await t.pumpAndSettle();
      expect(store.birthDate, CalendarDate.tryCreate(1990, 7, 15));
      // The ritual is in plain sight, no tab to find first.
      expect(find.text('Karta dnia'), findsOneWidget);
      expect(find.text('Odsłoń kartę'), findsOneWidget);
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
      await scrollTo(t, find.text('Tylko oblicz (bez zapisywania)'));
      await t.tap(find.text('Tylko oblicz (bez zapisywania)'));
      await t.pumpAndSettle();
      // The only onstage ListView is the numerology tab (other tabs are Offstage).
      final numScroll = find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first;
      await scrollTo(t, find.text('Droga życia'));
      await t.tap(find.text('Droga życia'));
      await t.pumpAndSettle();
      final steps = find.text(
        'Cyfry daty: 2 + 9 + 0 + 5 + 1 + 9 + 7 + 5 = 38.',
      );
      await t.scrollUntilVisible(steps, 100, scrollable: numScroll);
      expect(steps, findsOneWidget);
      expect(find.text('INTERPRETACJA SYMBOLICZNA'), findsWidgets);
      expect(
        find.text('Liczba ekspresji'),
        findsNothing,
      ); // no name -> no name indicators
      // 29 + 5 + 1975 = 2009 → 11 (Sprawiedliwość), paired with 2 (Kapłanka)
      await t.scrollUntilVisible(
        find.text('Karta towarzysząca'),
        200,
        scrollable: numScroll,
      );
      expect(find.text('Sprawiedliwość'), findsOneWidget);
      expect(find.text('Kapłanka'), findsOneWidget);
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
    await scrollTo(t, find.text('Tylko oblicz (bez zapisywania)'));
    await t.tap(find.text('Tylko oblicz (bez zapisywania)'));
    await t.pumpAndSettle();
    expect(find.textContaining('Taka data nie istnieje'), findsOneWidget);
    await t.enterText(find.widgetWithText(TextField, 'Data urodzenia'), '');
    await t.enterText(
      find.widgetWithText(TextField, 'Imię i nazwisko (opcjonalnie)'),
      'Иван',
    );
    await scrollTo(t, find.text('Tylko oblicz (bez zapisywania)'));
    await t.tap(find.text('Tylko oblicz (bez zapisywania)'));
    await t.pumpAndSettle();
    expect(find.textContaining('Nieobsługiwane znaki: И'), findsOneWidget);
  });

  testWidgets(
    'tarot three-card spread and saving a reflection to the journal',
    (t) async {
      final store = await pump(t);
      await t.tap(find.text('Tarot').last);
      await t.pumpAndSettle();
      expect(find.text('Co dziś podpowiedzą karty?'), findsOneWidget);
      await scrollTo(t, find.byType(TextField));
      await t.enterText(find.byType(TextField), '  Czy zmienić pracę? ');
      await scrollTo(t, find.text('Wylosuj karty'));
      await t.tap(find.text('Wylosuj karty'));
      await t.pumpAndSettle();
      await scrollTo(t, find.text('Sytuacja'));
      expect(find.text('Sytuacja'), findsOneWidget);
      expect(find.text('Co karty mówią o Twoim pytaniu'), findsOneWidget);
      expect(find.text('„Czy zmienić pracę?”'), findsOneWidget);
      expect(
        find.textContaining('w pozycji „Następny krok”: '),
        findsOneWidget,
      );
      await scrollTo(t, find.text('Następny krok'));
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
      expect(
        store.journal.single.ref!['label'],
        startsWith('„Czy zmienić pracę?” — Trzy karty: '),
      );
    },
  );

  testWidgets('library search finds a card and opens its detail', (t) async {
    await pump(t);
    await t.tap(find.byTooltip('Biblioteka'));
    await t.pumpAndSettle();
    await t.enterText(find.byType(TextField), 'wieża');
    await t.pumpAndSettle();
    await t.tap(find.text('Wieża'));
    await t.pumpAndSettle();
    await t.scrollUntilVisible(
      find.text('INTERPRETACJA PROSTA'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
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
        child: DigiWitchApp(store: store, contents: {'pl': content}),
      ),
    );
    await t.pumpAndSettle();
    expect(t.takeException(), isNull, reason: 'Dziś');
    for (final tab in ['Gwiazdy', 'Tarot', 'Liczby', 'Sny']) {
      await t.tap(find.text(tab).last);
      await t.pumpAndSettle();
      expect(t.takeException(), isNull, reason: tab);
    }
    expect(t.takeException(), isNull);
  });

  testWidgets('Pro spreads are locked for free users and open for Pro', (
    t,
  ) async {
    final store = await pump(t);
    await t.tap(find.text('Tarot').last);
    await t.pumpAndSettle();
    await t.ensureVisible(find.text('Krzyż refleksji'));
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
    await scrollTo(t, find.text('Wylosuj karty'));
    await t.tap(find.text('Wylosuj karty'));
    await t.pumpAndSettle();
    await scrollTo(t, find.text('Możliwy kierunek'));
    expect(find.text('Możliwy kierunek'), findsOneWidget);
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
      await t.pumpWidget(DigiWitchApp(store: store, contents: {'pl': content}));
      await t.pumpAndSettle();
      await t.tap(find.text('Liczby'));
      await t.pumpAndSettle();
      // A saved profile shows the numbers; editing opens the form.
      expect(find.text('TWOJE LICZBY'), findsOneWidget);
      await t.tap(find.text('Zmień dane lub policz dla kogoś innego'));
      await t.pumpAndSettle();
      await t.enterText(
        find.widgetWithText(TextField, 'Data urodzenia'),
        '1507199',
      );
      await scrollTo(t, find.text('Zapamiętaj jako mój profil'));
      await t.tap(find.text('Zapamiętaj jako mój profil'));
      await t.pumpAndSettle();
      expect(find.textContaining('Taka data nie istnieje'), findsOneWidget);
      expect(store.birthDate?.iso, '1990-07-15');
      await t.enterText(
        find.widgetWithText(TextField, 'Data urodzenia'),
        '01012099',
      );
      await scrollTo(t, find.text('Zapamiętaj jako mój profil'));
      await t.tap(find.text('Zapamiętaj jako mój profil'));
      await t.pumpAndSettle();
      expect(find.textContaining('z przyszłości'), findsOneWidget);
      expect(store.birthDate?.iso, '1990-07-15');
    },
  );

  testWidgets('Today: horoscope with a saved birth date, moon calendar opens', (
    t,
  ) async {
    final store = await pump(t);
    // The horoscope follows the daily ritual.
    await scrollTo(t, find.textContaining('Podaj datę urodzenia'));
    store.saveProfile(CalendarDate.tryCreate(1990, 4, 1), null);
    await t.pumpAndSettle();
    await scrollTo(t, find.text('DZIŚ DLA CIEBIE'));
    expect(find.text('DZIŚ DLA CIEBIE'), findsOneWidget);
    // The Moon and the day's colour sit under the text, not in a strip on top.
    expect(find.textContaining('Kolor dnia: '), findsOneWidget);
    expect(find.text('Baran'), findsOneWidget);
    await scrollTo(t, find.text('Cały horoskop'));
    await t.tap(find.text('Cały horoskop'));
    await t.pumpAndSettle();
    // Stars opens with what may happen and the three areas; the numbers follow.
    expect(find.text('CO MOŻE CIĘ DZIŚ SPOTKAĆ'), findsOneWidget);
    expect(
      t.getTopLeft(find.text('CO MOŻE CIĘ DZIŚ SPOTKAĆ')).dy,
      lessThan(t.getTopLeft(find.text('Miłość')).dy),
    );
    await scrollTo(t, find.text('SZCZĘŚLIWE LICZBY DNIA'));
    // A lucky number opens its meaning right below, not in a snackbar; the X closes it.
    final badge = find
        .byWidgetPredicate((w) => w is NumberBadge && w.size == 72)
        .last;
    await Scrollable.ensureVisible(t.element(badge), alignment: 0.5);
    await t.pumpAndSettle();
    await t.tap(badge);
    await t.pumpAndSettle();
    expect(find.byType(SnackBar), findsNothing);
    expect(find.textContaining(' → '), findsOneWidget);
    // The panel may open under the floating bar: bring its X into view first.
    await Scrollable.ensureVisible(
      t.element(find.byTooltip('Ukryj')),
      alignment: 0.5,
    );
    await t.pumpAndSettle();
    await t.tap(find.byTooltip('Ukryj'));
    await t.pumpAndSettle();
    expect(find.textContaining(' → '), findsNothing);
    expect(
      find.text('SZCZĘŚLIWE LICZBY DNIA'),
      findsOneWidget,
    ); // still on Stars
    await t.scrollUntilVisible(
      find.text('Księżyc dziś'),
      200,
      scrollable: find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    // The tile may sit under the bottom bar on the test screen; trigger it directly.
    t
        .widget<ListTile>(
          find.ancestor(
            of: find.text('Księżyc dziś'),
            matching: find.byType(ListTile),
          ),
        )
        .onTap!();
    await t.pumpAndSettle();
    expect(find.text('Kalendarz Księżyca'), findsOneWidget);
    await scrollTo(t, find.text('Najbliższe fazy'));
    expect(find.text('Pełnia'), findsWidgets);
    await scrollTo(t, find.text('Dzień po dniu (30 dni)'));
  });

  testWidgets('compatibility of two dates', (t) async {
    await pump(t);
    await t.tap(find.text('Liczby'));
    await t.pumpAndSettle();
    await scrollTo(t, find.text('Zgodność dwóch osób'));
    await t.tap(find.text('Zgodność dwóch osób'));
    await t.pumpAndSettle();
    await t.enterText(find.byType(TextField).at(0), '15071990');
    await t.enterText(find.byType(TextField).at(1), '01012000');
    await t.tap(find.text('Sprawdź'));
    await t.pumpAndSettle();
    expect(find.textContaining('Osoba 1: Rak (Woda)'), findsOneWidget);
    expect(find.textContaining('Osoba 2: Koziorożec (Ziemia)'), findsOneWidget);
    expect(find.textContaining('Żywioły, które się wspierają'), findsOneWidget);
    expect(
      find.textContaining('Koń + Królik'),
      findsOneWidget,
    ); // 01.01.2000 is before Chinese New Year 2000, so Rabbit
    await scrollTo(t, find.text('Liczba relacji'));
    expect(find.text('Liczba relacji'), findsOneWidget);
  });

  testWidgets('Android (test default) uses the solid nav bar', (t) async {
    await pump(t);
    expect(find.byType(BackdropFilter), findsNothing);
  });

  testWidgets('iOS uses the glass nav bar', (t) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await pump(t);
    expect(find.byType(BackdropFilter), findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('tapping the deck draws and reveals the spread', (t) async {
    await pump(t);
    await t.tap(find.text('Tarot').last);
    await t.pumpAndSettle();
    await scrollTo(t, find.text('Jedna karta'));
    await t.tap(find.text('Jedna karta'));
    await t.pumpAndSettle();
    await scrollTo(t, find.byType(DeckStack));
    await t.tap(find.byType(DeckStack));
    await t.pumpAndSettle();
    expect(find.byType(RevealedSpread), findsOneWidget);
    await scrollTo(t, find.text('Wylosuj ponownie'));
    expect(find.text('Wylosuj ponownie'), findsOneWidget);
  });

  testWidgets('big three: Moon from date, ascendant after time and place', (
    t,
  ) async {
    final store = await pump(t);
    store.saveProfile(CalendarDate.tryCreate(1990, 7, 15), null);
    await t.pumpAndSettle();
    await t.tap(find.text('Gwiazdy').last);
    await t.pumpAndSettle();
    await scrollTo(t, find.text('Twoja wielka trójka'));
    await t.tap(find.text('Twoja wielka trójka'));
    await t.pumpAndSettle();
    expect(find.text('Rak'), findsWidgets); // Sun sign
    expect(find.text('ASCENDENT'), findsOneWidget);
    expect(find.textContaining('Podaj godzinę i miejsce'), findsOneWidget);
    store.saveBirthDetails(14 * 60 + 30, 'Kraków');
    await t.pumpAndSettle();
    expect(find.textContaining('Podaj godzinę i miejsce'), findsNothing);
    expect(find.text('14:30'), findsOneWidget);
    // Deleting the profile also forgets time and place.
    store.saveProfile(null, null);
    await t.pumpAndSettle();
    expect(store.birthMinutes, isNull);
    expect(store.birthPlace, isNull);
  });

  testWidgets('Chinese horoscope shows element and relations', (t) async {
    final store = await pump(t);
    store.saveProfile(CalendarDate.tryCreate(1990, 7, 15), null);
    await t.pumpAndSettle();
    await t.tap(find.text('Gwiazdy').last);
    await t.pumpAndSettle();
    await scrollTo(t, find.text('Horoskop chiński'));
    await t.tap(find.text('Horoskop chiński'));
    await t.pumpAndSettle();
    expect(find.textContaining('1990 · Metal · yang'), findsOneWidget);
    await scrollTo(t, find.textContaining('Tajemny przyjaciel'));
    expect(find.textContaining('Tajemny przyjaciel: Koza'), findsOneWidget);
    expect(find.textContaining('Znak przeciwny: Szczur'), findsOneWidget);
  });

  testWidgets('dream dictionary opens and filters', (t) async {
    await pump(t);
    await t.tap(find.byTooltip('Biblioteka'));
    await t.pumpAndSettle();
    await t.tap(find.text('Sennik'));
    await t.pumpAndSettle();
    await t.enterText(find.byType(TextField), 'zęb');
    await t.pumpAndSettle();
    expect(find.text('Wypadanie zębów'), findsOneWidget);
    await t.tap(find.text('Wypadanie zębów'));
    await t.pumpAndSettle();
    expect(find.text('Czego boisz się stracić?'), findsOneWidget);
  });

  testWidgets('big three abroad: list city and a hand-typed place', (t) async {
    final store = await pump(t);
    store.saveProfile(CalendarDate.tryCreate(1985, 3, 10), null);
    store.saveBirthDetails(8 * 60, 'Nowy Jork (USA)');
    await t.pumpAndSettle();
    await t.tap(find.text('Gwiazdy').last);
    await t.pumpAndSettle();
    await scrollTo(t, find.text('Twoja wielka trójka'));
    await t.tap(find.text('Twoja wielka trójka'));
    await t.pumpAndSettle();
    expect(find.textContaining('Podaj godzinę i miejsce'), findsNothing);
    await scrollTo(t, find.text('Z czego to wynika'));
    await t.tap(find.text('Z czego to wynika'));
    await t.pumpAndSettle();
    // 08:00 EST = 13:00 UTC
    expect(
      find.textContaining('08:00 → 13:00 UTC (strefa America/New_York'),
      findsOneWidget,
    );

    store.saveBirthDetails(8 * 60, customPlace(-12.05, -77.04, 'America/Lima'));
    await t.pumpAndSettle();
    expect(find.textContaining('strefa America/Lima'), findsOneWidget);
    expect(
      find.textContaining('Inne miejsce: -12.05°, -77.04°'),
      findsOneWidget,
    );
  });

  testWidgets('other-place dialog validates and saves', (t) async {
    final store = await pump(t);
    store.saveProfile(CalendarDate.tryCreate(1985, 3, 10), null);
    await t.pumpAndSettle();
    await t.tap(find.text('Gwiazdy').last);
    await t.pumpAndSettle();
    await scrollTo(t, find.text('Twoja wielka trójka'));
    await t.tap(find.text('Twoja wielka trójka'));
    await t.pumpAndSettle();
    await t.tap(find.text('Inne miejsce — podaj współrzędne'));
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
    await t.tap(find.text('Zapisz'));
    await t.pumpAndSettle();
    expect(find.textContaining('Uzupełnij szerokość'), findsOneWidget);
    await t.enterText(
      find.widgetWithText(TextField, 'Szerokość geograficzna'),
      '-12,05',
    );
    await t.enterText(
      find.widgetWithText(TextField, 'Długość geograficzna'),
      '-77,04',
    );
    await t.enterText(
      find.widgetWithText(TextField, 'Strefa czasowa'),
      'America/Lima',
    );
    await t.pumpAndSettle();
    await t.tap(find.text('America/Lima').last);
    await t.pumpAndSettle();
    await t.tap(find.text('Zapisz'));
    await t.pumpAndSettle();
    expect(store.birthPlace, customPlace(-12.05, -77.04, 'America/Lima'));
  });

  testWidgets(
    'Today: date entered on Today unlocks the horoscope; tiles open',
    (t) async {
      final store = await pump(t);
      await scrollTo(t, find.text('Pokaż mój horoskop'));
      await t.enterText(
        find.widgetWithText(TextField, 'Data urodzenia'),
        '15071990',
      );
      await t.tap(find.text('Pokaż mój horoskop'));
      await t.pumpAndSettle();
      expect(store.birthDate?.iso, '1990-07-15');
      expect(find.text('Rak'), findsOneWidget);
      await scrollTo(t, find.text('Polecane dziś'));
      await t.tap(find.text('Sny').last);
      await t.pumpAndSettle();
      expect(find.text('Co Ci się dziś śniło?'), findsOneWidget);
      await scrollTo(t, find.text('Symbol dnia'));
      expect(find.textContaining('Szukaj symbolu'), findsOneWidget);
      await t.tap(find.text('Tarot').last);
      await t.pumpAndSettle();
      expect(find.text('Wybierz rozkład'), findsOneWidget);
      // The journal lives in the top bar now.
      await t.tap(find.byTooltip('Dziennik').last);
      await t.pumpAndSettle();
      expect(find.text('Napisz pierwszą myśl'), findsOneWidget);
    },
  );

  testWidgets('Pythagoras square and life cycles show for the profile', (
    t,
  ) async {
    SharedPreferences.setMockInitialValues({
      'onboarded': true,
      'birthDate': '1990-07-15',
    });
    final store = AppStore(await SharedPreferences.getInstance());
    t.view.physicalSize = const Size(1080, 2400);
    t.view.devicePixelRatio = 2.75;
    addTearDown(t.view.reset);
    await t.pumpWidget(DigiWitchApp(store: store, contents: {'pl': content}));
    await t.pumpAndSettle();
    await t.tap(find.text('Liczby'));
    await t.pumpAndSettle();
    await scrollTo(t, find.text('Kwadrat Pitagorasa'));
    expect(find.text('333'), findsOneWidget); // three 3s for 15.07.1990
    await scrollTo(t, find.text('Cykle życia: szczyty i wyzwania'));
    await scrollTo(t, find.text('Szczyt budowania')); // first pinnacle 4
    expect(find.text('0–31 lat'), findsOneWidget);
  });

  testWidgets('I Ching: six tosses give a hexagram and a reading', (t) async {
    await pump(t);
    await t.tap(find.text('Gwiazdy').last);
    await t.pumpAndSettle();
    await scrollTo(t, find.text('Wyrocznia I Ching'));
    await t.tap(find.text('Wyrocznia I Ching'));
    await t.pumpAndSettle();
    for (var i = 1; i <= 6; i++) {
      await scrollTo(t, find.text('Rzuć monetami ($i/6)'));
      await t.tap(find.text('Rzuć monetami ($i/6)'));
      await t.pumpAndSettle();
    }
    expect(find.textContaining('Rzuć monetami'), findsNothing);
    // The reading's length depends on the tosses: check the heading before scrolling past it.
    await scrollTo(t, find.text('ZNACZENIE'));
    expect(find.text('ZNACZENIE'), findsOneWidget);
    await scrollTo(t, find.text('Nowe pytanie'));
  });

  testWidgets('Moon rituals screen lists new and full moon with prompts', (
    t,
  ) async {
    await pump(t);
    await t.tap(find.text('Gwiazdy').last);
    await t.pumpAndSettle();
    await scrollTo(t, find.text('Rytuały Księżyca'));
    await t.tap(find.text('Rytuały Księżyca'));
    await t.pumpAndSettle();
    expect(find.text('Rytuał nowiu'), findsOneWidget);
    await scrollTo(t, find.text('Rytuał pełni'));
    expect(find.text('Rytuał pełni'), findsOneWidget);
  });

  testWidgets('week and month horoscope show general text and key days', (
    t,
  ) async {
    final store = await pump(t);
    store.saveProfile(CalendarDate.tryCreate(1990, 7, 15), null);
    await t.pumpAndSettle();
    await t.tap(find.text('Gwiazdy').last);
    await t.pumpAndSettle();
    await scrollTo(t, find.text('Horoskop na tydzień i miesiąc'));
    await t.tap(find.text('Horoskop na tydzień i miesiąc'));
    await t.pumpAndSettle();
    expect(find.text('OGÓLNIE'), findsOneWidget);
    expect(find.text('WAŻNE DNI'), findsOneWidget);
    await t.tap(find.text('Miesiąc'));
    await t.pumpAndSettle();
    expect(find.text('Miesiąc osobisty'), findsOneWidget);
  });

  testWidgets('Today leads to the Tarot tab; its intro can be turned off', (
    t,
  ) async {
    final store = await pump(t);
    await scrollTo(t, find.text('Postaw tarota'));
    await t.tap(find.text('Postaw tarota'));
    await t.pumpAndSettle();
    expect(find.text('Co dziś podpowiedzą karty?'), findsOneWidget);
    expect(find.text('Zobacz talię kart'), findsOneWidget);
    await t.tap(find.byTooltip('Ukryj'));
    await t.pumpAndSettle();
    expect(find.text('Co dziś podpowiedzą karty?'), findsNothing);
    expect(store.tarotWelcome, isFalse);
    // The deck stays reachable at the bottom of the tab.
    await scrollTo(t, find.text('Talia kart'));
    expect(find.text('Talia kart'), findsOneWidget);
    store.tarotWelcome = true; // the switch in Settings
    await t.pumpAndSettle();
    await t.drag(find.byType(ListView).first, const Offset(0, 3000));
    await t.pumpAndSettle();
    expect(find.text('Co dziś podpowiedzą karty?'), findsOneWidget);
  });

  testWidgets(
    'Delete all data keeps Pro, cancels reminders, clears widget store',
    (t) async {
      supportedForTest = true;
      AndroidFlutterLocalNotificationsPlugin.registerWith();
      addTearDown(() => supportedForTest = null);
      final widgetStore = <String, Object?>{};
      var refreshes = 0;
      var cancelAll = 0;
      final messenger = t.binding.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(const MethodChannel('home_widget'), (
        c,
      ) async {
        final a = c.arguments as Map?;
        if (c.method == 'saveWidgetData') {
          a!['data'] == null
              ? widgetStore.remove(a['id'])
              : widgetStore[a['id'] as String] = a['data'];
        } else if (c.method == 'updateWidget') {
          refreshes++;
        }
        return true;
      });
      messenger.setMockMethodCallHandler(
        const MethodChannel('flutter_timezone'),
        (c) async => {'identifier': 'Europe/Warsaw'},
      );
      messenger.setMockMethodCallHandler(
        const MethodChannel('dexterous.com/flutter/local_notifications'),
        (c) async {
          if (c.method == 'cancelAll') cancelAll++;
          return c.method == 'initialize' ? true : null;
        },
      );
      addTearDown(() {
        messenger.setMockMethodCallHandler(
          const MethodChannel('home_widget'),
          null,
        );
        messenger.setMockMethodCallHandler(
          const MethodChannel('dexterous.com/flutter/local_notifications'),
          null,
        );
      });

      final store = await pump(t);
      store.isPro = true;
      store.moonReminders = true;
      store.reminderAsked =
          true; // hides the reminder prompt, which overflows in the test font
      store.saveProfile(CalendarDate.tryCreate(1990, 1, 1), 'Ala');
      store.revealCard(CalendarDate.fromDateTime(DateTime.now()));
      await t.pumpAndSettle();
      expect(
        widgetStore['cardImage'],
        isNotNull,
      ); // a sync really filled the store
      expect(
        widgetStore.keys.toSet(),
        widgetKeys.toSet(),
      ); // the clear list is complete

      await t.tap(find.byTooltip('Ustawienia'));
      await t.pumpAndSettle();
      await scrollTo(t, find.text('Usuń wszystkie dane'));
      await t.tap(find.text('Usuń wszystkie dane'));
      await t.pumpAndSettle();
      await t.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Usuń'),
        ),
      );
      await t.pumpAndSettle();

      expect(store.isPro, isTrue);
      expect(store.moonReminders, isFalse);
      expect(store.birthDate, isNull);
      expect(cancelAll, 1);
      expect(
        widgetStore,
        isEmpty,
      ); // not even a sync running during the reset brought data back
      expect(refreshes, greaterThan(0));
      expect(store.widgetClearPending, isFalse);
      // Settings is gone (the reset leads to onboarding), yet the clear finished.
      expect(find.text('Usuń wszystkie dane'), findsNothing);
      expect(find.textContaining('Nie potrzebujesz konta'), findsOneWidget);
    },
  );

  testWidgets(
    'Delete all data: cancelAll failure shows the message, stays in Settings, keeps Pro, retry finishes',
    (t) async {
      final calls = mockReminders(t);
      var failCancel = true;
      final m = t.binding.defaultBinaryMessenger;
      const nc = MethodChannel('dexterous.com/flutter/local_notifications');
      m.setMockMethodCallHandler(nc, (c) async {
        calls.add(c.method);
        if (c.method == 'cancelAll' && failCancel) {
          throw PlatformException(code: 'boom');
        }
        return c.method == 'initialize' ? true : null;
      });
      m.setMockMethodCallHandler(
        const MethodChannel('home_widget'),
        (c) async => true,
      );
      addTearDown(
        () => m.setMockMethodCallHandler(
          const MethodChannel('home_widget'),
          null,
        ),
      );

      final store = await pump(t);
      store.isPro = true;
      store.moonReminders = true;
      store.reminderAsked = true;
      store.saveProfile(CalendarDate.tryCreate(1990, 1, 1), 'Ala');
      await t.pumpAndSettle();

      Future<void> deleteAll() async {
        await scrollTo(t, find.text('Usuń wszystkie dane'));
        await t.tap(find.text('Usuń wszystkie dane'));
        await t.pumpAndSettle();
        await t.tap(
          find.descendant(
            of: find.byType(AlertDialog),
            matching: find.text('Usuń'),
          ),
        );
        await t.pumpAndSettle();
      }

      await t.tap(find.byTooltip('Ustawienia'));
      await t.pumpAndSettle();
      await deleteAll();

      expect(find.textContaining('Nie udało się usunąć'), findsOneWidget);
      expect(find.text('Usuń wszystkie dane'), findsOneWidget); // still in Settings
      expect(store.isPro, isTrue);
      expect(store.moonReminders, isFalse); // settings match what was cancelled
      expect(store.widgetClearPending, isFalse); // widgets were emptied after the started reset
      expect(store.birthDate, isNotNull); // the wipe did not get past the failure

      failCancel = false; // retry
      await deleteAll();
      expect(store.birthDate, isNull);
      expect(store.isPro, isTrue);
      expect(calls.where((c) => c == 'cancelAll'), hasLength(2));
      expect(find.textContaining('Nie potrzebujesz konta'), findsOneWidget);
    },
  );

  testWidgets('reminders: cancel invalidates the plan; resetForTest re-initialises', (
    t,
  ) async {
    final calls = mockReminders(t);
    final now = DateTime.now();
    final plan = Reminders.reschedule([
      for (var d = 1; d <= 3; d++) (now.add(Duration(days: d)), 't', 'b'),
    ]); // remembers the generation before the cancel
    final reset = Reminders.cancelAll();
    await plan; // operations finish inside the test body
    await reset;
    expect(calls.where((c) => c == 'zonedSchedule'), isEmpty);

    final initializations = calls.where((c) => c == 'initialize').length;
    Reminders.resetForTest(); // sync: only detaches state
    await Reminders.reschedule([
      (now.add(const Duration(days: 1)), 't', 'b'),
    ]);
    // parallel calls above may both initialise; assert only the increment after the reset
    expect(
      calls.where((c) => c == 'initialize'),
      hasLength(initializations + 1),
    );
    expect(calls.where((c) => c == 'zonedSchedule'), hasLength(1));
  });

  testWidgets(
    'reminders: a reset during a stalled reschedule stops the old plan',
    (t) async {
      final gate = Completer<void>();
      final calls = mockReminders(t, () => gate.future);
      final now = DateTime.now();
      final plan = Reminders.reschedule([
        for (var d = 1; d <= 3; d++) (now.add(Duration(days: d)), 't', 'b'),
      ]);
      Future<void>? reset;
      try {
        for (var i = 0; i < 100 && !calls.contains('zonedSchedule'); i++) {
          await t.pump(const Duration(milliseconds: 10));
        }
        expect(
          calls,
          contains('zonedSchedule'),
        ); // first reminder stuck in the plugin
        reset = Reminders.cancelAll();
      } finally {
        if (!gate.isCompleted) gate.complete(); // never leave the queue stuck
        await plan; // also after a failed assertion: finish inside the test's zone
        await reset;
      }
      expect(
        calls.first,
        'initialize',
      ); // a fresh init, not one left from an earlier test
      expect(calls.where((c) => c == 'zonedSchedule'), hasLength(1));
      expect(calls.last, 'cancelAll');
    },
  );

  testWidgets('reminders: moon plan, then reset, in order', (t) async {
    final calls = mockReminders(t);
    await Reminders.rescheduleMoon([
      (DateTime.now().add(const Duration(days: 2)), 'n', 'b'),
    ]);
    await Reminders.cancelAll();
    expect(
      calls,
      containsAllInOrder(['initialize', 'zonedSchedule', 'cancelAll']),
    );
  });

  testWidgets('Widget clear waits for a stalled old write and refreshes last', (
    t,
  ) async {
    supportedForTest = true;
    addTearDown(() => supportedForTest = null);
    final widgetStore = <String, Object?>{};
    final events = <String>[];
    Completer<void>? gate;
    final messenger = t.binding.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(const MethodChannel('home_widget'), (
      c,
    ) async {
      final a = c.arguments as Map?;
      if (c.method == 'saveWidgetData') {
        if (a!['data'] != null) {
          events.add('save');
          await gate?.future; // the old write hangs inside the plugin
          widgetStore[a['id'] as String] = a['data'];
        } else {
          events.add('clear');
          widgetStore.remove(a['id']);
        }
      } else if (c.method == 'updateWidget') {
        events.add('refresh');
      }
      return true;
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(
        const MethodChannel('home_widget'),
        null,
      ),
    );

    final store = await pump(t);
    store.reminderAsked = true;
    await t.pumpAndSettle();
    events.clear();
    final blockedWrite = Completer<void>();
    gate = blockedWrite;
    Future<void>? clearing;
    try {
      store.saveProfile(
        CalendarDate.tryCreate(1990, 1, 1),
        'Ala',
      ); // starts a push
      // bounded wait for the mock to actually be entered
      for (var i = 0; i < 100 && !events.contains('save'); i++) {
        await t.pump(const Duration(milliseconds: 10));
      }
      expect(events, contains('save')); // in flight, stuck

      await store.deleteAllData();
      var done = false;
      clearing = clearHomeWidget(store).then((_) {
        done = true;
      });
      await t.pump(const Duration(milliseconds: 50));
      expect(done, isFalse); // the clear waits for the stuck write
    } finally {
      // runs also after a failed assertion, so _inFlight is never left stuck
      if (!blockedWrite.isCompleted) blockedWrite.complete();
      await t.pumpAndSettle();
      await (clearing ?? clearHomeWidget(store));
      await t.pumpAndSettle();
    }

    expect(widgetStore, isEmpty);
    expect(events.last, 'refresh'); // refreshed after the wipe
    expect(events.lastIndexOf('save'), lessThan(events.indexOf('clear')));
    expect(store.widgetClearPending, isFalse);
  });

  testWidgets(
    'Widget clear answered false stays pending and is retried at start',
    (t) async {
      supportedForTest = true;
      addTearDown(() => supportedForTest = null);
      Object? answer = false;
      final messenger = t.binding.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(
        const MethodChannel('home_widget'),
        (c) async => answer is Exception ? throw answer : answer,
      );
      addTearDown(
        () => messenger.setMockMethodCallHandler(
          const MethodChannel('home_widget'),
          null,
        ),
      );
      SharedPreferences.setMockInitialValues({});
      final store = await AppStore.open();
      await store.deleteAllData();
      await clearHomeWidget(store);
      expect(store.widgetClearPending, isTrue); // false from the plugin

      answer = Exception('no widget');
      await retryPendingHomeWidgetClear(store);
      expect(store.widgetClearPending, isTrue); // exception, still pending

      answer = true;
      await retryPendingHomeWidgetClear(store);
      expect(store.widgetClearPending, isFalse);
    },
  );

  testWidgets('a clear left pending is retried on the onboarding screen', (
    t,
  ) async {
    supportedForTest = true;
    addTearDown(() => supportedForTest = null);
    final cleared = <Object?>[];
    final messenger = t.binding.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(const MethodChannel('home_widget'), (
      c,
    ) async {
      if (c.method == 'saveWidgetData') cleared.add((c.arguments as Map)['id']);
      return true;
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(
        const MethodChannel('home_widget'),
        null,
      ),
    );
    SharedPreferences.setMockInitialValues({'widgetClearPending': true});
    final store = AppStore(await SharedPreferences.getInstance());
    await t.pumpWidget(DigiWitchApp(store: store, contents: {'pl': content}));
    await retryPendingHomeWidgetClear(store); // as main() does after runApp
    await t.pumpAndSettle();
    expect(find.textContaining('Nie potrzebujesz konta'), findsOneWidget);
    expect(cleared.toSet(), widgetKeys.toSet());
    expect(store.widgetClearPending, isFalse);
  });

  testWidgets('Today: card of the day is revealed by a tap, mood is kept', (
    t,
  ) async {
    final store = await pump(t);
    final now = DateTime.now();
    final today = CalendarDate.fromDateTime(now);
    store.setMood(
      CalendarDate.fromDateTime(DateTime(now.year, now.month, now.day - 1)),
      2,
    );
    await t.pumpAndSettle();
    await scrollTo(t, find.text('Jak się dziś czujesz?'));
    await t.tap(find.text('Odsłoń kartę'));
    await t.pumpAndSettle();
    expect(store.cardRevealed(today), isTrue);
    expect(find.text('Więcej o karcie'), findsOneWidget);
    await t.tap(find.byTooltip('Dobrze'));
    await t.pumpAndSettle();
    expect(store.moods[today.iso], 4);
    // The week strip: today's mood (also on its button) and yesterday's.
    expect(find.byIcon(Icons.sentiment_satisfied), findsNWidgets(2));
    expect(find.byIcon(Icons.sentiment_dissatisfied), findsOneWidget);
    expect(
      find.textContaining('Zapisane tylko na tym urządzeniu'),
      findsOneWidget,
    );
    expect(find.textContaining('Na dziś gotowe. Jutro'), findsOneWidget);
    expect(find.textContaining('Dobrze to słyszeć'), findsOneWidget);
    // A hard day gets a kind word and the support numbers one tap away.
    await t.tap(find.byTooltip('Ciężko'));
    await t.pumpAndSettle();
    expect(find.textContaining('Nie musisz dziś niczego'), findsOneWidget);
    await scrollTo(t, find.text('Pomoc'));
    await t.tap(find.text('Pomoc'));
    await t.pumpAndSettle();
    expect(find.textContaining('116 123'), findsOneWidget);
    await t.tap(find.byType(TextButton).last);
    await t.pumpAndSettle();
    await t.tap(find.byTooltip('Dobrze'));
    await t.pumpAndSettle();
    // "Your days": the turned card and both moods, newest first.
    expect(store.cardLog.keys, [today.iso]);
    await scrollTo(t, find.text('Twoje dni'));
    await t.tap(find.text('Twoje dni'));
    await t.pumpAndSettle();
    expect(find.textContaining('dzień po dniu'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(2));
    await t.tap(find.byType(BackButton));
    await t.pumpAndSettle();
    await t.tap(find.byTooltip('Dobrze'));
    await t.pumpAndSettle();
    expect(store.moods.containsKey(today.iso), isFalse);
    await scrollTo(t, find.text('Nadchodzi'));
    expect(find.textContaining(' za '), findsWidgets); // countdown chips
  });

  testWidgets('daily reminder texts carry the day content; countdowns sorted', (
    t,
  ) async {
    final store = await pump(t);
    store.saveProfile(CalendarDate.tryCreate(1990, 7, 15), null);
    await t.pumpAndSettle();
    final ctx = t.element(find.byType(TodayScreen));
    final days = dailyReminderEvents(ctx, 20 * 60);
    expect(days, hasLength(31));
    expect(days.first.$1.hour, 20);
    for (final (_, _, body) in days) {
      expect(body, contains('Księżyc w '));
      expect(body, contains('liczba dnia '));
    }
    expect(days.where((d) => d.$3.startsWith('Pełnia')), isNotEmpty);
    final c = countdowns(ctx, DateTime.now());
    final order = [for (final e in c) e.$2 ?? -1]; // null = already running
    expect(order, [...order]..sort());
    expect(c.any((e) => e.$1 == 'Pełnia'), isTrue);
  });

  testWidgets('Today: your numbers lead to the full numerology', (t) async {
    final store = await pump(t);
    store.saveProfile(CalendarDate.tryCreate(1990, 7, 15), null);
    await t.pumpAndSettle();
    expect(
      find.text('Dzień dobry').evaluate().length +
          find.text('Dobry wieczór').evaluate().length,
      1,
    );
    await scrollTo(t, find.text('DZIŚ DLA CIEBIE'));
    await t.fling(find.text('DZIŚ DLA CIEBIE'), const Offset(-300, 0), 1000);
    await t.pumpAndSettle(); // swipe to the next card
    expect(find.text('TWOJE LICZBY'), findsOneWidget);
    await scrollTo(t, find.text('Pełna numerologia i portret'));
    await t.tap(find.text('Pełna numerologia i portret'));
    await t.pumpAndSettle();
    await scrollTo(t, find.text('Portret numerologiczny'));
    expect(find.text('Portret numerologiczny'), findsOneWidget);
  });

  testWidgets('a tab you switch to always starts at the top', (t) async {
    await pump(t);
    await t.tap(find.text('Liczby').last);
    await t.pumpAndSettle();
    await scrollTo(t, find.text('Tylko oblicz (bez zapisywania)'));
    expect(find.text('Zacznij od daty urodzenia').hitTestable(), findsNothing);
    await t.tap(find.text('Dziś').last);
    await t.pumpAndSettle();
    await t.tap(find.text('Liczby').last);
    await t.pumpAndSettle();
    expect(
      find.text('Zacznij od daty urodzenia').hitTestable(),
      findsOneWidget,
    );
  });

  testWidgets('wide window (unfolded): side rail, two columns, state kept', (
    t,
  ) async {
    final store = await pump(t);
    store.saveProfile(CalendarDate.tryCreate(1990, 7, 15), null);
    await t.pumpAndSettle();
    // Type a tarot question while folded.
    await t.tap(find.text('Tarot').last);
    await t.pumpAndSettle();
    await scrollTo(t, find.byType(TextField));
    await t.enterText(find.byType(TextField), 'Czy to dobry czas?');
    await t.tap(find.text('Dziś').last);
    await t.pumpAndSettle();
    await scrollTo(t, find.text('Moje liczby'));
    await t.tap(find.text('Moje liczby'));
    await t.pumpAndSettle();

    // Unfold: 900 x 640 logical.
    t.view.physicalSize = const Size(900 * 2.75, 640 * 2.75);
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
    final rail = t.getTopLeft(find.text('Gwiazdy').last);
    expect(rail.dx, greaterThan(900 - 106)); // nav is a rail on the right
    // An inset on the right (a notch in landscape): the rail sits beside it.
    t.view.padding = const FakeViewPadding(right: 140 * 2.75);
    t.view.viewPadding = const FakeViewPadding(right: 140 * 2.75);
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
    expect(
      t.getTopLeft(find.text('Gwiazdy').last).dx,
      inExclusiveRange(900 - 140 - 84, 900 - 140),
    );
    expect(
      t.getTopRight(find.text('TWOJE LICZBY')).dx,
      lessThan(900 - 140 - 84),
    );
    // A pushed screen keeps the rail and gets a back button above it.
    expect(find.byKey(const Key('railBack')), findsNothing);
    await t.tap(find.byTooltip('Ustawienia'));
    await t.pumpAndSettle();
    expect(find.text('Gwiazdy'), findsOneWidget);
    await t.tap(find.byKey(const Key('railBack')));
    await t.pumpAndSettle();
    expect(find.text('TWOJE LICZBY'), findsOneWidget);
    expect(find.byKey(const Key('railBack')), findsNothing);
    // A tab picked from a pushed screen closes it.
    await t.tap(find.byTooltip('Ustawienia'));
    await t.pumpAndSettle();
    await t.tap(find.text('Sny'));
    await t.pumpAndSettle();
    expect(find.byKey(const Key('railBack')), findsNothing);
    await t.tap(find.text('Dziś').last);
    await t.pumpAndSettle();
    t.view.resetPadding();
    t.view.resetViewPadding();
    await t.pumpAndSettle();
    t.view.resetPadding();
    t.view.resetViewPadding();
    t.view.physicalSize = const Size(900 * 2.75, 640 * 2.75);
    await t.pumpAndSettle();
    // Two columns: the ritual on the left, the horoscope / numbers pager and
    // "Nadchodzi" on the right.
    expect(find.text('TWOJE LICZBY'), findsOneWidget); // pager page kept
    final left = t.getTopLeft(find.text('Karta dnia')).dx;
    expect(t.getTopLeft(find.text('TWOJE LICZBY')).dx, greaterThan(left));
    expect(t.getTopLeft(find.text('Nadchodzi')).dx, greaterThan(left));
    for (final tab in ['Gwiazdy', 'Liczby', 'Sny', 'Tarot']) {
      await t.tap(find.text(tab).last);
      await t.pumpAndSettle();
      expect(t.takeException(), isNull, reason: tab);
    }
    // The question survived; the tab opens at the top, so scroll down to it.
    await scrollTo(t, find.text('Czy to dobry czas?'));
    expect(find.text('Czy to dobry czas?'), findsOneWidget);

    // Phone in landscape: short window, the rail must not overflow.
    t.view.physicalSize = const Size(800 * 2.75, 360 * 2.75);
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
  });

  testWidgets(
    'home-screen widget texts: a week of days, card only once turned',
    (t) async {
      final store = await pump(t);
      final now = DateTime.now();
      final today = CalendarDate.fromDateTime(now);
      var ctx = t.element(find.byType(TodayScreen));
      // Without a birth date: Moon only, no personal lines.
      var days = jsonDecode(widgetPayload(ctx, now)['days']!) as List;
      expect(days.first['text'], '');
      expect(days.first['moonIn'], contains('Księżyc w '));
      expect(days.first['love'], 0); // no birth date: no meters
      expect(days.first['cheer'], '');
      expect(days.first['moonCheer'], isNotEmpty); // no birth date needed
      // Without a birth date the kind message leads and the Moon stands under it.
      expect(days.first['lead'], days.first['message']);
      expect(days.first['support'], days.first['moonCheer']);

      store.saveProfile(CalendarDate.tryCreate(1990, 7, 15), null);
      await t.pumpAndSettle();
      ctx = t.element(find.byType(TodayScreen));
      var w = widgetPayload(ctx, now);
      days = jsonDecode(w['days']!) as List;
      expect(days, hasLength(8));
      expect(days.first['date'], today.iso);
      expect(days.first['sign'], 'Rak');
      // Today greets with the same two lines the large widgets show.
      expect(find.text(days.first['lead'] as String), findsOneWidget);
      expect(find.text(days.first['support'] as String), findsOneWidget);
      // The widget says exactly what the horoscope card says.
      await scrollTo(t, find.text(days.first['text'] as String));
      expect(find.text(days.first['text'] as String), findsOneWidget);
      // The widget's second line is the reading's advice, the same one the card shows.
      expect(find.text(days.first['caution'] as String), findsOneWidget);
      expect(days.first['number'], matches(RegExp(r'^\d+ · .+')));
      expect(days.first['phase'], inInclusiveRange(0, 7));
      // The same meters as on the horoscope card, every day of the week.
      for (final d in days) {
        for (final k in ['love', 'work', 'energy']) {
          expect(d[k], inInclusiveRange(1, 5));
        }
      }
      expect(days.first['lead'], isNot(days.first['support']));
      expect(w['loveLabel'], 'Miłość');
      expect(w['workLabel'], 'Praca');
      expect(w['energyLabel'], 'Energia');
      expect(w['cardName'], '');
      store.cardOfDay(today);
      store.revealCard(today);
      await t.pumpAndSettle();
      w = widgetPayload(ctx, now);
      expect(w['cardName'], isNotEmpty);
      expect(w['cardAdvice'], startsWith('Karta mówi: '));
      expect(deckIds, contains(w['cardId']));

      // The card and the mood need no tab: they are on Today itself.
      expect(find.text('Jak się dziś czujesz?'), findsOneWidget);
    },
  );
}
