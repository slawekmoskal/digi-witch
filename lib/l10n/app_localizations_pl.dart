// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Digi Witch';

  @override
  String get tabToday => 'Dzisiaj';

  @override
  String get tabNumerology => 'Liczby';

  @override
  String get tabTarot => 'Tarot';

  @override
  String get tabLibrary => 'Biblioteka';

  @override
  String get tabJournal => 'Dziennik';

  @override
  String get settings => 'Ustawienia';

  @override
  String get start => 'Zaczynamy';

  @override
  String get onboardWhat =>
      'Poznawaj tradycje symboliczne: numerologię, tarot i archetypy. Każde obliczenie pokazujemy krok po kroku, a każdą kartę możesz poznać w bibliotece.';

  @override
  String get onboardNot =>
      'To narzędzie do rozrywki, nauki symboliki i autorefleksji. Nie przepowiada przyszłości, nie mierzy osobowości w sensie naukowym i nie zastępuje porady specjalisty.';

  @override
  String get onboardPrivacy =>
      'Nie potrzebujesz konta. Daty, imiona i dziennik zostają na tym urządzeniu.';

  @override
  String get onboardAdults => 'Aplikacja jest przeznaczona dla osób dorosłych.';

  @override
  String get reversed => 'odwrócona';

  @override
  String get writeReflection => 'Zapisz refleksję w dzienniku';

  @override
  String get exportJournal => 'Eksportuj dziennik';

  @override
  String get newEntry => 'Nowy wpis';

  @override
  String get editEntry => 'Wpis';

  @override
  String get journalEmpty =>
      'Dziennik jest pusty. Zapisz pierwszą myśl — możesz zacząć od pytania dnia albo wylosowanej karty.';

  @override
  String get journalPrivacy =>
      'Wpisy są przechowywane tylko na tym urządzeniu.';

  @override
  String get deleteEntryConfirm =>
      'Usunąć ten wpis? Tej operacji nie da się cofnąć.';

  @override
  String get cancel => 'Anuluj';

  @override
  String get delete => 'Usuń';

  @override
  String get save => 'Zapisz';

  @override
  String get linkedResult => 'Powiązany wynik';

  @override
  String get promptsTitle => 'Pytanie na start (opcjonalnie)';

  @override
  String promptCategory(String c) {
    String _temp0 = intl.Intl.selectLogic(c, {
      'ogolne': 'Ogólne',
      'rodzina': 'Rodzina',
      'tarot': 'Tarot',
      'liczby': 'Liczby',
      'other': 'Inne',
    });
    return '$_temp0';
  }

  @override
  String get randomPrompt => 'Wylosuj pytanie';

  @override
  String get familyNote =>
      'Pisz tylko o tym, czym chcesz się podzielić. Możesz używać pseudonimów zamiast imion bliskich.';

  @override
  String get entryHint => 'Twoje myśli…';

  @override
  String get tarotIntro =>
      'Karty traktujemy jako pretekst do refleksji, nie jako przepowiednię. Pozycje w rozkładzie to pytania, które warto sobie zadać.';

  @override
  String get drawCards => 'Wylosuj karty';

  @override
  String get drawAgain => 'Wylosuj ponownie';

  @override
  String get reversedOn =>
      'Karty odwrócone: włączone (każda karta niezależnie z prawdopodobieństwem 1/2).';

  @override
  String get reversedOff =>
      'Karty odwrócone: wyłączone — możesz je włączyć w Ustawieniach.';

  @override
  String get spreadReflectionPrompt =>
      'Co w tym rozkładzie najbardziej mnie poruszyło i dlaczego?';

  @override
  String get addBookmark => 'Dodaj zakładkę';

  @override
  String get removeBookmark => 'Usuń zakładkę';

  @override
  String get group => 'Grupa';

  @override
  String get keywords => 'Słowa kluczowe';

  @override
  String get symbolism => 'Symbolika';

  @override
  String get upright => 'Interpretacja prosta';

  @override
  String get reversedMeaning => 'Interpretacja odwrócona';

  @override
  String get reflectionQuestions => 'Pytania do refleksji';

  @override
  String get reflectionQuestion => 'Pytanie do refleksji';

  @override
  String get sourcesAndRights => 'Źródła i prawa';

  @override
  String get cardSourceNote =>
      'Opisy kart są autorskimi tekstami tej aplikacji. Ilustracja: Pamela Colman Smith (1878–1951), talia wydana w 1909 r. — domena publiczna; skan egzemplarza „Roses & Lilies” (Saskia Jansen), udostępniony w Wikimedia Commons. Grafikę jedynie przeskalowano.';

  @override
  String get numerologyIntro =>
      'Wpisz datę urodzenia, imię i nazwisko — albo tylko jedno z nich. Nic nie zapisujemy, dopóki sam(a) o to nie poprosisz.';

  @override
  String get birthDate => 'Data urodzenia';

  @override
  String get birthDateHelp => 'Wpisz same cyfry, np. 15071990';

  @override
  String get fullNameOptional => 'Imię i nazwisko (opcjonalnie)';

  @override
  String get fullNameHelp =>
      'Potrzebne tylko do liczb z liter. Polskie znaki są obsługiwane; spacje, łączniki i apostrofy pomijamy.';

  @override
  String get personalYearFor => 'Rok osobisty dla:';

  @override
  String get previousYear => 'Poprzedni rok';

  @override
  String get nextYear => 'Następny rok';

  @override
  String get calculate => 'Oblicz';

  @override
  String get saveAsProfile => 'Zapamiętaj jako mój profil';

  @override
  String get profileSaved => 'Zapisano na tym urządzeniu.';

  @override
  String get portrait => 'Portret numerologiczny';

  @override
  String get portraitNote =>
      'Rozwiń wskaźnik, aby zobaczyć obliczenie i jego symboliczną interpretację. Wyniki są zgodne z konwencją opisaną w Bibliotece („Jak liczymy”).';

  @override
  String indicatorName(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'lifePath': 'Droga życia',
      'birthDay': 'Liczba dnia urodzenia',
      'expression': 'Liczba ekspresji',
      'soulUrge': 'Liczba samogłosek',
      'personality': 'Liczba spółgłosek',
      'personalYear': 'Rok osobisty',
      'other': 'Wskaźnik',
    });
    return '$_temp0';
  }

  @override
  String get noBasis => 'Brak podstaw do obliczenia';

  @override
  String get calculation => 'Obliczenie';

  @override
  String get symbolicInterpretation => 'Interpretacja symboliczna';

  @override
  String get enterDateOrName => 'Podaj datę urodzenia lub imię i nazwisko.';

  @override
  String get dateInvalid => 'Taka data nie istnieje. Sprawdź dzień i miesiąc.';

  @override
  String get dateFuture => 'Data nie może być z przyszłości.';

  @override
  String get nameNoLetters => 'Wpisz przynajmniej jedną literę.';

  @override
  String nameUnsupported(String chars) {
    return 'Nieobsługiwane znaki: $chars. Wpisz zapis w alfabecie łacińskim (transliterację), którego chcesz użyć do obliczeń.';
  }

  @override
  String get cardOfDay => 'Karta dnia';

  @override
  String get cardOfDayNote =>
      'Karta dnia pozostaje ta sama do końca dnia według zegara tego urządzenia.';

  @override
  String get promptOfDay => 'Pytanie dnia';

  @override
  String yourPersonalYear(int year) {
    final intl.NumberFormat yearNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String yearString = yearNumberFormat.format(year);

    return 'Twój rok osobisty $yearString';
  }

  @override
  String get search => 'Szukaj kart, pojęć, artykułów';

  @override
  String get bookmarks => 'Zakładki';

  @override
  String get articles => 'Artykuły';

  @override
  String cardsCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Karty ($n)',
      many: 'Karty ($n)',
      few: 'Karty ($n)',
      one: 'Karta (1)',
    );
    return '$_temp0';
  }

  @override
  String get archetypes => 'Archetypy';

  @override
  String get archetypesNote =>
      '12 archetypów to autorski model redakcyjny tej aplikacji — jeden z wielu możliwych podziałów, a nie kanon ani test psychologiczny.';

  @override
  String get aboutModel => 'O modelu';

  @override
  String get archetypeGifts => 'Dary';

  @override
  String get archetypeShadow => 'Cień';

  @override
  String get glossary => 'Słownik pojęć';

  @override
  String get theme => 'Motyw';

  @override
  String get themeSystem => 'Systemowy';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get allowReversed => 'Karty odwrócone';

  @override
  String get allowReversedRule =>
      'Gdy włączone, każda wylosowana karta jest niezależnie odwrócona z prawdopodobieństwem 1/2.';

  @override
  String get profile => 'Mój profil';

  @override
  String get privacy => 'Prywatność';

  @override
  String get privacyBody =>
      'Nie zakładamy kont i nie wysyłamy Twoich dat, imion ani wpisów na serwer. Dane są tylko na tym urządzeniu — dopóki sam(a) ich nie wyeksportujesz.';

  @override
  String get deleteAllTitle => 'Usuń wszystkie dane';

  @override
  String get deleteAllBody =>
      'Usuniemy dziennik, profil, zakładki, kartę dnia i ustawienia z tego urządzenia. Tej operacji nie da się cofnąć.';

  @override
  String get sourcesBody =>
      'Teksty interpretacji, pytania, archetypy i artykuły są autorskie. Ilustracje kart: Pamela Colman Smith, talia z 1909 r. (domena publiczna), skany z Wikimedia Commons — szczegóły przy każdej karcie. Źródła historyczne wymieniamy na końcu artykułów.';

  @override
  String get purchases => 'Digi Witch Pro';

  @override
  String get help => 'Pomoc';

  @override
  String get helpBody =>
      'Jeśli przeżywasz kryzys, skontaktuj się ze specjalistą lub zadzwoń pod 116 123 (telefon zaufania dla dorosłych) albo 112 w nagłych sytuacjach.';

  @override
  String get versions => 'Wersje';

  @override
  String get algorithm => 'algorytm';

  @override
  String get contentVer => 'treści';

  @override
  String get disclaimer =>
      'Treści służą rozrywce, edukacji i autorefleksji. Nie są poradą medyczną, psychologiczną, prawną ani finansową.';

  @override
  String get proShort => 'Jednorazowy zakup: bez reklam, dodatkowe rozkłady.';

  @override
  String get proTitle => 'Digi Witch Pro';

  @override
  String get proBenefits =>
      '• Brak reklam w całej aplikacji\n• Dodatkowe rozkłady: „Relacja” (6 kart) i „Krzyż refleksji” (10 kart)\n• Jednorazowa płatność, bez subskrypcji';

  @override
  String get proFreeStays =>
      'Numerologia, karta dnia, rozkłady 1/3/5 kart, biblioteka i dziennik pozostają bezpłatne. Zakup nie wpływa na losowanie kart ani wyniki obliczeń.';

  @override
  String get proActive => 'Masz Pro — dziękujemy!';

  @override
  String get proUnavailable =>
      'Zakup jest w tej chwili niedostępny (brak połączenia ze sklepem). Spróbuj później.';

  @override
  String proBuy(String price) {
    return 'Kup Pro za $price';
  }

  @override
  String get purchaseError =>
      'Zakup nie został ukończony. Nie pobrano opłaty, jeśli sklep nie potwierdził transakcji.';

  @override
  String get restorePurchases => 'Przywróć zakupy';

  @override
  String get proOnly => 'Dostępne w Pro';

  @override
  String get adPrivacyOptions => 'Ustawienia prywatności reklam';
}
