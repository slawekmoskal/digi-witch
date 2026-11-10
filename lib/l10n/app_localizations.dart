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
  /// **'Opisy kart są autorskimi tekstami tej aplikacji, inspirowanymi symboliką historycznej talii z 1909 r. (ilustracje Pamela Colman Smith, koncepcja A. E. Waite). Grafiki kart nie są jeszcze dołączone — pokazujemy symboliczny awers.'**
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
  /// **'{name, select, lifePath{Droga życia} birthDay{Liczba dnia urodzenia} expression{Liczba ekspresji} soulUrge{Liczba samogłosek} personality{Liczba spółgłosek} personalYear{Rok osobisty} other{Wskaźnik}}'**
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
  /// **'Wszystkie teksty interpretacji, pytania, archetypy i artykuły są autorskie. Źródła historyczne wymieniamy na końcu artykułów w Bibliotece.'**
  String get sourcesBody;

  /// No description provided for @purchases.
  ///
  /// In pl, this message translates to:
  /// **'Wersja Pro'**
  String get purchases;

  /// No description provided for @purchasesBody.
  ///
  /// In pl, this message translates to:
  /// **'Jeszcze niedostępna. Wszystkie obecne funkcje są bezpłatne.'**
  String get purchasesBody;

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
