import 'package:digi_witch/data/content.dart';
import 'package:digi_witch/data/places.dart';
import 'package:digi_witch/data/store.dart';
import 'package:digi_witch/engine/numerology.dart';
import 'package:digi_witch/main.dart';
import 'package:digi_witch/ui/journal_screen.dart';
import 'package:digi_witch/ui/tarot_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late Content content;
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
      await scrollTo(t, find.text('Karta dnia'));
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
      await t.scrollUntilVisible(
        find.text('Droga życia'),
        100,
        scrollable: numScroll,
      );
      // Results start under the bottom bar on the test screen: scroll them up first.
      await t.drag(numScroll, const Offset(0, -300));
      await t.pumpAndSettle();
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
      'Jürgen',
    );
    await scrollTo(t, find.text('Tylko oblicz (bez zapisywania)'));
    await t.tap(find.text('Tylko oblicz (bez zapisywania)'));
    await t.pumpAndSettle();
    expect(find.textContaining('Nieobsługiwane znaki: ü'), findsOneWidget);
  });

  testWidgets(
    'tarot three-card spread and saving a reflection to the journal',
    (t) async {
      final store = await pump(t);
      await t.tap(find.text('Tarot').last);
      await t.pumpAndSettle();
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
    expect(t.takeException(), isNull, reason: 'Dziś');
    for (final tab in ['Liczby', 'Tarot', 'Biblioteka', 'Dziennik']) {
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
      await t.pumpWidget(DigiWitchApp(store: store, content: content));
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
    expect(find.textContaining('Podaj datę urodzenia'), findsOneWidget);
    store.saveProfile(CalendarDate.tryCreate(1990, 4, 1), null);
    await t.pumpAndSettle();
    expect(find.text('DZIŚ DLA CIEBIE'), findsOneWidget);
    expect(find.text('Baran'), findsOneWidget);
    expect(find.text('SZCZĘŚLIWE LICZBY DNIA'), findsOneWidget);
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
    await t.tap(find.text('Jedna karta'));
    await t.pumpAndSettle();
    await t.tap(find.byType(DeckStack));
    await t.pumpAndSettle();
    expect(find.byType(RevealedSpread), findsOneWidget);
    expect(find.text('Wylosuj ponownie'), findsOneWidget);
  });

  testWidgets('big three: Moon from date, ascendant after time and place', (
    t,
  ) async {
    final store = await pump(t);
    store.saveProfile(CalendarDate.tryCreate(1990, 7, 15), null);
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
    await t.tap(find.text('Biblioteka'));
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
      await t.enterText(
        find.widgetWithText(TextField, 'Data urodzenia'),
        '15071990',
      );
      await t.tap(find.text('Pokaż mój horoskop'));
      await t.pumpAndSettle();
      expect(store.birthDate?.iso, '1990-07-15');
      expect(find.text('Rak'), findsOneWidget);
      await scrollTo(t, find.text('Sennik'));
      await t.tap(find.text('Sennik'));
      await t.pumpAndSettle();
      expect(find.textContaining('Szukaj symbolu'), findsOneWidget);
      await t.tap(find.byTooltip('Wstecz'));
      await t.pumpAndSettle();
      await t.tap(find.text('Zapytaj karty'));
      await t.pumpAndSettle();
      expect(find.text('Wybierz rozkład'), findsOneWidget);
    },
  );
}
