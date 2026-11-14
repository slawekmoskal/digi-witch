// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Digi Witch';

  @override
  String get tabToday => 'Vandaag';

  @override
  String get tabNumerology => 'Getallen';

  @override
  String get tabTarot => 'Tarot';

  @override
  String get tabLibrary => 'Bibliotheek';

  @override
  String get tabJournal => 'Dagboek';

  @override
  String get settings => 'Instellingen';

  @override
  String get start => 'Laten we beginnen';

  @override
  String get onboardWhat =>
      'Je dagelijkse gids door symbolen: de horoscoop van vandaag, de Maan, tarot, numerologie, je Chinese teken en een droomwoordenboek. Elke berekening zie je stap voor stap, en elke kaart wordt in de bibliotheek uitgelegd.';

  @override
  String get onboardNot =>
      'Dit is een hulpmiddel voor vermaak, het leren kennen van symboliek en zelfreflectie. Het voorspelt de toekomst niet, meet geen persoonlijkheid in wetenschappelijke zin en vervangt geen professioneel advies.';

  @override
  String get onboardPrivacy =>
      'Je hebt geen account nodig. Data, namen en je dagboek blijven op dit apparaat.';

  @override
  String get onboardAdults => 'Deze app is bedoeld voor volwassenen.';

  @override
  String get reversed => 'omgekeerd';

  @override
  String get writeReflection => 'Schrijf een reflectie in je dagboek';

  @override
  String get exportJournal => 'Dagboek exporteren';

  @override
  String get newEntry => 'Nieuw bericht';

  @override
  String get editEntry => 'Bericht';

  @override
  String get journalEmpty =>
      'Je dagboek is leeg. Schrijf een eerste gedachte op. Je kunt beginnen met de vraag van de dag of een kaart die je hebt getrokken.';

  @override
  String get journalPrivacy =>
      'Berichten worden alleen op dit apparaat bewaard.';

  @override
  String get deleteEntryConfirm =>
      'Dit bericht verwijderen? Dit kan niet ongedaan worden gemaakt.';

  @override
  String get cancel => 'Annuleren';

  @override
  String get delete => 'Verwijderen';

  @override
  String get save => 'Opslaan';

  @override
  String get linkedResult => 'Gekoppeld resultaat';

  @override
  String get promptsTitle => 'Een vraag om mee te beginnen (optioneel)';

  @override
  String promptCategory(String c) {
    String _temp0 = intl.Intl.selectLogic(c, {
      'ogolne': 'Algemeen',
      'rodzina': 'Familie',
      'tarot': 'Tarot',
      'liczby': 'Getallen',
      'other': 'Overig',
    });
    return '$_temp0';
  }

  @override
  String get randomPrompt => 'Kies een willekeurige vraag';

  @override
  String get familyNote =>
      'Schrijf alleen over wat je prettig vindt om te delen. Je kunt bijnamen gebruiken in plaats van de namen van je dierbaren.';

  @override
  String get entryHint => 'Je gedachten…';

  @override
  String get tarotIntro =>
      'We zien de kaarten als aanleiding tot reflectie, niet als voorspelling. De posities in een legging zijn vragen die het waard zijn jezelf te stellen.';

  @override
  String get drawCards => 'Kaarten trekken';

  @override
  String get drawAgain => 'Opnieuw trekken';

  @override
  String get reversedOn =>
      'Omgekeerde kaarten: aan (elke kaart los van de andere, met 1 kans op 2).';

  @override
  String get reversedOff =>
      'Omgekeerde kaarten: uit. Je kunt ze aanzetten in Instellingen.';

  @override
  String get spreadReflectionPrompt =>
      'Wat raakte me het meest in deze legging, en waarom?';

  @override
  String get questionLabel => 'Je vraag (optioneel)';

  @override
  String get questionHint =>
      'bijv. Waar moet ik aan denken als ik van baan verander?';

  @override
  String get readingTitle => 'Wat de kaarten zeggen over je vraag';

  @override
  String get readingTitleNoQuestion => 'Samenvatting van de legging';

  @override
  String get summaryMajors =>
      'De Grote Arcana domineren: dit raakt iets belangrijks, groter dan alledaagse beslissingen.';

  @override
  String summarySuit(String suit) {
    String _temp0 = intl.Intl.selectLogic(suit, {
      'wands': 'Vooral Staven: energie, handelen en initiatief spelen op de achtergrond.',
      'cups': 'Vooral Bekers: emoties, gevoelens en relaties spelen op de achtergrond.',
      'swords': 'Vooral Zwaarden: gedachten, beslissingen en moeilijke gesprekken spelen op de achtergrond.',
      'pentacles': 'Vooral Pentakels: werk, geld en praktische zaken spelen op de achtergrond.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get summaryReversed =>
      'De meeste kaarten liggen omgekeerd: er kan iets geblokkeerd of vertraagd zijn, of meer van binnen dan van buiten worden beleefd.';

  @override
  String get summaryBalanced =>
      'De kaarten zijn gelijkmatig verdeeld: geen enkel gebied domineert duidelijk.';

  @override
  String summaryAnswer(String position, String card, String advice) {
    return 'Het antwoord van de kaarten: $card op de positie “$position”: $advice';
  }

  @override
  String get addBookmark => 'Bladwijzer toevoegen';

  @override
  String get removeBookmark => 'Bladwijzer verwijderen';

  @override
  String get group => 'Groep';

  @override
  String get keywords => 'Trefwoorden';

  @override
  String get symbolism => 'Symboliek';

  @override
  String get upright => 'Betekenis rechtop';

  @override
  String get reversedMeaning => 'Betekenis omgekeerd';

  @override
  String get reflectionQuestions => 'Vragen om over na te denken';

  @override
  String get reflectionQuestion => 'Vraag om over na te denken';

  @override
  String get sourcesAndRights => 'Bronnen en rechten';

  @override
  String get cardSourceNote =>
      'De kaartbeschrijvingen zijn originele teksten, geschreven voor deze app. Illustratie: Pamela Colman Smith (1878–1951), spel uitgegeven in 1909, publiek domein; scan van een exemplaar “Roses & Lilies” (Saskia Jansen), gedeeld op Wikimedia Commons. De afbeelding is alleen van grootte veranderd.';

  @override
  String get numerologyIntro =>
      'Vul je geboortedatum in en, als je wilt, je volledige naam. Opgeslagen als je profiel ontgrendelen ze de horoscoop van vandaag, je dagnummer, je grote drie en je Chinese teken. De gegevens blijven alleen op deze telefoon.';

  @override
  String get birthDate => 'Geboortedatum';

  @override
  String get birthDateHelp =>
      'Alleen cijfers: dag, maand, jaar, bijv. 15071990';

  @override
  String get fullNameOptional => 'Volledige naam (optioneel)';

  @override
  String get fullNameHelp =>
      'Alleen nodig voor de getallen die op letters zijn gebaseerd. Letters met accenten of trema (ë, é, ï, ö, ü) tellen als hun basisletter; “ij” is gewoon i en j. Ook Poolse, Duitse, Franse en Spaanse letters worden ondersteund; spaties, koppeltekens en apostroffen worden overgeslagen.';

  @override
  String get personalYearFor => 'Persoonlijk jaar voor:';

  @override
  String get previousYear => 'Vorig jaar';

  @override
  String get nextYear => 'Volgend jaar';

  @override
  String get calculate => 'Berekenen';

  @override
  String get saveAsProfile => 'Opslaan als mijn profiel';

  @override
  String get profileSaved => 'Opgeslagen op dit apparaat.';

  @override
  String get portrait => 'Numerologisch portret';

  @override
  String get portraitNote =>
      'Klap een getal open om de berekening en de symbolische duiding te zien. De uitkomsten volgen de conventie die in de Bibliotheek wordt beschreven (“Zo rekenen we in deze app”).';

  @override
  String indicatorName(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'lifePath': 'Levenspad',
      'birthDay': 'Geboortedaggetal',
      'expression': 'Expressiegetal',
      'soulUrge': 'Zielsgetal',
      'personality': 'Persoonlijkheidsgetal',
      'personalYear': 'Persoonlijk jaar',
      'personalDay': 'Dagnummer',
      'relation': 'Relatiegetal',
      'personalMonth': 'Persoonlijke maand',
      'maturity': 'Rijpheidsgetal',
      'house': 'Huisnummer',
      'other': 'Getal',
    });
    return '$_temp0';
  }

  @override
  String get noBasis => 'Niets om te berekenen';

  @override
  String get calculation => 'Berekening';

  @override
  String get symbolicInterpretation => 'Symbolische duiding';

  @override
  String get enterDateOrName =>
      'Vul een geboortedatum of een volledige naam in.';

  @override
  String get dateInvalid =>
      'Die datum bestaat niet. Controleer de dag en maand.';

  @override
  String get dateFuture => 'De datum mag niet in de toekomst liggen.';

  @override
  String get nameNoLetters => 'Vul minstens één letter in.';

  @override
  String nameUnsupported(String chars) {
    return 'Niet-ondersteunde tekens: $chars. Vul de spelling in het Latijnse alfabet (een transliteratie) in die je voor de berekening wilt gebruiken.';
  }

  @override
  String get cardOfDay => 'Dagkaart';

  @override
  String get cardOfDayNote =>
      'De dagkaart blijft hetzelfde tot het einde van de dag volgens de klok van dit apparaat.';

  @override
  String get promptOfDay => 'Vraag van de dag';

  @override
  String yourPersonalYear(int year) {
    final intl.NumberFormat yearNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String yearString = yearNumberFormat.format(year);

    return 'Je persoonlijke jaar $yearString';
  }

  @override
  String get search => 'Zoek kaarten, termen, artikelen';

  @override
  String get bookmarks => 'Bladwijzers';

  @override
  String get articles => 'Artikelen';

  @override
  String cardsCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Kaarten ($n)',
      one: 'Kaart (1)',
    );
    return '$_temp0';
  }

  @override
  String get archetypes => 'Archetypen';

  @override
  String get archetypesNote =>
      'De 12 archetypen zijn het eigen redactionele model van deze app: een van de vele mogelijke indelingen, geen canon en geen psychologische test.';

  @override
  String get aboutModel => 'Over het model';

  @override
  String get archetypeGifts => 'Gaven';

  @override
  String get archetypeShadow => 'Schaduw';

  @override
  String get glossary => 'Woordenlijst';

  @override
  String get theme => 'Thema';

  @override
  String get themeSystem => 'Systeem';

  @override
  String get themeLight => 'Licht';

  @override
  String get themeDark => 'Donker';

  @override
  String get allowReversed => 'Omgekeerde kaarten';

  @override
  String get allowReversedRule =>
      'Als dit aan staat, is elke getrokken kaart los van de andere met 1 kans op 2 omgekeerd.';

  @override
  String get profile => 'Mijn profiel';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyBody =>
      'We maken geen accounts aan en sturen je data, namen of berichten niet naar een server. Je gegevens staan alleen op dit apparaat, tenzij je ze zelf exporteert.';

  @override
  String get deleteAllTitle => 'Alle gegevens verwijderen';

  @override
  String get deleteAllBody =>
      'We verwijderen je dagboek, profiel, bladwijzers, dagkaart en instellingen van dit apparaat. Dit kan niet ongedaan worden gemaakt.';

  @override
  String get sourcesBody =>
      'De duidingen, vragen, archetypen en artikelen zijn originele teksten. Kaartillustraties: Pamela Colman Smith, spel uit 1909 (publiek domein), scans van Wikimedia Commons; details staan bij elke kaart. Historische bronnen staan aan het eind van de artikelen.';

  @override
  String get purchases => 'Digi Witch Pro';

  @override
  String get help => 'Hulp';

  @override
  String get helpBody =>
      'Zit je in een crisis, neem dan contact op met je huisarts, een hulpverlener of een hulplijn, bijvoorbeeld 113 Zelfmoordpreventie (bel 113 of 0800-0113, dag en nacht bereikbaar). Bel bij nood 112.';

  @override
  String get versions => 'Versies';

  @override
  String get algorithm => 'algoritme';

  @override
  String get contentVer => 'inhoud';

  @override
  String get disclaimer =>
      'Deze inhoud is bedoeld voor vermaak, educatie en zelfreflectie. Het is geen medisch, psychologisch, juridisch of financieel advies.';

  @override
  String get proShort =>
      'Eenmalige aankoop: geen advertenties, extra leggingen.';

  @override
  String get proTitle => 'Digi Witch Pro';

  @override
  String get proBenefits =>
      '• Nergens in de app advertenties\n• Extra leggingen: “Relatie” (6 kaarten) en “Reflectiekruis” (10 kaarten)\n• Eenmalige betaling, geen abonnement';

  @override
  String get proFreeStays =>
      'Numerologie, de dagkaart, de leggingen met 1, 3 en 5 kaarten, de bibliotheek en het dagboek blijven gratis. Pro kopen heeft geen invloed op welke kaarten worden getrokken of hoe uitkomsten worden berekend.';

  @override
  String get proActive => 'Je hebt Pro. Bedankt!';

  @override
  String get proUnavailable =>
      'Kopen is nu niet mogelijk. Controleer je internetverbinding en probeer het later opnieuw.';

  @override
  String proBuy(String price) {
    return 'Koop Pro voor $price';
  }

  @override
  String get purchaseError =>
      'De aankoop is niet voltooid. Er is niets van je afgeschreven, tenzij de winkel de transactie heeft bevestigd.';

  @override
  String get restorePurchases => 'Aankopen herstellen';

  @override
  String get proOnly => 'Beschikbaar in Pro';

  @override
  String get adPrivacyOptions => 'Privacyinstellingen voor advertenties';

  @override
  String get reminder => 'Dagelijkse herinnering';

  @override
  String get reminderOff => 'Uit';

  @override
  String reminderAt(String time) {
    return 'Elke dag om $time';
  }

  @override
  String get reminderTitle => 'Digi Witch';

  @override
  String get reminderBody =>
      'Een moment om te reflecteren, als je er zin in hebt.';

  @override
  String get reminderDenied =>
      'Meldingen zijn niet toegestaan. Je kunt ze toestaan in de systeeminstellingen.';

  @override
  String get proStoreNote =>
      'Betaling en eventuele terugbetalingen worden afgehandeld door de App Store of Google Play volgens hun eigen regels. De aankoop werkt, of je nu toestemming voor advertenties geeft of niet.';

  @override
  String get horoscopeToday => 'Vandaag';

  @override
  String get horoscopeStars => 'De sterren zeggen';

  @override
  String get horoscopeCaution => 'Let op';

  @override
  String moonIn(String sign, String phase) {
    return 'Maan in $sign, $phase.';
  }

  @override
  String get luckyNumbers => 'Geluksgetallen van de dag';

  @override
  String get luckyNote =>
      'Voor de lol: de getallen komen uit je geboortedatum en de datum van vandaag, dus ze blijven de hele dag hetzelfde. Ze voorspellen geen winst.';

  @override
  String get whyThis => 'Waar dit vandaan komt';

  @override
  String whySign(
    String sign,
    String dates,
    String element,
    String chinese,
    String chineseText,
  ) {
    return 'Je teken: $sign ($dates), element: $element. Chinees teken: $chinese. $chineseText';
  }

  @override
  String whyMoon(String sign, String element, String relation) {
    String _temp0 = intl.Intl.selectLogic(relation, {
      'same': 'hetzelfde element',
      'supportive': 'ondersteunend',
      'tense': 'gespannen',
      'other': 'neutraal',
    });
    return 'Vandaag staat de Maan om twaalf uur ’s middags in $sign (element: $element). Verhouding tot jouw element: $_temp0.';
  }

  @override
  String get whyMethod =>
      'De positie van de Maan wordt offline berekend met astronomische formules (nauwkeurig tot ongeveer 0,5°). De tekst bij “Vandaag” hangt af van de verhouding tussen de elementen, “De sterren zeggen” van de maanfase en “Let op” van je dagnummer.';

  @override
  String get horoscopeNeedsBirth =>
      'Vul je geboortedatum in en je ziet meteen je teken, de horoscoop van vandaag, je dagnummer en je geluksgetallen.';

  @override
  String get moonToday => 'De Maan vandaag';

  @override
  String moonState(String phase, int percent, String sign) {
    return '$phase · $percent% verlicht · in $sign';
  }

  @override
  String get moonCalendar => 'Maankalender';

  @override
  String get moonCalendarIntro =>
      'De eerstvolgende hoofdfasen van de Maan, in lokale tijd (nauwkeurig tot ongeveer 1 uur).';

  @override
  String get compatibility => 'Compatibiliteit van twee mensen';

  @override
  String get compatIntro =>
      'Vul twee geboortedata in. We vergelijken sterrenbeelden, elementen, Chinese tekens en levenspadgetallen. Het is een beetje plezier en een gespreksopener, geen oordeel over een relatie.';

  @override
  String personDate(int n) {
    return 'Geboortedatum: persoon $n';
  }

  @override
  String get check => 'Vergelijken';

  @override
  String get compatElements => 'Elementen';

  @override
  String personLine(
    int n,
    String sign,
    String element,
    String chinese,
    int lifePath,
  ) {
    return 'Persoon $n: $sign ($element) · Chinees teken: $chinese · levenspad $lifePath';
  }

  @override
  String get birthCardTitle => 'Geboortekaart';

  @override
  String get birthCardNote =>
      'Methode: dag + maand + jaar van geboorte, daarna worden de cijfers opgeteld tot de uitkomst niet groter is dan 22 (22 = De Dwaas). Een tweecijferige uitkomst geeft ook een begeleidende kaart.';

  @override
  String get birthCardSecond => 'Begeleidende kaart';

  @override
  String yesNoAnswer(String a) {
    String _temp0 = intl.Intl.selectLogic(a, {
      'yes': 'Het antwoord van de kaarten: JA',
      'no': 'Het antwoord van de kaarten: NEE',
      'other': 'Het antwoord van de kaarten: ONDUIDELIJK. De zaak hangt nog in de balans',
    });
    return '$_temp0';
  }

  @override
  String get horoscopeFor => 'Vandaag voor jou';

  @override
  String get licenses => 'Licenties (lettertypen en bibliotheken)';

  @override
  String get cardAdvice => 'Het advies van de kaart';

  @override
  String get correspondences =>
      'Astrologische correspondenties (Golden Dawn, 19e eeuw)';

  @override
  String get chooseSpread => 'Kies een legging';

  @override
  String get tapDeck => 'Houd je vraag in gedachten en tik op het spel';

  @override
  String spreadCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n kaarten',
      one: '1 kaart',
    );
    return '$_temp0';
  }

  @override
  String get bigThree => 'Je grote drie';

  @override
  String get bigThreeIntro =>
      'De Zon is je sterrenbeeld. De Maan beschrijft je emoties en de ascendant hoe anderen je zien. Voor de Maan is de datum meestal genoeg; voor de ascendant heb je je geboortetijd en geboorteplaats nodig. De gegevens blijven alleen op dit apparaat.';

  @override
  String get birthTime => 'Geboortetijd';

  @override
  String get notGiven => 'niet opgegeven';

  @override
  String get birthPlace => 'Geboorteplaats';

  @override
  String get placesNote =>
      'Steden in Polen en grote steden in het buitenland. Staat de jouwe er niet bij, kies dan de dichtstbijzijnde in hetzelfde land of vul coördinaten in. Een paar tientallen kilometers veranderen de ascendant met minder dan 1°.';

  @override
  String get sunLabel => 'Zon';

  @override
  String get moonLabel => 'Maan';

  @override
  String get ascLabel => 'Ascendant';

  @override
  String moonTwoSigns(String a, String b) {
    return 'De Maan wisselde die dag van teken: $a of $b, afhankelijk van je geboortetijd.';
  }

  @override
  String get ascNeeds =>
      'Vul je geboortetijd en geboorteplaats in om de ascendant te berekenen.';

  @override
  String traceTime(String local, String utc, String zone) {
    return 'Lokale tijd $local → $utc UTC (zone $zone, met geschiedenis van zomertijd).';
  }

  @override
  String traceMoon(String deg, String sign) {
    return 'Eclipticale lengte van de Maan: $deg° → $sign.';
  }

  @override
  String traceAsc(
    String deg,
    String sign,
    String place,
    String lat,
    String lon,
  ) {
    return 'Ascendant: $deg° → $sign ($place, $lat° N, $lon° O).';
  }

  @override
  String get needBirthDate =>
      'Sla eerst je geboortedatum op in het tabblad Getallen (de knop “Opslaan als mijn profiel”).';

  @override
  String get clear => 'Wissen';

  @override
  String get chineseTitle => 'Chinese horoscoop';

  @override
  String chineseBirthYear(int year, String element, String yy) {
    String _temp0 = intl.Intl.selectLogic(yy, {'yang': 'yang', 'other': 'yin'});
    return 'Jaar in de Chinese kalender: $year · $element · $_temp0';
  }

  @override
  String get chineseNewYearNote =>
      'Chinees Nieuwjaar valt tussen 21 januari en 20 februari. Ben je daarvoor geboren, dan hoor je bij het teken van het vorige jaar. Daar is hier al rekening mee gehouden.';

  @override
  String chineseCurrentYear(int year, String animal, String element) {
    return 'Jaar $year: $animal · $element';
  }

  @override
  String chineseYearSince(String date) {
    return 'Het huidige Chinese jaar begon op $date.';
  }

  @override
  String get chineseCompatTitle => 'Compatibiliteit van Chinese tekens';

  @override
  String get chineseFriend => 'Geheime vriend';

  @override
  String get chineseTrine => 'Trio van bondgenoten';

  @override
  String get chineseClash => 'Tegenovergesteld teken';

  @override
  String get chineseElement => 'Element van het geboortejaar';

  @override
  String get mercuryRetro => 'Mercurius retrograde';

  @override
  String mercuryNow(String date) {
    return 'Mercurius retrograde tot $date';
  }

  @override
  String get mercuryNone => 'Geen retrograde periodes in het komende jaar.';

  @override
  String get upcomingPhases => 'Komende fasen';

  @override
  String get dayByDay => 'Dag voor dag (30 dagen)';

  @override
  String moonDayLine(String sign, String phase) {
    return 'Maan in $sign · $phase';
  }

  @override
  String get dreams => 'Droomwoordenboek';

  @override
  String dreamsCount(int n) {
    return '$n droomsymbolen: wat een droom je over jezelf kan vertellen';
  }

  @override
  String get dreamsIntro =>
      'Dromen voorspellen de toekomst niet. Het woordenboek geeft aan waarmee een symbool vaak wordt geassocieerd, en de vraag helpt je te toetsen wat het voor jou betekent. Het belangrijkst is hoe je je in de droom voelde.';

  @override
  String get dreamsSearch => 'Zoek een symbool, bijv. water, tanden, huis';

  @override
  String get dreamsEmpty =>
      'Dat symbool bestaat niet. Probeer een verwant woord, of schrijf de droom op in je dagboek.';

  @override
  String chineseSignButton(String animal) {
    return 'Chinees teken: $animal';
  }

  @override
  String get otherPlace => 'Andere plaats: vul coördinaten in';

  @override
  String otherPlaceSet(String place, String zone) {
    return 'Andere plaats: $place ($zone)';
  }

  @override
  String get otherPlaceHelp =>
      'Coördinaten vind je in een kaartapp (tik bijvoorbeeld op een plek in Google Maps). Vul zuid en west in met een minteken. De tijdzone is een regio, bijv. Europe/Amsterdam, America/Chicago.';

  @override
  String get latitude => 'Breedtegraad';

  @override
  String get longitude => 'Lengtegraad';

  @override
  String get timeZone => 'Tijdzone';

  @override
  String get otherPlaceMissing =>
      'Vul de breedtegraad, lengtegraad en tijdzone in.';

  @override
  String get otherPlaceRange =>
      'De breedtegraad moet tussen -66° en 66° liggen (voorbij de poolcirkels kan de ascendant ongedefinieerd zijn), de lengtegraad tussen -180° en 180°.';

  @override
  String get numbersStartTitle => 'Begin met je geboortedatum';

  @override
  String get numbersEditTitle =>
      'Gegevens wijzigen of voor iemand anders berekenen';

  @override
  String get calculateOnce => 'Alleen berekenen (zonder opslaan)';

  @override
  String get compatibilityHint => 'Vergelijk twee geboortedata';

  @override
  String get yourNumbers => 'Je getallen';

  @override
  String get editOrOther => 'Gegevens wijzigen of voor iemand anders berekenen';

  @override
  String get showMyHoroscope => 'Toon mijn horoscoop';

  @override
  String get privacyShort =>
      'De datum blijft alleen op deze telefoon. Je kunt hem wijzigen in het tabblad Getallen.';

  @override
  String get explore => 'Ontdekken';

  @override
  String get exploreBigThree => 'Zon, Maan en ascendant';

  @override
  String get exploreChinese => 'Teken, element en jouw jaar';

  @override
  String get exploreTarot => 'Vraag het de kaarten';

  @override
  String get exploreTarotSub => 'Leggingen en ja-of-nee-vragen';

  @override
  String get exploreNumbersSub => 'Levenspad en geboortekaart';

  @override
  String get exploreMoon => 'Fasen, tuinieren, Mercurius retrograde';

  @override
  String get exploreDreams => 'Wat je droom zegt';

  @override
  String get exploreLibrary =>
      '78 kaarten, artikelen, woordenlijst: in de Bibliotheek';

  @override
  String get exploreLibraryTitle => 'Kaarten en artikelen';

  @override
  String get squareTitle => 'Vierkant van Pythagoras';

  @override
  String get squareIntro =>
      'Een raster van de cijfers uit je geboortedatum (methode van Aleksandrov): hoe vaker een cijfer voorkomt, hoe sterker de eigenschap. Tik op een vak om de beschrijving te lezen.';

  @override
  String get squareEmpty => 'geen';

  @override
  String get cyclesTitle => 'Levenscycli: pieken en uitdagingen';

  @override
  String get cyclesIntro =>
      'De numerologie verdeelt het leven in vier fasen. Elke fase heeft een “piek”, een thema om te groeien, en een “uitdaging”, een les om door te werken. De lengte van de eerste fase hangt af van je levenspad.';

  @override
  String ageRange(int from, int to) {
    return 'leeftijd $from–$to';
  }

  @override
  String ageFrom(int from) {
    return 'vanaf $from jaar';
  }

  @override
  String get cyclesNow => 'NU';

  @override
  String get ichingTitle => 'I Tjing-orakel';

  @override
  String get ichingIntro =>
      'Het Boek der Veranderingen is een klassiek Chinees orakel. Denk aan je vraag en gooi dan zes keer drie munten; het hexagram wordt van onder naar boven opgebouwd. Lijnen met een stip zijn “veranderend” en tonen waarin de situatie overgaat.';

  @override
  String ichingToss(int n) {
    return 'Gooi de munten ($n/6)';
  }

  @override
  String ichingLastToss(String sum) {
    String _temp0 = intl.Intl.selectLogic(sum, {
      '6': 'munt, munt, munt = 6 (oude yin, veranderend)',
      '7': 'twee keer munt en een keer kop = 7 (yang)',
      '8': 'twee keer kop en een keer munt = 8 (yin)',
      'other': 'kop, kop, kop = 9 (oude yang, veranderend)',
    });
    return 'Laatste worp: $_temp0';
  }

  @override
  String get ichingMeaning => 'Betekenis';

  @override
  String get ichingChange => 'Richting van verandering';

  @override
  String ichingChangingLines(String lines) {
    return 'Veranderende lijnen: $lines. De situatie gaat over in:';
  }

  @override
  String get ichingAgain => 'Nieuwe vraag';

  @override
  String get ichingNote =>
      'De beschrijvingen van de hexagrammen en lijnen zijn korte eigen duidingen van deze app, geïnspireerd door de beelden van de oude Chinese tekst. Zie ze als aanleiding tot reflectie.';

  @override
  String get exploreIching => 'Een vraag en zes worpen met munten';

  @override
  String get ritualsTitle => 'Maanrituelen';

  @override
  String get exploreRituals => 'Intenties voor nieuwe en volle maan';

  @override
  String get ritualsIntro =>
      'De nieuwe en volle maan bepalen het ritme van de maand. Schrijf bij nieuwe maan een intentie op, en kijk bij volle maan terug op wat er is gebeurd. Je aantekeningen komen in je dagboek.';

  @override
  String get moonRemindersToggle => 'Herinner me aan nieuwe en volle maan';

  @override
  String get moonRemindersNote =>
      'Een melding om 9:00 op de dag van de nieuwe en volle maan. Werkt offline.';

  @override
  String get moonReminderNewTitle => 'Nieuwe maan: tijd voor een intentie';

  @override
  String get moonReminderNewBody =>
      'Schrijf op wat je in deze cyclus wilt beginnen.';

  @override
  String get moonReminderFullTitle => 'Volle maan: tijd om terug te kijken';

  @override
  String get moonReminderFullBody =>
      'Wat is er goed gegaan sinds de nieuwe maan? Waarvoor ben je dankbaar?';

  @override
  String get forYouToday => 'Speciaal voor jou';

  @override
  String get advice => 'Advies';

  @override
  String get karmicTitle => 'Karma in getallen';

  @override
  String get karmicIntro =>
      'Karmische schulden zijn de getallen 13, 14, 16 en 19 die opduiken onderweg naar je getallen. Karmische lessen zijn de cijfers die in je volledige naam ontbreken. In de traditie beschrijven ze thema\'s om door te werken, geen oordelen.';

  @override
  String get karmicNone => 'Geen karmische schulden in je getallen.';

  @override
  String get karmicLessonsTitle =>
      'Karmische lessen (cijfers die in je naam ontbreken)';

  @override
  String get houseTitle => 'Numerologie van huis en telefoon';

  @override
  String get houseHint => 'Huis-, flat- of telefoonnummer, bijv. 12A';

  @override
  String luckyMeaning(int n, int reduced, String keywords) {
    return '$n → $reduced: $keywords';
  }

  @override
  String dayColor(String color) {
    return 'Kleur van de dag: $color';
  }

  @override
  String signExtras(String color, String stone, String day, String planet) {
    return 'Kleur: $color · steen: $stone · dag: $day · planeet: $planet';
  }

  @override
  String get periodTitle => 'Horoscoop voor de week en de maand';

  @override
  String get explorePeriod => 'Sleuteldagen en je persoonlijke maand';

  @override
  String get periodIntro =>
      'Berekend uit de echte hemel: de maanfasen, verduisteringen, Mercurius retrograde, de Zon die het volgende teken binnengaat en de dagen waarop de Maan in jouw teken staat, plus je persoonlijke getallen.';

  @override
  String get tabWeek => 'Week';

  @override
  String get tabMonth => 'Maand';

  @override
  String get weekGeneral => 'Algemeen';

  @override
  String get keyDays => 'Sleuteldagen';

  @override
  String get noKeyDays =>
      'Er zijn in deze periode geen bijzondere gebeurtenissen aan de hemel. Een goede tijd voor rustig, regelmatig werk.';

  @override
  String evPhase(String phase) {
    return '$phase';
  }

  @override
  String evMoonInSign(String sign) {
    return 'Maan in jouw teken ($sign)';
  }

  @override
  String evSunIngress(String sign) {
    return 'De Zon gaat $sign binnen';
  }

  @override
  String get evMercuryStart => 'Mercurius wordt retrograde';

  @override
  String get evMercuryEnd => 'Mercurius wordt weer direct';

  @override
  String evEclipse(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'solar': 'Zonsverduistering',
      'partial': 'Maansverduistering (gedeeltelijk of totaal)',
      'other': 'Halfschaduw-maansverduistering (subtiel)',
    });
    return '$_temp0';
  }

  @override
  String dayNumberLine(int n, String title) {
    return 'Dagnummer $n: $title';
  }

  @override
  String get eclipsesTitle => 'Verduisteringen in het komende jaar';

  @override
  String get eclipseVisibility =>
      'Zichtbaarheid hangt af van waar je op aarde bent: niet elke verduistering is vanaf jouw locatie te zien.';

  @override
  String eclipseSoon(String when) {
    return 'Er komt een verduistering aan: $when';
  }

  @override
  String get loveLabel => 'Liefde';

  @override
  String get workLabel => 'Werk';

  @override
  String get wellbeingLabel => 'Welzijn';

  @override
  String ichingImage(String upper, String lower) {
    return 'Beeld: $upper boven $lower';
  }

  @override
  String get ichingLinesTitle => 'Veranderende lijnen';

  @override
  String ichingLine(int n, String text) {
    return 'Lijn $n: $text';
  }

  @override
  String get revealCard => 'Kaart omdraaien';

  @override
  String get revealCardHint => 'Tik op de kaart om te zien wat de dag brengt.';

  @override
  String get cardOfDayMore => 'Meer over de kaart';

  @override
  String get moodQuestion => 'Hoe voel je je vandaag?';

  @override
  String moodName(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      '1': 'Zwaar',
      '2': 'Laag',
      '3': 'Gaat wel',
      '4': 'Goed',
      'other': 'Super',
    });
    return '$_temp0';
  }

  @override
  String get moodSaved => 'Alleen op dit apparaat opgeslagen.';

  @override
  String countdown(String what, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'over $days dagen',
      one: 'morgen',
      zero: 'vandaag',
    );
    return '$what $_temp0';
  }

  @override
  String get yourBirthday => 'Je verjaardag';

  @override
  String notifMoon(String sign) {
    return 'Maan in $sign';
  }

  @override
  String notifDayNumber(int n) {
    return 'dagnummer $n';
  }

  @override
  String get notifCard => 'je dagkaart wacht op je';

  @override
  String get tabStars => 'Sterren';

  @override
  String get starsMore => 'Meer van de sterren';

  @override
  String get deckTitle => 'Het spel';

  @override
  String get fullHoroscope => 'Volledige horoscoop';

  @override
  String get upcoming => 'Binnenkort';

  @override
  String get suggested => 'Voorgesteld voor vandaag';

  @override
  String get suggestBigThree =>
      'Voeg je geboortetijd en geboorteplaats toe om je Maan en ascendant te ontdekken';

  @override
  String get dayNumberShort => 'dagnummer';

  @override
  String get dayColorShort => 'kleur van de dag';

  @override
  String get fullNumerology => 'Volledige numerologie en portret';

  @override
  String get firstEntry => 'Schrijf een eerste gedachte';

  @override
  String get greetDay => 'Goedemorgen';

  @override
  String get greetEvening => 'Goedenavond';

  @override
  String get dayHoroscope => 'Horoscoop';

  @override
  String get dayNumbers => 'Mijn getallen';

  @override
  String get dayCard => 'Kaart';

  @override
  String get dayDone => 'Alles gedaan voor vandaag.';

  @override
  String tomorrowIs(String what) {
    return 'Morgen: $what.';
  }

  @override
  String tomorrowMoon(String sign) {
    return 'Morgen: Maan in $sign.';
  }

  @override
  String tomorrowNumber(int n) {
    return 'Morgen: een nieuwe kaart en dagnummer $n.';
  }

  @override
  String get tomorrowCard => 'Morgen: een nieuwe dagkaart.';

  @override
  String get tabDreams => 'Dromen';

  @override
  String get dreamAsk => 'Wat heb je vannacht gedroomd?';

  @override
  String get dreamAskHint =>
      'Schrijf de droom op voordat hij vervaagt, of zoek hieronder een symbool op.';

  @override
  String get dreamSave => 'Schrijf de droom op';

  @override
  String get dreamEntry => 'Droom';

  @override
  String get dreamOfDay => 'Symbool van de dag';

  @override
  String get dreamsAll => 'Alle symbolen';

  @override
  String get widgetCardWaiting => 'Wacht om omgedraaid te worden';

  @override
  String get widgetStale => 'Tik om je dag te zien';

  @override
  String widgetCardSays(String advice) {
    return 'De kaart zegt: $advice';
  }

  @override
  String get widgetNeedBirth => 'Vul je geboortedatum in om je dag te zien.';

  @override
  String get language => 'Taal';

  @override
  String get dateHint => 'DD.MM.JJJJ';

  @override
  String get layTarot => 'Tarot leggen';

  @override
  String get tarotWelcomeTitle => 'Wat zullen de kaarten vandaag voorstellen?';

  @override
  String get tarotWelcomeBody =>
      'Denk aan wat je bezighoudt, kies een legging en draai de kaarten om. Elke legging is een nieuwe blik. Kom terug wanneer er een nieuwe vraag opkomt.';

  @override
  String get seeDeck => 'Bekijk het spel';

  @override
  String get tarotWelcomeSetting => 'Intro op het tabblad Tarot';

  @override
  String get hide => 'Verbergen';

  @override
  String get tapHint => 'tik';

  @override
  String get dailyMood => 'Hoe je je vandaag kunt voelen';

  @override
  String get dailyEvents => 'Wat de dag kan brengen';

  @override
  String get dailyAdvice => 'Advies voor vandaag';

  @override
  String get energyLabel => 'Energie';

  @override
  String meterValue(String label, int n) {
    return '$label: $n van 5';
  }

  @override
  String get cheerAll => 'Een mooie dag, de sterren staan aan je kant';

  @override
  String get cheerLove => 'Een goede dag voor het hart';

  @override
  String get cheerWork => 'Een goede dag om dingen gedaan te krijgen';

  @override
  String get cheerEnergy => 'Een dag vol energie';

  @override
  String get cheerUpLove => 'De liefde ziet er beter uit dan gisteren';

  @override
  String get cheerUpWork => 'Werk ziet er beter uit dan gisteren';

  @override
  String get cheerUpEnergy => 'Meer energie dan gisteren';

  @override
  String get cheerNewMoon =>
      'Nieuwe Maan, een goed moment voor een frisse intentie';

  @override
  String get cheerWaxing => 'De Maan neemt toe, en je plannen met haar';

  @override
  String get cheerFullMoon => 'Volle Maan, tijd om te waarderen wat je al hebt';

  @override
  String get cheerWaning =>
      'De Maan neemt af, makkelijker om los te laten wat je belast';

  @override
  String get cheerNewMoon2 =>
      'Nieuwe Maan, een schone bladzijde. Schrijf er iets goeds op';

  @override
  String get cheerNewMoon3 =>
      'Nieuwe Maan, de beste ideeën worden in stilte geboren';

  @override
  String get cheerWaxing2 =>
      'De Maan wast, een goede tijd om kleine stappen toe te voegen';

  @override
  String get cheerWaxing3 => 'De wassende Maan begunstigt wat je begint';

  @override
  String get cheerFullMoon2 =>
      'Volle Maan, je ziet vandaag meer. Ook wat goed ging';

  @override
  String get cheerFullMoon3 =>
      'Volle Maan, een goede avond om kleine dingen te vieren';

  @override
  String get cheerWaning2 =>
      'De Maan neemt af, een goede tijd om op te ruimen en adem te halen';

  @override
  String get cheerWaning3 => 'De afnemende Maan begunstigt rust en afmaken';

  @override
  String get threeGood => 'Schrijf drie goede dingen op';

  @override
  String get threeGoodPrompt =>
      'Drie goede dingen van deze week, en wat ze mogelijk maakte:';

  @override
  String moodReply(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      '1': 'Zware dagen komen voor. Je hoeft vandaag niets goed te maken.',
      '2': 'Ook een mindere dag is prima. Eén kleine stap is genoeg.',
      '3': 'Een gewone dag telt ook mee.',
      '4': 'Fijn om te horen.',
      'other': 'Mooi. Het is de moeite waard te onthouden wat het zo maakte.',
    });
    return '$_temp0';
  }

  @override
  String get reminderAsk => 'Wil je dat de dagkaart elke ochtend op je wacht?';

  @override
  String get reminderAskSub =>
      'Eén melding per dag om 8:00, met de inhoud van de dag. Wijzig de tijd of zet het uit in Instellingen.';

  @override
  String get reminderYes => 'Ja, herinner me';

  @override
  String get reminderNo => 'Nee, bedankt';

  @override
  String get onboardBirthHint =>
      'Optioneel. Met de datum zie je meteen je teken, horoscoop en getallen.';

  @override
  String get lookBack => 'Je dagen';

  @override
  String get lookBackHint =>
      'Dagkaarten en stemming, dag voor dag. Alleen op dit apparaat bewaard.';
}
