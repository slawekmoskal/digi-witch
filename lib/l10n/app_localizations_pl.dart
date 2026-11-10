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
      'Twój codzienny przewodnik po symbolach: horoskop na dziś, Księżyc, tarot, numerologia, znak chiński i sennik. Każde obliczenie pokazujemy krok po kroku, a każdą kartę możesz poznać w bibliotece.';

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
  String get questionLabel => 'Twoje pytanie (opcjonalnie)';

  @override
  String get questionHint => 'np. Na co zwrócić uwagę przy zmianie pracy?';

  @override
  String get readingTitle => 'Co karty mówią o Twoim pytaniu';

  @override
  String get readingTitleNoQuestion => 'Podsumowanie rozkładu';

  @override
  String get summaryMajors =>
      'Przeważają Wielkie Arkana — sprawa dotyka czegoś ważnego, większego niż codzienne decyzje.';

  @override
  String summarySuit(String suit) {
    String _temp0 = intl.Intl.selectLogic(suit, {
      'wands': 'Najwięcej Buław — w tle są energia, działanie i inicjatywa.',
      'cups': 'Najwięcej Kielichów — w tle są emocje, uczucia i relacje.',
      'swords': 'Najwięcej Mieczy — w tle są myśli, decyzje i trudne rozmowy.',
      'pentacles':
          'Najwięcej Denarów — w tle są praca, pieniądze i sprawy praktyczne.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get summaryReversed =>
      'Większość kart jest odwrócona — coś może być zablokowane, opóźnione albo przeżywane bardziej w środku niż na zewnątrz.';

  @override
  String get summaryBalanced =>
      'Karty rozkładają się równomiernie — żaden obszar wyraźnie nie dominuje.';

  @override
  String summaryAnswer(String position, String card, String advice) {
    return 'Odpowiedź kart — $card w pozycji „$position”: $advice';
  }

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
      'Podaj datę urodzenia, a jeśli chcesz — także imię i nazwisko. Zapisane jako Twój profil odblokują horoskop na dziś, liczbę dnia, wielką trójkę i znak chiński. Dane zostają tylko na tym telefonie.';

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
      'personalDay': 'Liczba dnia',
      'relation': 'Liczba relacji',
      'personalMonth': 'Miesiąc osobisty',
      'maturity': 'Liczba dojrzałości',
      'house': 'Liczba domu',
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
      'Zakup jest w tej chwili niedostępny. Sprawdź połączenie z internetem i spróbuj później.';

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

  @override
  String get reminder => 'Codzienne przypomnienie';

  @override
  String get reminderOff => 'Wyłączone';

  @override
  String reminderAt(String time) {
    return 'Codziennie o $time';
  }

  @override
  String get reminderTitle => 'Digi Witch';

  @override
  String get reminderBody => 'Chwila na refleksję — jeśli masz ochotę.';

  @override
  String get reminderDenied =>
      'Brak zgody na powiadomienia. Możesz ją nadać w ustawieniach systemu.';

  @override
  String get proStoreNote =>
      'Płatność i ewentualne zwroty obsługuje App Store lub Google Play zgodnie ze swoimi zasadami. Zakup działa niezależnie od zgody na reklamy.';

  @override
  String get horoscopeToday => 'Dziś';

  @override
  String get horoscopeStars => 'Gwiazdy mówią';

  @override
  String get horoscopeCaution => 'Uważaj';

  @override
  String moonIn(String sign, String phase) {
    return 'Księżyc w $sign, $phase.';
  }

  @override
  String get luckyNumbers => 'Szczęśliwe liczby dnia';

  @override
  String get luckyNote =>
      'Dla zabawy: liczby wynikają z Twojej daty urodzenia i dzisiejszej daty, więc są stałe przez cały dzień. Nie przewidują wygranych.';

  @override
  String get whyThis => 'Z czego to wynika';

  @override
  String whySign(
    String sign,
    String dates,
    String element,
    String chinese,
    String chineseText,
  ) {
    return 'Twój znak: $sign ($dates), żywioł: $element. Chiński znak: $chinese — $chineseText';
  }

  @override
  String whyMoon(String sign, String element, String relation) {
    String _temp0 = intl.Intl.selectLogic(relation, {
      'same': 'ten sam żywioł',
      'supportive': 'wspierająca',
      'tense': 'napięta',
      'other': 'neutralna',
    });
    return 'Dziś w południe Księżyc jest w znaku $sign (żywioł: $element). Relacja z Twoim żywiołem: $_temp0.';
  }

  @override
  String get whyMethod =>
      'Położenie Księżyca liczymy wzorami astronomicznymi, bez internetu (dokładność ok. 0,5°). Tekst „Dziś” zależy od relacji żywiołów, „Gwiazdy mówią” od fazy Księżyca, a „Uważaj” od Twojej liczby dnia.';

  @override
  String get horoscopeNeedsBirth =>
      'Podaj datę urodzenia — od razu zobaczysz swój znak, horoskop na dziś, liczbę dnia i szczęśliwe liczby.';

  @override
  String get moonToday => 'Księżyc dziś';

  @override
  String moonState(String phase, int percent, String sign) {
    return '$phase · oświetlenie $percent% · w $sign';
  }

  @override
  String get moonCalendar => 'Kalendarz Księżyca';

  @override
  String get moonCalendarIntro =>
      'Najbliższe główne fazy Księżyca, czas lokalny (dokładność ok. 1 godziny).';

  @override
  String get compatibility => 'Zgodność dwóch osób';

  @override
  String get compatIntro =>
      'Wpisz daty urodzenia dwóch osób. Porównamy znaki zodiaku, żywioły, znaki chińskie i liczby drogi życia. To zabawa i pretekst do rozmowy, nie ocena związku.';

  @override
  String personDate(int n) {
    return 'Data urodzenia — osoba $n';
  }

  @override
  String get check => 'Sprawdź';

  @override
  String get compatElements => 'Żywioły';

  @override
  String personLine(
    int n,
    String sign,
    String element,
    String chinese,
    int lifePath,
  ) {
    return 'Osoba $n: $sign ($element) · chiński znak: $chinese · droga życia $lifePath';
  }

  @override
  String get birthCardTitle => 'Karta urodzenia';

  @override
  String get birthCardNote =>
      'Metoda: dzień + miesiąc + rok urodzenia, sumujemy cyfry, aż wynik będzie nie większy niż 22 (22 = Głupiec). Wynik dwucyfrowy daje też kartę towarzyszącą.';

  @override
  String get birthCardSecond => 'Karta towarzysząca';

  @override
  String yesNoAnswer(String a) {
    String _temp0 = intl.Intl.selectLogic(a, {
      'yes': 'Odpowiedź kart: TAK',
      'no': 'Odpowiedź kart: NIE',
      'other': 'Odpowiedź kart: NIEJASNA — sprawa jeszcze się waży',
    });
    return '$_temp0';
  }

  @override
  String get horoscopeFor => 'Dziś dla Ciebie';

  @override
  String get licenses => 'Licencje (czcionki i biblioteki)';

  @override
  String get cardAdvice => 'Rada karty';

  @override
  String get correspondences =>
      'Korespondencje astrologiczne (Złoty Brzask, XIX w.)';

  @override
  String get chooseSpread => 'Wybierz rozkład';

  @override
  String get tapDeck => 'Zadaj pytanie w myślach i dotknij talii';

  @override
  String spreadCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n kart',
      many: '$n kart',
      few: '$n karty',
      one: '1 karta',
    );
    return '$_temp0';
  }

  @override
  String get bigThree => 'Twoja wielka trójka';

  @override
  String get bigThreeIntro =>
      'Słońce to Twój znak zodiaku. Księżyc opisuje emocje, a ascendent — to, jak widzą Cię inni. Do Księżyca zwykle wystarczy data, do ascendentu potrzebna jest godzina i miejsce urodzenia. Dane zostają tylko na tym urządzeniu.';

  @override
  String get birthTime => 'Godzina urodzenia';

  @override
  String get notGiven => 'nie podano';

  @override
  String get birthPlace => 'Miejsce urodzenia';

  @override
  String get placesNote =>
      'Miasta w Polsce i największe miasta za granicą. Jeśli Twojego nie ma, wybierz najbliższe w tym samym kraju albo podaj współrzędne — kilkadziesiąt kilometrów zmienia ascendent o mniej niż 1°.';

  @override
  String get sunLabel => 'Słońce';

  @override
  String get moonLabel => 'Księżyc';

  @override
  String get ascLabel => 'Ascendent';

  @override
  String moonTwoSigns(String a, String b) {
    return 'Tego dnia Księżyc zmieniał znak: $a albo $b — zależy od godziny urodzenia.';
  }

  @override
  String get ascNeeds =>
      'Podaj godzinę i miejsce urodzenia, aby obliczyć ascendent.';

  @override
  String traceTime(String local, String utc, String zone) {
    return 'Czas lokalny $local → $utc UTC (strefa $zone, z historią czasu letniego).';
  }

  @override
  String traceMoon(String deg, String sign) {
    return 'Długość ekliptyczna Księżyca: $deg° → $sign.';
  }

  @override
  String traceAsc(
    String deg,
    String sign,
    String place,
    String lat,
    String lon,
  ) {
    return 'Ascendent: $deg° → $sign ($place, $lat° N, $lon° E).';
  }

  @override
  String get needBirthDate =>
      'Najpierw zapisz datę urodzenia w zakładce Liczby (przycisk „Zapamiętaj jako mój profil”).';

  @override
  String get clear => 'Wyczyść';

  @override
  String get chineseTitle => 'Horoskop chiński';

  @override
  String chineseBirthYear(int year, String element, String yy) {
    String _temp0 = intl.Intl.selectLogic(yy, {'yang': 'yang', 'other': 'yin'});
    return 'Rok według kalendarza chińskiego: $year · $element · $_temp0';
  }

  @override
  String get chineseNewYearNote =>
      'Chiński Nowy Rok wypada między 21 stycznia a 20 lutego. Jeśli urodziłeś(-aś) przed nim, należysz do znaku poprzedniego roku — tu jest to już uwzględnione.';

  @override
  String chineseCurrentYear(int year, String animal, String element) {
    return 'Rok $year: $animal · $element';
  }

  @override
  String chineseYearSince(String date) {
    return 'Obecny rok chiński trwa od $date.';
  }

  @override
  String get chineseCompatTitle => 'Zgodność znaków chińskich';

  @override
  String get chineseFriend => 'Tajemny przyjaciel';

  @override
  String get chineseTrine => 'Trójka sprzymierzeńców';

  @override
  String get chineseClash => 'Znak przeciwny';

  @override
  String get chineseElement => 'Żywioł roku urodzenia';

  @override
  String get mercuryRetro => 'Merkury wsteczny';

  @override
  String mercuryNow(String date) {
    return 'Merkury wsteczny do $date';
  }

  @override
  String get mercuryNone => 'W najbliższym roku brak okresów wstecznych.';

  @override
  String get upcomingPhases => 'Najbliższe fazy';

  @override
  String get dayByDay => 'Dzień po dniu (30 dni)';

  @override
  String moonDayLine(String sign, String phase) {
    return 'Księżyc w $sign · $phase';
  }

  @override
  String get dreams => 'Sennik';

  @override
  String dreamsCount(int n) {
    return '$n symboli snów — co sen może mówić o Tobie';
  }

  @override
  String get dreamsIntro =>
      'Sny nie przepowiadają przyszłości. Sennik podpowiada, z czym dany symbol bywa kojarzony, a pytanie pomaga sprawdzić, co znaczy właśnie dla Ciebie. Najważniejsze jest to, co czułeś(-aś) we śnie.';

  @override
  String get dreamsSearch => 'Szukaj symbolu, np. woda, zęby, dom';

  @override
  String get dreamsEmpty =>
      'Nie ma takiego symbolu. Spróbuj podobnego słowa — albo zapisz sen w dzienniku.';

  @override
  String chineseSignButton(String animal) {
    return 'Znak chiński: $animal';
  }

  @override
  String get otherPlace => 'Inne miejsce — podaj współrzędne';

  @override
  String otherPlaceSet(String place, String zone) {
    return 'Inne miejsce: $place ($zone)';
  }

  @override
  String get otherPlaceHelp =>
      'Współrzędne znajdziesz w mapach (np. kliknij miejsce w Mapach Google). Południe i zachód wpisuj ze znakiem minus. Strefa czasowa to region, np. Europe/London, America/Chicago.';

  @override
  String get latitude => 'Szerokość geograficzna';

  @override
  String get longitude => 'Długość geograficzna';

  @override
  String get timeZone => 'Strefa czasowa';

  @override
  String get otherPlaceMissing =>
      'Uzupełnij szerokość, długość i strefę czasową.';

  @override
  String get otherPlaceRange =>
      'Szerokość musi być między -66° a 66° (za kołem podbiegunowym ascendent bywa nieokreślony), długość między -180° a 180°.';

  @override
  String get numbersStartTitle => 'Zacznij od daty urodzenia';

  @override
  String get numbersEditTitle => 'Zmień dane lub policz dla innej osoby';

  @override
  String get calculateOnce => 'Tylko oblicz (bez zapisywania)';

  @override
  String get compatibilityHint => 'Porównaj dwie daty urodzenia';

  @override
  String get yourNumbers => 'Twoje liczby';

  @override
  String get editOrOther => 'Zmień dane lub policz dla kogoś innego';

  @override
  String get showMyHoroscope => 'Pokaż mój horoskop';

  @override
  String get privacyShort =>
      'Data zostaje tylko na tym telefonie. Zmienisz ją w zakładce Liczby.';

  @override
  String get explore => 'Odkrywaj';

  @override
  String get exploreBigThree => 'Słońce, Księżyc i ascendent';

  @override
  String get exploreChinese => 'Znak, żywioł i Twój rok';

  @override
  String get exploreTarot => 'Zapytaj karty';

  @override
  String get exploreTarotSub => 'Rozkłady i pytania „tak czy nie”';

  @override
  String get exploreNumbersSub => 'Droga życia i karta urodzenia';

  @override
  String get exploreMoon => 'Fazy, ogród, Merkury wsteczny';

  @override
  String get exploreDreams => 'Co mówi Twój sen';

  @override
  String get exploreLibrary => '78 kart, artykuły, słownik — w Bibliotece';

  @override
  String get exploreLibraryTitle => 'Karty i artykuły';

  @override
  String get squareTitle => 'Kwadrat Pitagorasa';

  @override
  String get squareIntro =>
      'Siatka cyfr z daty urodzenia (metoda Aleksandrowa): im więcej danej cyfry, tym silniej wyrażona cecha. Stuknij pole, aby przeczytać opis.';

  @override
  String get squareEmpty => 'brak';

  @override
  String get cyclesTitle => 'Cykle życia: szczyty i wyzwania';

  @override
  String get cyclesIntro =>
      'Numerologia dzieli życie na cztery etapy. Każdy ma swój „szczyt” — temat rozwoju — i „wyzwanie” — lekcję do przepracowania. Długość pierwszego etapu zależy od drogi życia.';

  @override
  String ageRange(int from, int to) {
    return '$from–$to lat';
  }

  @override
  String ageFrom(int from) {
    return 'od $from lat';
  }

  @override
  String get cyclesNow => 'TERAZ';

  @override
  String get ichingTitle => 'Wyrocznia I Ching';

  @override
  String get ichingIntro =>
      'Księga Przemian to klasyczna chińska wyrocznia. Pomyśl o pytaniu, a potem rzuć trzema monetami sześć razy — heksagram buduje się od dołu. Linie z kropką są „zmienne” i pokazują, w co sytuacja się przekształca.';

  @override
  String ichingToss(int n) {
    return 'Rzuć monetami ($n/6)';
  }

  @override
  String ichingLastToss(String sum) {
    String _temp0 = intl.Intl.selectLogic(sum, {
      '6': 'reszka, reszka, reszka = 6 (stary yin, zmienna)',
      '7': 'dwie reszki i orzeł = 7 (yang)',
      '8': 'dwa orły i reszka = 8 (yin)',
      'other': 'orzeł, orzeł, orzeł = 9 (stary yang, zmienna)',
    });
    return 'Ostatni rzut: $_temp0';
  }

  @override
  String get ichingMeaning => 'Znaczenie';

  @override
  String get ichingChange => 'Kierunek zmiany';

  @override
  String ichingChangingLines(String lines) {
    return 'Zmienne linie: $lines. Sytuacja przechodzi w:';
  }

  @override
  String get ichingAgain => 'Nowe pytanie';

  @override
  String get ichingNote =>
      'Opisy heksagramów są autorskimi, skróconymi interpretacjami tej aplikacji — traktuj je jako pretekst do refleksji.';

  @override
  String get exploreIching => 'Pytanie i sześć rzutów monetą';

  @override
  String get ritualsTitle => 'Rytuały Księżyca';

  @override
  String get exploreRituals => 'Intencje na nów i pełnię';

  @override
  String get ritualsIntro =>
      'Nów i pełnia wyznaczają rytm miesiąca. Zapisz intencję na nowiu, a na pełni sprawdź, co się wydarzyło — wpisy trafią do Twojego dziennika.';

  @override
  String get moonRemindersToggle => 'Przypomnij mi o nowiu i pełni';

  @override
  String get moonRemindersNote =>
      'Powiadomienie o 9:00 w dniu nowiu i pełni. Bez internetu.';

  @override
  String get moonReminderNewTitle => 'Nów — czas na intencję';

  @override
  String get moonReminderNewBody => 'Zapisz, co chcesz zacząć w tym cyklu.';

  @override
  String get moonReminderFullTitle => 'Pełnia — czas na podsumowanie';

  @override
  String get moonReminderFullBody =>
      'Co się udało od nowiu? Za co jesteś wdzięczny(-a)?';

  @override
  String get forYouToday => 'Tylko dla Ciebie';

  @override
  String get advice => 'Rada';

  @override
  String get karmicTitle => 'Karma w liczbach';

  @override
  String get karmicIntro =>
      'Długi karmiczne to liczby 13, 14, 16 i 19 pojawiające się po drodze do Twoich liczb. Lekcje karmiczne to cyfry, których brakuje w imieniu i nazwisku. W tradycji opisują tematy do przepracowania — nie wyroki.';

  @override
  String get karmicNone => 'Brak długów karmicznych w Twoich liczbach.';

  @override
  String get karmicLessonsTitle =>
      'Lekcje karmiczne (brakujące cyfry w imieniu)';

  @override
  String get houseTitle => 'Numerologia domu i telefonu';

  @override
  String get houseHint => 'Numer domu, mieszkania lub telefonu, np. 12A';

  @override
  String luckyMeaning(int n, int reduced, String keywords) {
    return '$n → $reduced: $keywords';
  }

  @override
  String dayColor(String color) {
    return 'Kolor dnia: $color';
  }

  @override
  String signExtras(String color, String stone, String day, String planet) {
    return 'Kolor: $color · kamień: $stone · dzień: $day · planeta: $planet';
  }

  @override
  String get luckyTap => 'Stuknij liczbę, aby zobaczyć jej znaczenie.';
}
