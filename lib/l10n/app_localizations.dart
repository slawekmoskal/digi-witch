import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('pl')];

  /// No description provided for @appTitle.
  ///
  /// In pl, this message translates to:
  /// **'Digi Witch'**
  String get appTitle;

  /// No description provided for @tabToday.
  ///
  /// In pl, this message translates to:
  /// **'Dzisiaj'**
  String get tabToday;

  /// No description provided for @tabNumerology.
  ///
  /// In pl, this message translates to:
  /// **'Liczby'**
  String get tabNumerology;

  /// No description provided for @tabTarot.
  ///
  /// In pl, this message translates to:
  /// **'Tarot'**
  String get tabTarot;

  /// No description provided for @tabLibrary.
  ///
  /// In pl, this message translates to:
  /// **'Biblioteka'**
  String get tabLibrary;

  /// No description provided for @tabJournal.
  ///
  /// In pl, this message translates to:
  /// **'Dziennik'**
  String get tabJournal;

  /// No description provided for @settings.
  ///
  /// In pl, this message translates to:
  /// **'Ustawienia'**
  String get settings;

  /// No description provided for @start.
  ///
  /// In pl, this message translates to:
  /// **'Zaczynamy'**
  String get start;

  /// No description provided for @onboardWhat.
  ///
  /// In pl, this message translates to:
  /// **'Poznawaj tradycje symboliczne: numerologię, tarot i archetypy. Każde obliczenie pokazujemy krok po kroku, a każdą kartę możesz poznać w bibliotece.'**
  String get onboardWhat;

  /// No description provided for @onboardNot.
  ///
  /// In pl, this message translates to:
  /// **'To narzędzie do rozrywki, nauki symboliki i autorefleksji. Nie przepowiada przyszłości, nie mierzy osobowości w sensie naukowym i nie zastępuje porady specjalisty.'**
  String get onboardNot;

  /// No description provided for @onboardPrivacy.
  ///
  /// In pl, this message translates to:
  /// **'Nie potrzebujesz konta. Daty, imiona i dziennik zostają na tym urządzeniu.'**
  String get onboardPrivacy;

  /// No description provided for @onboardAdults.
  ///
  /// In pl, this message translates to:
  /// **'Aplikacja jest przeznaczona dla osób dorosłych.'**
  String get onboardAdults;

  /// No description provided for @reversed.
  ///
  /// In pl, this message translates to:
  /// **'odwrócona'**
  String get reversed;

  /// No description provided for @writeReflection.
  ///
  /// In pl, this message translates to:
  /// **'Zapisz refleksję w dzienniku'**
  String get writeReflection;

  /// No description provided for @exportJournal.
  ///
  /// In pl, this message translates to:
  /// **'Eksportuj dziennik'**
  String get exportJournal;

  /// No description provided for @newEntry.
  ///
  /// In pl, this message translates to:
  /// **'Nowy wpis'**
  String get newEntry;

  /// No description provided for @editEntry.
  ///
  /// In pl, this message translates to:
  /// **'Wpis'**
  String get editEntry;

  /// No description provided for @journalEmpty.
  ///
  /// In pl, this message translates to:
  /// **'Dziennik jest pusty. Zapisz pierwszą myśl — możesz zacząć od pytania dnia albo wylosowanej karty.'**
  String get journalEmpty;

  /// No description provided for @journalPrivacy.
  ///
  /// In pl, this message translates to:
  /// **'Wpisy są przechowywane tylko na tym urządzeniu.'**
  String get journalPrivacy;

  /// No description provided for @deleteEntryConfirm.
  ///
  /// In pl, this message translates to:
  /// **'Usunąć ten wpis? Tej operacji nie da się cofnąć.'**
  String get deleteEntryConfirm;

  /// No description provided for @cancel.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In pl, this message translates to:
  /// **'Usuń'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In pl, this message translates to:
  /// **'Zapisz'**
  String get save;

  /// No description provided for @linkedResult.
  ///
  /// In pl, this message translates to:
  /// **'Powiązany wynik'**
  String get linkedResult;

  /// No description provided for @promptsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Pytanie na start (opcjonalnie)'**
  String get promptsTitle;

  /// No description provided for @promptCategory.
  ///
  /// In pl, this message translates to:
  /// **'{c, select, ogolne{Ogólne} rodzina{Rodzina} tarot{Tarot} liczby{Liczby} other{Inne}}'**
  String promptCategory(String c);

  /// No description provided for @randomPrompt.
  ///
  /// In pl, this message translates to:
  /// **'Wylosuj pytanie'**
  String get randomPrompt;

  /// No description provided for @familyNote.
  ///
  /// In pl, this message translates to:
  /// **'Pisz tylko o tym, czym chcesz się podzielić. Możesz używać pseudonimów zamiast imion bliskich.'**
  String get familyNote;

  /// No description provided for @entryHint.
  ///
  /// In pl, this message translates to:
  /// **'Twoje myśli…'**
  String get entryHint;

  /// No description provided for @tarotIntro.
  ///
  /// In pl, this message translates to:
  /// **'Karty traktujemy jako pretekst do refleksji, nie jako przepowiednię. Pozycje w rozkładzie to pytania, które warto sobie zadać.'**
  String get tarotIntro;

  /// No description provided for @drawCards.
  ///
  /// In pl, this message translates to:
  /// **'Wylosuj karty'**
  String get drawCards;

  /// No description provided for @drawAgain.
  ///
  /// In pl, this message translates to:
  /// **'Wylosuj ponownie'**
  String get drawAgain;

  /// No description provided for @reversedOn.
  ///
  /// In pl, this message translates to:
  /// **'Karty odwrócone: włączone (każda karta niezależnie z prawdopodobieństwem 1/2).'**
  String get reversedOn;

  /// No description provided for @reversedOff.
  ///
  /// In pl, this message translates to:
  /// **'Karty odwrócone: wyłączone — możesz je włączyć w Ustawieniach.'**
  String get reversedOff;

  /// No description provided for @spreadReflectionPrompt.
  ///
  /// In pl, this message translates to:
  /// **'Co w tym rozkładzie najbardziej mnie poruszyło i dlaczego?'**
  String get spreadReflectionPrompt;

  /// No description provided for @questionLabel.
  ///
  /// In pl, this message translates to:
  /// **'Twoje pytanie (opcjonalnie)'**
  String get questionLabel;

  /// No description provided for @questionHint.
  ///
  /// In pl, this message translates to:
  /// **'np. Na co zwrócić uwagę przy zmianie pracy?'**
  String get questionHint;

  /// No description provided for @readingTitle.
  ///
  /// In pl, this message translates to:
  /// **'Co karty mówią o Twoim pytaniu'**
  String get readingTitle;

  /// No description provided for @readingTitleNoQuestion.
  ///
  /// In pl, this message translates to:
  /// **'Podsumowanie rozkładu'**
  String get readingTitleNoQuestion;

  /// No description provided for @summaryMajors.
  ///
  /// In pl, this message translates to:
  /// **'Przeważają Wielkie Arkana — sprawa dotyka czegoś ważnego, większego niż codzienne decyzje.'**
  String get summaryMajors;

  /// No description provided for @summarySuit.
  ///
  /// In pl, this message translates to:
  /// **'{suit, select, wands{Najwięcej Buław — w tle są energia, działanie i inicjatywa.} cups{Najwięcej Kielichów — w tle są emocje, uczucia i relacje.} swords{Najwięcej Mieczy — w tle są myśli, decyzje i trudne rozmowy.} pentacles{Najwięcej Denarów — w tle są praca, pieniądze i sprawy praktyczne.} other{}}'**
  String summarySuit(String suit);

  /// No description provided for @summaryReversed.
  ///
  /// In pl, this message translates to:
  /// **'Większość kart jest odwrócona — coś może być zablokowane, opóźnione albo przeżywane bardziej w środku niż na zewnątrz.'**
  String get summaryReversed;

  /// No description provided for @summaryBalanced.
  ///
  /// In pl, this message translates to:
  /// **'Karty rozkładają się równomiernie — żaden obszar wyraźnie nie dominuje.'**
  String get summaryBalanced;

  /// No description provided for @summaryAnswer.
  ///
  /// In pl, this message translates to:
  /// **'Odpowiedź kart — {card} w pozycji „{position}”: {advice}'**
  String summaryAnswer(String position, String card, String advice);

  /// No description provided for @addBookmark.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj zakładkę'**
  String get addBookmark;

  /// No description provided for @removeBookmark.
  ///
  /// In pl, this message translates to:
  /// **'Usuń zakładkę'**
  String get removeBookmark;

  /// No description provided for @group.
  ///
  /// In pl, this message translates to:
  /// **'Grupa'**
  String get group;

  /// No description provided for @keywords.
  ///
  /// In pl, this message translates to:
  /// **'Słowa kluczowe'**
  String get keywords;

  /// No description provided for @symbolism.
  ///
  /// In pl, this message translates to:
  /// **'Symbolika'**
  String get symbolism;

  /// No description provided for @upright.
  ///
  /// In pl, this message translates to:
  /// **'Interpretacja prosta'**
  String get upright;

  /// No description provided for @reversedMeaning.
  ///
  /// In pl, this message translates to:
  /// **'Interpretacja odwrócona'**
  String get reversedMeaning;

  /// No description provided for @reflectionQuestions.
  ///
  /// In pl, this message translates to:
  /// **'Pytania do refleksji'**
  String get reflectionQuestions;

  /// No description provided for @reflectionQuestion.
  ///
  /// In pl, this message translates to:
  /// **'Pytanie do refleksji'**
  String get reflectionQuestion;

  /// No description provided for @sourcesAndRights.
  ///
  /// In pl, this message translates to:
  /// **'Źródła i prawa'**
  String get sourcesAndRights;

  /// No description provided for @cardSourceNote.
  ///
  /// In pl, this message translates to:
  /// **'Opisy kart są autorskimi tekstami tej aplikacji. Ilustracja: Pamela Colman Smith (1878–1951), talia wydana w 1909 r. — domena publiczna; skan egzemplarza „Roses & Lilies” (Saskia Jansen), udostępniony w Wikimedia Commons. Grafikę jedynie przeskalowano.'**
  String get cardSourceNote;

  /// No description provided for @numerologyIntro.
  ///
  /// In pl, this message translates to:
  /// **'Wpisz datę urodzenia, imię i nazwisko — albo tylko jedno z nich. Nic nie zapisujemy, dopóki sam(a) o to nie poprosisz.'**
  String get numerologyIntro;

  /// No description provided for @birthDate.
  ///
  /// In pl, this message translates to:
  /// **'Data urodzenia'**
  String get birthDate;

  /// No description provided for @birthDateHelp.
  ///
  /// In pl, this message translates to:
  /// **'Wpisz same cyfry, np. 15071990'**
  String get birthDateHelp;

  /// No description provided for @fullNameOptional.
  ///
  /// In pl, this message translates to:
  /// **'Imię i nazwisko (opcjonalnie)'**
  String get fullNameOptional;

  /// No description provided for @fullNameHelp.
  ///
  /// In pl, this message translates to:
  /// **'Potrzebne tylko do liczb z liter. Polskie znaki są obsługiwane; spacje, łączniki i apostrofy pomijamy.'**
  String get fullNameHelp;

  /// No description provided for @personalYearFor.
  ///
  /// In pl, this message translates to:
  /// **'Rok osobisty dla:'**
  String get personalYearFor;

  /// No description provided for @previousYear.
  ///
  /// In pl, this message translates to:
  /// **'Poprzedni rok'**
  String get previousYear;

  /// No description provided for @nextYear.
  ///
  /// In pl, this message translates to:
  /// **'Następny rok'**
  String get nextYear;

  /// No description provided for @calculate.
  ///
  /// In pl, this message translates to:
  /// **'Oblicz'**
  String get calculate;

  /// No description provided for @saveAsProfile.
  ///
  /// In pl, this message translates to:
  /// **'Zapamiętaj jako mój profil'**
  String get saveAsProfile;

  /// No description provided for @profileSaved.
  ///
  /// In pl, this message translates to:
  /// **'Zapisano na tym urządzeniu.'**
  String get profileSaved;

  /// No description provided for @portrait.
  ///
  /// In pl, this message translates to:
  /// **'Portret numerologiczny'**
  String get portrait;

  /// No description provided for @portraitNote.
  ///
  /// In pl, this message translates to:
  /// **'Rozwiń wskaźnik, aby zobaczyć obliczenie i jego symboliczną interpretację. Wyniki są zgodne z konwencją opisaną w Bibliotece („Jak liczymy”).'**
  String get portraitNote;

  /// No description provided for @indicatorName.
  ///
  /// In pl, this message translates to:
  /// **'{name, select, lifePath{Droga życia} birthDay{Liczba dnia urodzenia} expression{Liczba ekspresji} soulUrge{Liczba samogłosek} personality{Liczba spółgłosek} personalYear{Rok osobisty} personalDay{Liczba dnia} relation{Liczba relacji} other{Wskaźnik}}'**
  String indicatorName(String name);

  /// No description provided for @noBasis.
  ///
  /// In pl, this message translates to:
  /// **'Brak podstaw do obliczenia'**
  String get noBasis;

  /// No description provided for @calculation.
  ///
  /// In pl, this message translates to:
  /// **'Obliczenie'**
  String get calculation;

  /// No description provided for @symbolicInterpretation.
  ///
  /// In pl, this message translates to:
  /// **'Interpretacja symboliczna'**
  String get symbolicInterpretation;

  /// No description provided for @enterDateOrName.
  ///
  /// In pl, this message translates to:
  /// **'Podaj datę urodzenia lub imię i nazwisko.'**
  String get enterDateOrName;

  /// No description provided for @dateInvalid.
  ///
  /// In pl, this message translates to:
  /// **'Taka data nie istnieje. Sprawdź dzień i miesiąc.'**
  String get dateInvalid;

  /// No description provided for @dateFuture.
  ///
  /// In pl, this message translates to:
  /// **'Data nie może być z przyszłości.'**
  String get dateFuture;

  /// No description provided for @nameNoLetters.
  ///
  /// In pl, this message translates to:
  /// **'Wpisz przynajmniej jedną literę.'**
  String get nameNoLetters;

  /// No description provided for @nameUnsupported.
  ///
  /// In pl, this message translates to:
  /// **'Nieobsługiwane znaki: {chars}. Wpisz zapis w alfabecie łacińskim (transliterację), którego chcesz użyć do obliczeń.'**
  String nameUnsupported(String chars);

  /// No description provided for @cardOfDay.
  ///
  /// In pl, this message translates to:
  /// **'Karta dnia'**
  String get cardOfDay;

  /// No description provided for @cardOfDayNote.
  ///
  /// In pl, this message translates to:
  /// **'Karta dnia pozostaje ta sama do końca dnia według zegara tego urządzenia.'**
  String get cardOfDayNote;

  /// No description provided for @promptOfDay.
  ///
  /// In pl, this message translates to:
  /// **'Pytanie dnia'**
  String get promptOfDay;

  /// No description provided for @yourPersonalYear.
  ///
  /// In pl, this message translates to:
  /// **'Twój rok osobisty {year}'**
  String yourPersonalYear(int year);

  /// No description provided for @search.
  ///
  /// In pl, this message translates to:
  /// **'Szukaj kart, pojęć, artykułów'**
  String get search;

  /// No description provided for @bookmarks.
  ///
  /// In pl, this message translates to:
  /// **'Zakładki'**
  String get bookmarks;

  /// No description provided for @articles.
  ///
  /// In pl, this message translates to:
  /// **'Artykuły'**
  String get articles;

  /// No description provided for @cardsCount.
  ///
  /// In pl, this message translates to:
  /// **'{n, plural, one{Karta (1)} few{Karty ({n})} many{Karty ({n})} other{Karty ({n})}}'**
  String cardsCount(int n);

  /// No description provided for @archetypes.
  ///
  /// In pl, this message translates to:
  /// **'Archetypy'**
  String get archetypes;

  /// No description provided for @archetypesNote.
  ///
  /// In pl, this message translates to:
  /// **'12 archetypów to autorski model redakcyjny tej aplikacji — jeden z wielu możliwych podziałów, a nie kanon ani test psychologiczny.'**
  String get archetypesNote;

  /// No description provided for @aboutModel.
  ///
  /// In pl, this message translates to:
  /// **'O modelu'**
  String get aboutModel;

  /// No description provided for @archetypeGifts.
  ///
  /// In pl, this message translates to:
  /// **'Dary'**
  String get archetypeGifts;

  /// No description provided for @archetypeShadow.
  ///
  /// In pl, this message translates to:
  /// **'Cień'**
  String get archetypeShadow;

  /// No description provided for @glossary.
  ///
  /// In pl, this message translates to:
  /// **'Słownik pojęć'**
  String get glossary;

  /// No description provided for @theme.
  ///
  /// In pl, this message translates to:
  /// **'Motyw'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In pl, this message translates to:
  /// **'Systemowy'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In pl, this message translates to:
  /// **'Jasny'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In pl, this message translates to:
  /// **'Ciemny'**
  String get themeDark;

  /// No description provided for @allowReversed.
  ///
  /// In pl, this message translates to:
  /// **'Karty odwrócone'**
  String get allowReversed;

  /// No description provided for @allowReversedRule.
  ///
  /// In pl, this message translates to:
  /// **'Gdy włączone, każda wylosowana karta jest niezależnie odwrócona z prawdopodobieństwem 1/2.'**
  String get allowReversedRule;

  /// No description provided for @profile.
  ///
  /// In pl, this message translates to:
  /// **'Mój profil'**
  String get profile;

  /// No description provided for @privacy.
  ///
  /// In pl, this message translates to:
  /// **'Prywatność'**
  String get privacy;

  /// No description provided for @privacyBody.
  ///
  /// In pl, this message translates to:
  /// **'Nie zakładamy kont i nie wysyłamy Twoich dat, imion ani wpisów na serwer. Dane są tylko na tym urządzeniu — dopóki sam(a) ich nie wyeksportujesz.'**
  String get privacyBody;

  /// No description provided for @deleteAllTitle.
  ///
  /// In pl, this message translates to:
  /// **'Usuń wszystkie dane'**
  String get deleteAllTitle;

  /// No description provided for @deleteAllBody.
  ///
  /// In pl, this message translates to:
  /// **'Usuniemy dziennik, profil, zakładki, kartę dnia i ustawienia z tego urządzenia. Tej operacji nie da się cofnąć.'**
  String get deleteAllBody;

  /// No description provided for @sourcesBody.
  ///
  /// In pl, this message translates to:
  /// **'Teksty interpretacji, pytania, archetypy i artykuły są autorskie. Ilustracje kart: Pamela Colman Smith, talia z 1909 r. (domena publiczna), skany z Wikimedia Commons — szczegóły przy każdej karcie. Źródła historyczne wymieniamy na końcu artykułów.'**
  String get sourcesBody;

  /// No description provided for @purchases.
  ///
  /// In pl, this message translates to:
  /// **'Digi Witch Pro'**
  String get purchases;

  /// No description provided for @help.
  ///
  /// In pl, this message translates to:
  /// **'Pomoc'**
  String get help;

  /// No description provided for @helpBody.
  ///
  /// In pl, this message translates to:
  /// **'Jeśli przeżywasz kryzys, skontaktuj się ze specjalistą lub zadzwoń pod 116 123 (telefon zaufania dla dorosłych) albo 112 w nagłych sytuacjach.'**
  String get helpBody;

  /// No description provided for @versions.
  ///
  /// In pl, this message translates to:
  /// **'Wersje'**
  String get versions;

  /// No description provided for @algorithm.
  ///
  /// In pl, this message translates to:
  /// **'algorytm'**
  String get algorithm;

  /// No description provided for @contentVer.
  ///
  /// In pl, this message translates to:
  /// **'treści'**
  String get contentVer;

  /// No description provided for @disclaimer.
  ///
  /// In pl, this message translates to:
  /// **'Treści służą rozrywce, edukacji i autorefleksji. Nie są poradą medyczną, psychologiczną, prawną ani finansową.'**
  String get disclaimer;

  /// No description provided for @proShort.
  ///
  /// In pl, this message translates to:
  /// **'Jednorazowy zakup: bez reklam, dodatkowe rozkłady.'**
  String get proShort;

  /// No description provided for @proTitle.
  ///
  /// In pl, this message translates to:
  /// **'Digi Witch Pro'**
  String get proTitle;

  /// No description provided for @proBenefits.
  ///
  /// In pl, this message translates to:
  /// **'• Brak reklam w całej aplikacji\n• Dodatkowe rozkłady: „Relacja” (6 kart) i „Krzyż refleksji” (10 kart)\n• Jednorazowa płatność, bez subskrypcji'**
  String get proBenefits;

  /// No description provided for @proFreeStays.
  ///
  /// In pl, this message translates to:
  /// **'Numerologia, karta dnia, rozkłady 1/3/5 kart, biblioteka i dziennik pozostają bezpłatne. Zakup nie wpływa na losowanie kart ani wyniki obliczeń.'**
  String get proFreeStays;

  /// No description provided for @proActive.
  ///
  /// In pl, this message translates to:
  /// **'Masz Pro — dziękujemy!'**
  String get proActive;

  /// No description provided for @proUnavailable.
  ///
  /// In pl, this message translates to:
  /// **'Zakup jest w tej chwili niedostępny. Sprawdź połączenie z internetem i spróbuj później.'**
  String get proUnavailable;

  /// No description provided for @proBuy.
  ///
  /// In pl, this message translates to:
  /// **'Kup Pro za {price}'**
  String proBuy(String price);

  /// No description provided for @purchaseError.
  ///
  /// In pl, this message translates to:
  /// **'Zakup nie został ukończony. Nie pobrano opłaty, jeśli sklep nie potwierdził transakcji.'**
  String get purchaseError;

  /// No description provided for @restorePurchases.
  ///
  /// In pl, this message translates to:
  /// **'Przywróć zakupy'**
  String get restorePurchases;

  /// No description provided for @proOnly.
  ///
  /// In pl, this message translates to:
  /// **'Dostępne w Pro'**
  String get proOnly;

  /// No description provided for @adPrivacyOptions.
  ///
  /// In pl, this message translates to:
  /// **'Ustawienia prywatności reklam'**
  String get adPrivacyOptions;

  /// No description provided for @reminder.
  ///
  /// In pl, this message translates to:
  /// **'Codzienne przypomnienie'**
  String get reminder;

  /// No description provided for @reminderOff.
  ///
  /// In pl, this message translates to:
  /// **'Wyłączone'**
  String get reminderOff;

  /// No description provided for @reminderAt.
  ///
  /// In pl, this message translates to:
  /// **'Codziennie o {time}'**
  String reminderAt(String time);

  /// No description provided for @reminderTitle.
  ///
  /// In pl, this message translates to:
  /// **'Digi Witch'**
  String get reminderTitle;

  /// No description provided for @reminderBody.
  ///
  /// In pl, this message translates to:
  /// **'Chwila na refleksję — jeśli masz ochotę.'**
  String get reminderBody;

  /// No description provided for @reminderDenied.
  ///
  /// In pl, this message translates to:
  /// **'Brak zgody na powiadomienia. Możesz ją nadać w ustawieniach systemu.'**
  String get reminderDenied;

  /// No description provided for @proStoreNote.
  ///
  /// In pl, this message translates to:
  /// **'Płatność i ewentualne zwroty obsługuje App Store lub Google Play zgodnie ze swoimi zasadami. Zakup działa niezależnie od zgody na reklamy.'**
  String get proStoreNote;

  /// No description provided for @horoscopeToday.
  ///
  /// In pl, this message translates to:
  /// **'Dziś'**
  String get horoscopeToday;

  /// No description provided for @horoscopeStars.
  ///
  /// In pl, this message translates to:
  /// **'Gwiazdy mówią'**
  String get horoscopeStars;

  /// No description provided for @horoscopeCaution.
  ///
  /// In pl, this message translates to:
  /// **'Uważaj'**
  String get horoscopeCaution;

  /// No description provided for @moonIn.
  ///
  /// In pl, this message translates to:
  /// **'Księżyc w {sign}, {phase}.'**
  String moonIn(String sign, String phase);

  /// No description provided for @luckyNumbers.
  ///
  /// In pl, this message translates to:
  /// **'Szczęśliwe liczby dnia'**
  String get luckyNumbers;

  /// No description provided for @luckyNote.
  ///
  /// In pl, this message translates to:
  /// **'Dla zabawy: liczby wynikają z Twojej daty urodzenia i dzisiejszej daty, więc są stałe przez cały dzień. Nie przewidują wygranych.'**
  String get luckyNote;

  /// No description provided for @whyThis.
  ///
  /// In pl, this message translates to:
  /// **'Z czego to wynika'**
  String get whyThis;

  /// No description provided for @whySign.
  ///
  /// In pl, this message translates to:
  /// **'Twój znak: {sign} ({dates}), żywioł: {element}. Chiński znak: {chinese} — {chineseText}'**
  String whySign(
    String sign,
    String dates,
    String element,
    String chinese,
    String chineseText,
  );

  /// No description provided for @whyMoon.
  ///
  /// In pl, this message translates to:
  /// **'Dziś w południe Księżyc jest w znaku {sign} (żywioł: {element}). Relacja z Twoim żywiołem: {relation, select, same{ten sam żywioł} supportive{wspierająca} tense{napięta} other{neutralna}}.'**
  String whyMoon(String sign, String element, String relation);

  /// No description provided for @whyMethod.
  ///
  /// In pl, this message translates to:
  /// **'Położenie Księżyca liczymy wzorami astronomicznymi, bez internetu (dokładność ok. 0,5°). Tekst „Dziś” zależy od relacji żywiołów, „Gwiazdy mówią” od fazy Księżyca, a „Uważaj” od Twojej liczby dnia.'**
  String get whyMethod;

  /// No description provided for @horoscopeNeedsBirth.
  ///
  /// In pl, this message translates to:
  /// **'Zapisz datę urodzenia w zakładce Liczby (przycisk „Zapisz jako profil”), a zobaczysz tu horoskop na dziś, liczbę dnia i szczęśliwe liczby.'**
  String get horoscopeNeedsBirth;

  /// No description provided for @moonToday.
  ///
  /// In pl, this message translates to:
  /// **'Księżyc dziś'**
  String get moonToday;

  /// No description provided for @moonState.
  ///
  /// In pl, this message translates to:
  /// **'{phase} · oświetlenie {percent}% · w {sign}'**
  String moonState(String phase, int percent, String sign);

  /// No description provided for @moonCalendar.
  ///
  /// In pl, this message translates to:
  /// **'Kalendarz Księżyca'**
  String get moonCalendar;

  /// No description provided for @moonCalendarIntro.
  ///
  /// In pl, this message translates to:
  /// **'Najbliższe główne fazy Księżyca, czas lokalny (dokładność ok. 1 godziny).'**
  String get moonCalendarIntro;

  /// No description provided for @compatibility.
  ///
  /// In pl, this message translates to:
  /// **'Zgodność dwóch osób'**
  String get compatibility;

  /// No description provided for @compatIntro.
  ///
  /// In pl, this message translates to:
  /// **'Wpisz daty urodzenia dwóch osób. Porównamy znaki zodiaku, żywioły, znaki chińskie i liczby drogi życia. To zabawa i pretekst do rozmowy, nie ocena związku.'**
  String get compatIntro;

  /// No description provided for @personDate.
  ///
  /// In pl, this message translates to:
  /// **'Data urodzenia — osoba {n}'**
  String personDate(int n);

  /// No description provided for @check.
  ///
  /// In pl, this message translates to:
  /// **'Sprawdź'**
  String get check;

  /// No description provided for @compatElements.
  ///
  /// In pl, this message translates to:
  /// **'Żywioły'**
  String get compatElements;

  /// No description provided for @personLine.
  ///
  /// In pl, this message translates to:
  /// **'Osoba {n}: {sign} ({element}) · chiński znak: {chinese} · droga życia {lifePath}'**
  String personLine(
    int n,
    String sign,
    String element,
    String chinese,
    int lifePath,
  );

  /// No description provided for @birthCardTitle.
  ///
  /// In pl, this message translates to:
  /// **'Karta urodzenia'**
  String get birthCardTitle;

  /// No description provided for @birthCardNote.
  ///
  /// In pl, this message translates to:
  /// **'Metoda: dzień + miesiąc + rok urodzenia, sumujemy cyfry, aż wynik będzie nie większy niż 22 (22 = Głupiec). Wynik dwucyfrowy daje też kartę towarzyszącą.'**
  String get birthCardNote;

  /// No description provided for @birthCardSecond.
  ///
  /// In pl, this message translates to:
  /// **'Karta towarzysząca'**
  String get birthCardSecond;

  /// No description provided for @yesNoAnswer.
  ///
  /// In pl, this message translates to:
  /// **'{a, select, yes{Odpowiedź kart: TAK} no{Odpowiedź kart: NIE} other{Odpowiedź kart: NIEJASNA — sprawa jeszcze się waży}}'**
  String yesNoAnswer(String a);

  /// No description provided for @horoscopeFor.
  ///
  /// In pl, this message translates to:
  /// **'Dziś dla Ciebie'**
  String get horoscopeFor;

  /// No description provided for @licenses.
  ///
  /// In pl, this message translates to:
  /// **'Licencje (czcionki i biblioteki)'**
  String get licenses;

  /// No description provided for @cardAdvice.
  ///
  /// In pl, this message translates to:
  /// **'Rada karty'**
  String get cardAdvice;

  /// No description provided for @correspondences.
  ///
  /// In pl, this message translates to:
  /// **'Korespondencje astrologiczne (Złoty Brzask, XIX w.)'**
  String get correspondences;

  /// No description provided for @chooseSpread.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz rozkład'**
  String get chooseSpread;

  /// No description provided for @tapDeck.
  ///
  /// In pl, this message translates to:
  /// **'Zadaj pytanie w myślach i dotknij talii'**
  String get tapDeck;

  /// No description provided for @spreadCards.
  ///
  /// In pl, this message translates to:
  /// **'{n, plural, one{1 karta} few{{n} karty} many{{n} kart} other{{n} kart}}'**
  String spreadCards(int n);

  /// No description provided for @bigThree.
  ///
  /// In pl, this message translates to:
  /// **'Twoja wielka trójka'**
  String get bigThree;

  /// No description provided for @bigThreeIntro.
  ///
  /// In pl, this message translates to:
  /// **'Słońce to Twój znak zodiaku. Księżyc opisuje emocje, a ascendent — to, jak widzą Cię inni. Do Księżyca zwykle wystarczy data, do ascendentu potrzebna jest godzina i miejsce urodzenia. Dane zostają tylko na tym urządzeniu.'**
  String get bigThreeIntro;

  /// No description provided for @birthTime.
  ///
  /// In pl, this message translates to:
  /// **'Godzina urodzenia'**
  String get birthTime;

  /// No description provided for @notGiven.
  ///
  /// In pl, this message translates to:
  /// **'nie podano'**
  String get notGiven;

  /// No description provided for @birthPlace.
  ///
  /// In pl, this message translates to:
  /// **'Miejsce urodzenia'**
  String get birthPlace;

  /// No description provided for @placesNote.
  ///
  /// In pl, this message translates to:
  /// **'Miasta w Polsce i największe miasta za granicą. Jeśli Twojego nie ma, wybierz najbliższe w tym samym kraju albo podaj współrzędne — kilkadziesiąt kilometrów zmienia ascendent o mniej niż 1°.'**
  String get placesNote;

  /// No description provided for @sunLabel.
  ///
  /// In pl, this message translates to:
  /// **'Słońce'**
  String get sunLabel;

  /// No description provided for @moonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Księżyc'**
  String get moonLabel;

  /// No description provided for @ascLabel.
  ///
  /// In pl, this message translates to:
  /// **'Ascendent'**
  String get ascLabel;

  /// No description provided for @moonTwoSigns.
  ///
  /// In pl, this message translates to:
  /// **'Tego dnia Księżyc zmieniał znak: {a} albo {b} — zależy od godziny urodzenia.'**
  String moonTwoSigns(String a, String b);

  /// No description provided for @ascNeeds.
  ///
  /// In pl, this message translates to:
  /// **'Podaj godzinę i miejsce urodzenia, aby obliczyć ascendent.'**
  String get ascNeeds;

  /// No description provided for @traceTime.
  ///
  /// In pl, this message translates to:
  /// **'Czas lokalny {local} → {utc} UTC (strefa {zone}, z historią czasu letniego).'**
  String traceTime(String local, String utc, String zone);

  /// No description provided for @traceMoon.
  ///
  /// In pl, this message translates to:
  /// **'Długość ekliptyczna Księżyca: {deg}° → {sign}.'**
  String traceMoon(String deg, String sign);

  /// No description provided for @traceAsc.
  ///
  /// In pl, this message translates to:
  /// **'Ascendent: {deg}° → {sign} ({place}, {lat}° N, {lon}° E).'**
  String traceAsc(
    String deg,
    String sign,
    String place,
    String lat,
    String lon,
  );

  /// No description provided for @needBirthDate.
  ///
  /// In pl, this message translates to:
  /// **'Najpierw zapisz datę urodzenia w zakładce Liczby (przycisk „Zapamiętaj jako mój profil”).'**
  String get needBirthDate;

  /// No description provided for @clear.
  ///
  /// In pl, this message translates to:
  /// **'Wyczyść'**
  String get clear;

  /// No description provided for @chineseTitle.
  ///
  /// In pl, this message translates to:
  /// **'Horoskop chiński'**
  String get chineseTitle;

  /// No description provided for @chineseBirthYear.
  ///
  /// In pl, this message translates to:
  /// **'Rok według kalendarza chińskiego: {year} · {element} · {yy, select, yang{yang} other{yin}}'**
  String chineseBirthYear(int year, String element, String yy);

  /// No description provided for @chineseNewYearNote.
  ///
  /// In pl, this message translates to:
  /// **'Chiński Nowy Rok wypada między 21 stycznia a 20 lutego. Jeśli urodziłeś(-aś) przed nim, należysz do znaku poprzedniego roku — tu jest to już uwzględnione.'**
  String get chineseNewYearNote;

  /// No description provided for @chineseCurrentYear.
  ///
  /// In pl, this message translates to:
  /// **'Rok {year}: {animal} · {element}'**
  String chineseCurrentYear(int year, String animal, String element);

  /// No description provided for @chineseYearSince.
  ///
  /// In pl, this message translates to:
  /// **'Obecny rok chiński trwa od {date}.'**
  String chineseYearSince(String date);

  /// No description provided for @chineseCompatTitle.
  ///
  /// In pl, this message translates to:
  /// **'Zgodność znaków chińskich'**
  String get chineseCompatTitle;

  /// No description provided for @chineseFriend.
  ///
  /// In pl, this message translates to:
  /// **'Tajemny przyjaciel'**
  String get chineseFriend;

  /// No description provided for @chineseTrine.
  ///
  /// In pl, this message translates to:
  /// **'Trójka sprzymierzeńców'**
  String get chineseTrine;

  /// No description provided for @chineseClash.
  ///
  /// In pl, this message translates to:
  /// **'Znak przeciwny'**
  String get chineseClash;

  /// No description provided for @chineseElement.
  ///
  /// In pl, this message translates to:
  /// **'Żywioł roku urodzenia'**
  String get chineseElement;

  /// No description provided for @mercuryRetro.
  ///
  /// In pl, this message translates to:
  /// **'Merkury wsteczny'**
  String get mercuryRetro;

  /// No description provided for @mercuryNow.
  ///
  /// In pl, this message translates to:
  /// **'Merkury wsteczny do {date}'**
  String mercuryNow(String date);

  /// No description provided for @mercuryNone.
  ///
  /// In pl, this message translates to:
  /// **'W najbliższym roku brak okresów wstecznych.'**
  String get mercuryNone;

  /// No description provided for @upcomingPhases.
  ///
  /// In pl, this message translates to:
  /// **'Najbliższe fazy'**
  String get upcomingPhases;

  /// No description provided for @dayByDay.
  ///
  /// In pl, this message translates to:
  /// **'Dzień po dniu (30 dni)'**
  String get dayByDay;

  /// No description provided for @moonDayLine.
  ///
  /// In pl, this message translates to:
  /// **'Księżyc w {sign} · {phase}'**
  String moonDayLine(String sign, String phase);

  /// No description provided for @dreams.
  ///
  /// In pl, this message translates to:
  /// **'Sennik'**
  String get dreams;

  /// No description provided for @dreamsCount.
  ///
  /// In pl, this message translates to:
  /// **'{n} symboli snów — co sen może mówić o Tobie'**
  String dreamsCount(int n);

  /// No description provided for @dreamsIntro.
  ///
  /// In pl, this message translates to:
  /// **'Sny nie przepowiadają przyszłości. Sennik podpowiada, z czym dany symbol bywa kojarzony, a pytanie pomaga sprawdzić, co znaczy właśnie dla Ciebie. Najważniejsze jest to, co czułeś(-aś) we śnie.'**
  String get dreamsIntro;

  /// No description provided for @dreamsSearch.
  ///
  /// In pl, this message translates to:
  /// **'Szukaj symbolu, np. woda, zęby, dom'**
  String get dreamsSearch;

  /// No description provided for @dreamsEmpty.
  ///
  /// In pl, this message translates to:
  /// **'Nie ma takiego symbolu. Spróbuj podobnego słowa — albo zapisz sen w dzienniku.'**
  String get dreamsEmpty;

  /// No description provided for @chineseSignButton.
  ///
  /// In pl, this message translates to:
  /// **'Znak chiński: {animal}'**
  String chineseSignButton(String animal);

  /// No description provided for @otherPlace.
  ///
  /// In pl, this message translates to:
  /// **'Inne miejsce — podaj współrzędne'**
  String get otherPlace;

  /// No description provided for @otherPlaceSet.
  ///
  /// In pl, this message translates to:
  /// **'Inne miejsce: {place} ({zone})'**
  String otherPlaceSet(String place, String zone);

  /// No description provided for @otherPlaceHelp.
  ///
  /// In pl, this message translates to:
  /// **'Współrzędne znajdziesz w mapach (np. kliknij miejsce w Mapach Google). Południe i zachód wpisuj ze znakiem minus. Strefa czasowa to region, np. Europe/London, America/Chicago.'**
  String get otherPlaceHelp;

  /// No description provided for @latitude.
  ///
  /// In pl, this message translates to:
  /// **'Szerokość geograficzna'**
  String get latitude;

  /// No description provided for @longitude.
  ///
  /// In pl, this message translates to:
  /// **'Długość geograficzna'**
  String get longitude;

  /// No description provided for @timeZone.
  ///
  /// In pl, this message translates to:
  /// **'Strefa czasowa'**
  String get timeZone;

  /// No description provided for @otherPlaceMissing.
  ///
  /// In pl, this message translates to:
  /// **'Uzupełnij szerokość, długość i strefę czasową.'**
  String get otherPlaceMissing;

  /// No description provided for @otherPlaceRange.
  ///
  /// In pl, this message translates to:
  /// **'Szerokość musi być między -66° a 66° (za kołem podbiegunowym ascendent bywa nieokreślony), długość między -180° a 180°.'**
  String get otherPlaceRange;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
