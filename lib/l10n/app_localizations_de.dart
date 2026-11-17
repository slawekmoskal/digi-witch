// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Digi Witch';

  @override
  String get tabToday => 'Heute';

  @override
  String get tabNumerology => 'Zahlen';

  @override
  String get tabTarot => 'Tarot';

  @override
  String get tabLibrary => 'Bibliothek';

  @override
  String get tabJournal => 'Tagebuch';

  @override
  String get settings => 'Einstellungen';

  @override
  String get start => 'Los geht’s';

  @override
  String get onboardWhat =>
      'Dein täglicher Begleiter durch die Welt der Symbole: Tageshoroskop, Mond, Tarot, Numerologie, chinesisches Tierzeichen und ein Traumlexikon. Jede Berechnung wird Schritt für Schritt gezeigt, und jede Karte ist in der Bibliothek erklärt.';

  @override
  String get onboardNot =>
      'Diese App dient der Unterhaltung, dem Kennenlernen von Symbolik und der Selbstreflexion. Sie sagt nicht die Zukunft voraus, misst keine Persönlichkeit im wissenschaftlichen Sinn und ersetzt keine fachliche Beratung.';

  @override
  String get onboardPrivacy =>
      'Du brauchst kein Konto. Daten, Namen und dein Tagebuch bleiben auf diesem Gerät.';

  @override
  String get onboardAdults => 'Diese App richtet sich an Erwachsene.';

  @override
  String get reversed => 'umgekehrt';

  @override
  String get writeReflection => 'Gedanken im Tagebuch festhalten';

  @override
  String get exportJournal => 'Tagebuch exportieren';

  @override
  String get newEntry => 'Neuer Eintrag';

  @override
  String get editEntry => 'Eintrag';

  @override
  String get journalEmpty =>
      'Dein Tagebuch ist noch leer. Schreib einen ersten Gedanken auf – zum Beispiel zur Frage des Tages oder zu einer gezogenen Karte.';

  @override
  String get journalPrivacy =>
      'Einträge werden nur auf diesem Gerät gespeichert.';

  @override
  String get deleteEntryConfirm =>
      'Diesen Eintrag löschen? Das lässt sich nicht rückgängig machen.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get save => 'Speichern';

  @override
  String get linkedResult => 'Verknüpftes Ergebnis';

  @override
  String get promptsTitle => 'Eine Frage zum Einstieg (optional)';

  @override
  String promptCategory(String c) {
    String _temp0 = intl.Intl.selectLogic(c, {
      'ogolne': 'Allgemein',
      'rodzina': 'Familie',
      'tarot': 'Tarot',
      'liczby': 'Zahlen',
      'other': 'Sonstiges',
    });
    return '$_temp0';
  }

  @override
  String get randomPrompt => 'Zufällige Frage';

  @override
  String get familyNote =>
      'Schreib nur, was du teilen möchtest. Statt der Namen deiner Angehörigen kannst du auch Spitznamen verwenden.';

  @override
  String get entryHint => 'Deine Gedanken …';

  @override
  String get tarotIntro =>
      'Wir verstehen die Karten als Anstoß zum Nachdenken, nicht als Vorhersage. Die Positionen einer Legung sind Fragen, die du dir selbst stellen kannst.';

  @override
  String get drawCards => 'Karten ziehen';

  @override
  String get drawAgain => 'Neu ziehen';

  @override
  String get reversedOn =>
      'Umgekehrte Karten: an (jede Karte unabhängig, mit einer Chance von 1 zu 2).';

  @override
  String get reversedOff =>
      'Umgekehrte Karten: aus. Du kannst sie in den Einstellungen einschalten.';

  @override
  String get spreadReflectionPrompt =>
      'Was hat mich an dieser Legung am meisten berührt – und warum?';

  @override
  String get questionLabel => 'Deine Frage (optional)';

  @override
  String get questionHint =>
      'z. B. Worauf sollte ich bei einem Jobwechsel achten?';

  @override
  String get readingTitle => 'Was die Karten zu deiner Frage sagen';

  @override
  String get readingTitleNoQuestion => 'Zusammenfassung der Legung';

  @override
  String get summaryMajors =>
      'Die Großen Arkana überwiegen: Es geht um etwas Wichtiges, das über Alltagsentscheidungen hinausreicht.';

  @override
  String summarySuit(String suit) {
    String _temp0 = intl.Intl.selectLogic(suit, {
      'wands': 'Vor allem Stäbe: Im Hintergrund stehen Energie, Handeln und Initiative.',
      'cups': 'Vor allem Kelche: Im Hintergrund stehen Emotionen, Gefühle und Beziehungen.',
      'swords': 'Vor allem Schwerter: Im Hintergrund stehen Gedanken, Entscheidungen und schwierige Gespräche.',
      'pentacles': 'Vor allem Münzen: Im Hintergrund stehen Arbeit, Geld und praktische Dinge.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get summaryReversed =>
      'Die meisten Karten liegen umgekehrt: Vielleicht ist etwas blockiert, verzögert oder wird eher innerlich als nach außen erlebt.';

  @override
  String get summaryBalanced =>
      'Die Karten sind ausgewogen verteilt: Kein Bereich überwiegt deutlich.';

  @override
  String summaryAnswer(String position, String card, String advice) {
    return 'Die Antwort der Karten: $card in der Position „$position“: $advice';
  }

  @override
  String get addBookmark => 'Lesezeichen setzen';

  @override
  String get removeBookmark => 'Lesezeichen entfernen';

  @override
  String get group => 'Gruppe';

  @override
  String get keywords => 'Schlüsselwörter';

  @override
  String get symbolism => 'Symbolik';

  @override
  String get upright => 'Aufrechte Bedeutung';

  @override
  String get reversedMeaning => 'Umgekehrte Bedeutung';

  @override
  String get reflectionQuestions => 'Fragen zum Nachdenken';

  @override
  String get reflectionQuestion => 'Frage zum Nachdenken';

  @override
  String get sourcesAndRights => 'Quellen und Rechte';

  @override
  String get cardSourceNote =>
      'Die Kartenbeschreibungen sind eigene, für diese App geschriebene Texte. Illustration: Pamela Colman Smith (1878–1951), Deck von 1909, gemeinfrei; Scan eines Exemplars „Roses & Lilies“ (Saskia Jansen), veröffentlicht auf Wikimedia Commons. Das Bild wurde nur in der Größe verändert.';

  @override
  String get numerologyIntro =>
      'Gib dein Geburtsdatum und, wenn du möchtest, deinen vollständigen Namen ein. Als Profil gespeichert, schalten sie dein Tageshoroskop, deine Tageszahl, deine großen Drei und dein chinesisches Tierzeichen frei. Die Daten bleiben nur auf diesem Handy.';

  @override
  String get birthDate => 'Geburtsdatum';

  @override
  String get birthDateHelp => 'Nur Ziffern: Tag, Monat, Jahr, z. B. 15071990';

  @override
  String get fullNameOptional => 'Vollständiger Name (optional)';

  @override
  String get fullNameHelp =>
      'Nur für die Zahlen aus Buchstaben nötig. Umlaute, ß und Akzente werden unterstützt; Leerzeichen, Bindestriche und Apostrophe werden übersprungen.';

  @override
  String get personalYearFor => 'Persönliches Jahr für:';

  @override
  String get previousYear => 'Vorheriges Jahr';

  @override
  String get nextYear => 'Nächstes Jahr';

  @override
  String get calculate => 'Berechnen';

  @override
  String get saveAsProfile => 'Als mein Profil speichern';

  @override
  String get profileSaved => 'Auf diesem Gerät gespeichert.';

  @override
  String get portrait => 'Numerologisches Porträt';

  @override
  String get portraitNote =>
      'Klappe eine Zahl auf, um die Berechnung und ihre symbolische Deutung zu sehen. Die Ergebnisse folgen der in der Bibliothek beschriebenen Konvention („Wie wir rechnen“).';

  @override
  String indicatorName(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'lifePath': 'Lebenszahl',
      'birthDay': 'Geburtstagszahl',
      'expression': 'Ausdruckszahl',
      'soulUrge': 'Seelenzahl',
      'personality': 'Persönlichkeitszahl',
      'personalYear': 'Persönliches Jahr',
      'personalDay': 'Tageszahl',
      'relation': 'Beziehungszahl',
      'personalMonth': 'Persönlicher Monat',
      'maturity': 'Reifezahl',
      'house': 'Hauszahl',
      'other': 'Zahl',
    });
    return '$_temp0';
  }

  @override
  String get noBasis => 'Nichts zu berechnen';

  @override
  String get calculation => 'Berechnung';

  @override
  String get symbolicInterpretation => 'Symbolische Deutung';

  @override
  String get enterDateOrName =>
      'Gib ein Geburtsdatum oder einen vollständigen Namen ein.';

  @override
  String get dateInvalid => 'Dieses Datum gibt es nicht. Prüfe Tag und Monat.';

  @override
  String get dateFuture => 'Das Datum darf nicht in der Zukunft liegen.';

  @override
  String get nameNoLetters => 'Gib mindestens einen Buchstaben ein.';

  @override
  String nameUnsupported(String chars) {
    return 'Nicht unterstützte Zeichen: $chars. Gib die Schreibweise im lateinischen Alphabet (Transliteration) ein, die für die Berechnung verwendet werden soll.';
  }

  @override
  String get cardOfDay => 'Tageskarte';

  @override
  String get cardOfDayNote =>
      'Die Tageskarte bleibt bis zum Ende des Tages gleich – nach der Uhr dieses Geräts.';

  @override
  String get promptOfDay => 'Frage des Tages';

  @override
  String yourPersonalYear(int year) {
    final intl.NumberFormat yearNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String yearString = yearNumberFormat.format(year);

    return 'Dein persönliches Jahr $yearString';
  }

  @override
  String get search => 'Karten, Begriffe, Artikel suchen';

  @override
  String get bookmarks => 'Lesezeichen';

  @override
  String get articles => 'Artikel';

  @override
  String cardsCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Karten ($n)',
      one: 'Karte (1)',
    );
    return '$_temp0';
  }

  @override
  String get archetypes => 'Archetypen';

  @override
  String get archetypesNote =>
      'Die Beschreibungen der 12 Archetypen sind eigene Texte dieser App. Die Einteilung selbst folgt einem bekannten Satz von zwölf Archetypen: eine von vielen möglichen Einteilungen, kein Kanon und kein psychologischer Test.';

  @override
  String get aboutModel => 'Über das Modell';

  @override
  String get archetypeGifts => 'Gaben';

  @override
  String get archetypeShadow => 'Schatten';

  @override
  String get glossary => 'Glossar';

  @override
  String get theme => 'Design';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get allowReversed => 'Umgekehrte Karten';

  @override
  String get allowReversedRule =>
      'Wenn aktiviert, wird jede gezogene Karte unabhängig mit einer Chance von 1 zu 2 umgekehrt.';

  @override
  String get profile => 'Mein Profil';

  @override
  String get privacy => 'Datenschutz';

  @override
  String get privacyBody =>
      'Wir legen keine Konten an und senden deine Daten, Namen oder Einträge an keinen Server. Deine Daten befinden sich nur auf diesem Gerät, solange du sie nicht selbst exportierst.';

  @override
  String get deleteAllTitle => 'Alle Daten löschen';

  @override
  String get deleteAllBody =>
      'Wir entfernen dein Tagebuch, dein Profil, deine Lesezeichen, die Tageskarte und die Einstellungen von diesem Gerät. Das lässt sich nicht rückgängig machen.';

  @override
  String get deleteAllFailed =>
      'Nicht alle Daten konnten gelöscht werden. Bitte versuche es erneut.';

  @override
  String get sourcesBody =>
      'Deutungen, Fragen, Archetypen und Artikel sind eigene Texte. Kartenillustrationen: Pamela Colman Smith, Deck von 1909 (gemeinfrei), Scans von Wikimedia Commons; Details stehen bei jeder Karte. Historische Quellen sind am Ende der Artikel angegeben. Diese App steht in keiner Verbindung zu U.S. Games Systems, Inc.';

  @override
  String get purchases => 'Digi Witch Pro';

  @override
  String get help => 'Hilfe';

  @override
  String get helpBody =>
      'Wenn du in einer Krise steckst, wende dich an eine Fachperson oder eine Krisenhotline – z. B. die TelefonSeelsorge 0800 111 0 111 (Deutschland), 142 (Österreich) oder 143 (Schweiz), rund um die Uhr und kostenlos. Im Notfall wähle 112.';

  @override
  String get versions => 'Versionen';

  @override
  String get algorithm => 'Algorithmus';

  @override
  String get contentVer => 'Inhalte';

  @override
  String get disclaimer =>
      'Diese Inhalte dienen der Unterhaltung, Bildung und Selbstreflexion. Sie sind keine medizinische, psychologische, rechtliche oder finanzielle Beratung.';

  @override
  String get proShort =>
      'Einmaliger Kauf: keine Werbung, zusätzliche Legungen.';

  @override
  String get proTitle => 'Digi Witch Pro';

  @override
  String get proBenefits =>
      '• Keine Werbung in der ganzen App\n• Zusätzliche Legungen: „Beziehung“ (6 Karten) und „Reflexionskreuz“ (10 Karten)\n• Einmalige Zahlung, kein Abo';

  @override
  String get proFreeStays =>
      'Numerologie, Tageskarte, Legungen mit 1, 3 und 5 Karten, Bibliothek und Tagebuch bleiben kostenlos. Der Kauf von Pro beeinflusst weder, welche Karten gezogen werden, noch wie Ergebnisse berechnet werden.';

  @override
  String get proActive => 'Du hast Pro. Danke!';

  @override
  String get proUnavailable =>
      'Kaufen ist gerade nicht möglich. Prüfe deine Internetverbindung und versuche es später noch einmal.';

  @override
  String proBuy(String price) {
    return 'Pro kaufen für $price';
  }

  @override
  String get purchaseError =>
      'Der Kauf wurde nicht abgeschlossen. Dir wurde nichts berechnet, sofern der Store die Transaktion nicht bestätigt hat.';

  @override
  String get restorePurchases => 'Käufe wiederherstellen';

  @override
  String get proOnly => 'In Pro verfügbar';

  @override
  String get adPrivacyOptions => 'Datenschutz-Einstellungen für Werbung';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get reminder => 'Tägliche Erinnerung';

  @override
  String get reminderOff => 'Aus';

  @override
  String reminderAt(String time) {
    return 'Jeden Tag um $time';
  }

  @override
  String get reminderTitle => 'Digi Witch';

  @override
  String get reminderBody => 'Ein Moment zum Innehalten, wenn dir danach ist.';

  @override
  String get reminderDenied =>
      'Benachrichtigungen sind nicht erlaubt. Du kannst sie in den Systemeinstellungen zulassen.';

  @override
  String get proStoreNote =>
      'Zahlung und eventuelle Erstattungen wickeln App Store oder Google Play nach ihren eigenen Regeln ab. Der Kauf funktioniert unabhängig davon, ob du Werbung zustimmst.';

  @override
  String get horoscopeToday => 'Heute';

  @override
  String get horoscopeStars => 'Die Sterne sagen';

  @override
  String get horoscopeCaution => 'Achte auf';

  @override
  String moonIn(String sign, String phase) {
    return 'Mond $sign, $phase.';
  }

  @override
  String get luckyNumbers => 'Glückszahlen des Tages';

  @override
  String get luckyNote =>
      'Nur zum Spaß: Die Zahlen ergeben sich aus deinem Geburtsdatum und dem heutigen Datum, darum bleiben sie den ganzen Tag gleich. Sie sagen keine Gewinne voraus.';

  @override
  String get whyThis => 'Woher das kommt';

  @override
  String whySign(
    String sign,
    String dates,
    String element,
    String chinese,
    String chineseText,
  ) {
    return 'Dein Zeichen: $sign ($dates), Element: $element. Chinesisches Zeichen: $chinese. $chineseText';
  }

  @override
  String whyMoon(String sign, String element, String relation) {
    String _temp0 = intl.Intl.selectLogic(relation, {
      'same': 'dasselbe Element',
      'supportive': 'unterstützend',
      'tense': 'spannungsreich',
      'other': 'neutral',
    });
    return 'Heute Mittag steht der Mond im Zeichen $sign (Element: $element). Beziehung zu deinem Element: $_temp0.';
  }

  @override
  String get whyMethod =>
      'Die Mondposition wird offline mit astronomischen Formeln berechnet (auf etwa 0,5° genau). Der Text „Heute“ hängt von der Beziehung der Elemente ab, „Die Sterne sagen“ von der Mondphase und „Achte auf“ von deiner Tageszahl.';

  @override
  String get horoscopeNeedsBirth =>
      'Gib dein Geburtsdatum ein, und du siehst sofort dein Zeichen, dein Tageshoroskop, deine Tageszahl und deine Glückszahlen.';

  @override
  String get moonToday => 'Der Mond heute';

  @override
  String moonState(String phase, int percent, String sign) {
    return '$phase · $percent % beleuchtet · $sign';
  }

  @override
  String get moonCalendar => 'Mondkalender';

  @override
  String get moonCalendarIntro =>
      'Die nächsten Hauptphasen des Mondes in Ortszeit (auf etwa 1 Stunde genau).';

  @override
  String get compatibility => 'Wie zwei Menschen zusammenpassen';

  @override
  String get compatIntro =>
      'Gib zwei Geburtsdaten ein. Wir vergleichen Sternzeichen, Elemente, chinesische Zeichen und Lebenszahlen. Das ist ein Spiel und ein Gesprächsanlass, kein Urteil über eine Beziehung.';

  @override
  String personDate(int n) {
    return 'Geburtsdatum: Person $n';
  }

  @override
  String get check => 'Vergleichen';

  @override
  String get compatElements => 'Elemente';

  @override
  String personLine(
    int n,
    String sign,
    String element,
    String chinese,
    int lifePath,
  ) {
    return 'Person $n: $sign ($element) · chinesisches Zeichen: $chinese · Lebenszahl $lifePath';
  }

  @override
  String get birthCardTitle => 'Geburtskarte';

  @override
  String get birthCardNote =>
      'Methode: Tag + Monat + Jahr der Geburt, dann werden die Ziffern addiert, bis das Ergebnis höchstens 22 ist (22 = Der Narr). Ein zweistelliges Ergebnis ergibt zusätzlich eine Begleitkarte.';

  @override
  String get birthCardSecond => 'Begleitkarte';

  @override
  String yesNoAnswer(String a) {
    String _temp0 = intl.Intl.selectLogic(a, {
      'yes': 'Die Antwort der Karten: JA',
      'no': 'Die Antwort der Karten: NEIN',
      'other': 'Die Antwort der Karten: UNKLAR. Die Sache ist noch offen',
    });
    return '$_temp0';
  }

  @override
  String get horoscopeFor => 'Heute für dich';

  @override
  String get licenses => 'Lizenzen (Schriften und Bibliotheken)';

  @override
  String get cardAdvice => 'Rat der Karte';

  @override
  String get correspondences =>
      'Astrologische Entsprechungen (Golden Dawn, 19. Jahrhundert)';

  @override
  String get chooseSpread => 'Legung wählen';

  @override
  String get tapDeck => 'Denk an deine Frage und tippe auf das Deck';

  @override
  String spreadCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Karten',
      one: '1 Karte',
    );
    return '$_temp0';
  }

  @override
  String get bigThree => 'Deine großen Drei';

  @override
  String get bigThreeIntro =>
      'Die Sonne ist dein Sternzeichen. Der Mond beschreibt deine Gefühle, der Aszendent, wie andere dich sehen. Für den Mond reicht meist das Datum; für den Aszendenten brauchst du Geburtszeit und Geburtsort. Die Daten bleiben nur auf diesem Gerät.';

  @override
  String get birthTime => 'Geburtszeit';

  @override
  String get notGiven => 'nicht angegeben';

  @override
  String get birthPlace => 'Geburtsort';

  @override
  String get placesNote =>
      'Städte in Polen und große Städte weltweit. Fehlt deine, wähle die nächstgelegene im selben Land oder gib Koordinaten ein. Einige Dutzend Kilometer verändern den Aszendenten um weniger als 1°.';

  @override
  String get sunLabel => 'Sonne';

  @override
  String get moonLabel => 'Mond';

  @override
  String get ascLabel => 'Aszendent';

  @override
  String moonTwoSigns(String a, String b) {
    return 'Der Mond hat an diesem Tag das Zeichen gewechselt: $a oder $b, je nach Geburtszeit.';
  }

  @override
  String get ascNeeds =>
      'Gib Geburtszeit und Geburtsort ein, um den Aszendenten zu berechnen.';

  @override
  String traceTime(String local, String utc, String zone) {
    return 'Ortszeit $local → $utc UTC (Zone $zone, mit Sommerzeit-Historie).';
  }

  @override
  String traceMoon(String deg, String sign) {
    return 'Ekliptikale Länge des Mondes: $deg° → $sign.';
  }

  @override
  String traceAsc(
    String deg,
    String sign,
    String place,
    String lat,
    String lon,
  ) {
    return 'Aszendent: $deg° → $sign ($place, $lat° N, $lon° O).';
  }

  @override
  String get needBirthDate =>
      'Speichere zuerst dein Geburtsdatum im Tab „Zahlen“ (Schaltfläche „Als mein Profil speichern“).';

  @override
  String get clear => 'Leeren';

  @override
  String get chineseTitle => 'Chinesisches Horoskop';

  @override
  String chineseBirthYear(int year, String element, String yy) {
    String _temp0 = intl.Intl.selectLogic(yy, {'yang': 'Yang', 'other': 'Yin'});
    return 'Jahr im chinesischen Kalender: $year · $element · $_temp0';
  }

  @override
  String get chineseNewYearNote =>
      'Das chinesische Neujahr fällt zwischen den 21. Januar und den 20. Februar. Wer davor geboren ist, gehört zum Zeichen des Vorjahres. Das ist hier bereits berücksichtigt.';

  @override
  String chineseCurrentYear(int year, String animal, String element) {
    return 'Jahr $year: $animal · $element';
  }

  @override
  String chineseYearSince(String date) {
    return 'Das aktuelle chinesische Jahr hat am $date begonnen.';
  }

  @override
  String get chineseCompatTitle => 'Verträglichkeit der chinesischen Zeichen';

  @override
  String get chineseFriend => 'Geheimer Freund';

  @override
  String get chineseTrine => 'Trigon der Verbündeten';

  @override
  String get chineseClash => 'Gegenzeichen';

  @override
  String get chineseElement => 'Element des Geburtsjahres';

  @override
  String get mercuryRetro => 'Merkur rückläufig';

  @override
  String mercuryNow(String date) {
    return 'Merkur rückläufig bis $date';
  }

  @override
  String get mercuryNone => 'Im kommenden Jahr keine rückläufigen Phasen.';

  @override
  String get upcomingPhases => 'Nächste Phasen';

  @override
  String get dayByDay => 'Tag für Tag (30 Tage)';

  @override
  String moonDayLine(String sign, String phase) {
    return 'Mond $sign · $phase';
  }

  @override
  String get dreams => 'Traumlexikon';

  @override
  String dreamsCount(int n) {
    return '$n Traumsymbole: was ein Traum dir über dich selbst sagen kann';
  }

  @override
  String get dreamsIntro =>
      'Träume sagen nicht die Zukunft voraus. Das Lexikon zeigt, womit ein Symbol oft verbunden wird, und die Frage hilft dir zu prüfen, was es für dich bedeutet. Am wichtigsten ist, wie du dich im Traum gefühlt hast.';

  @override
  String get dreamsSearch => 'Symbol suchen, z. B. Wasser, Zähne, Haus';

  @override
  String get dreamsEmpty =>
      'Dieses Symbol gibt es nicht. Versuch ein ähnliches Wort oder schreib den Traum in dein Tagebuch.';

  @override
  String chineseSignButton(String animal) {
    return 'Chinesisches Zeichen: $animal';
  }

  @override
  String get otherPlace => 'Anderer Ort: Koordinaten eingeben';

  @override
  String otherPlaceSet(String place, String zone) {
    return 'Anderer Ort: $place ($zone)';
  }

  @override
  String get otherPlaceHelp =>
      'Koordinaten findest du in einer Karten-App (z. B. durch Tippen auf einen Ort in Google Maps). Süd und West gibst du mit Minuszeichen ein. Die Zeitzone ist eine Region, z. B. Europe/Berlin, America/Chicago.';

  @override
  String get latitude => 'Breitengrad';

  @override
  String get longitude => 'Längengrad';

  @override
  String get timeZone => 'Zeitzone';

  @override
  String get otherPlaceMissing =>
      'Gib Breitengrad, Längengrad und Zeitzone ein.';

  @override
  String get otherPlaceRange =>
      'Der Breitengrad muss zwischen -66° und 66° liegen (jenseits der Polarkreise kann der Aszendent unbestimmt sein), der Längengrad zwischen -180° und 180°.';

  @override
  String get numbersStartTitle => 'Beginne mit deinem Geburtsdatum';

  @override
  String get numbersEditTitle =>
      'Daten ändern oder für jemand anderen berechnen';

  @override
  String get calculateOnce => 'Nur berechnen (ohne Speichern)';

  @override
  String get compatibilityHint => 'Zwei Geburtsdaten vergleichen';

  @override
  String get yourNumbers => 'Deine Zahlen';

  @override
  String get editOrOther => 'Daten ändern oder für jemand anderen berechnen';

  @override
  String get showMyHoroscope => 'Mein Horoskop zeigen';

  @override
  String get privacyShort =>
      'Das Datum bleibt nur auf diesem Handy. Du kannst es im Tab „Zahlen“ ändern.';

  @override
  String get explore => 'Entdecken';

  @override
  String get exploreBigThree => 'Sonne, Mond und Aszendent';

  @override
  String get exploreChinese => 'Zeichen, Element und dein Jahr';

  @override
  String get exploreTarot => 'Frag die Karten';

  @override
  String get exploreTarotSub => 'Legungen und Ja-Nein-Fragen';

  @override
  String get exploreNumbersSub => 'Lebenszahl und Geburtskarte';

  @override
  String get exploreMoon => 'Phasen, Garten, Merkur rückläufig';

  @override
  String get exploreDreams => 'Was dein Traum dir sagt';

  @override
  String get exploreLibrary => '78 Karten, Artikel, Glossar: in der Bibliothek';

  @override
  String get exploreLibraryTitle => 'Karten und Artikel';

  @override
  String get squareTitle => 'Pythagoras-Quadrat';

  @override
  String get squareIntro =>
      'Ein Raster der Ziffern deines Geburtsdatums (Methode nach Alexandrow): Je öfter eine Ziffer vorkommt, desto stärker die Eigenschaft. Tippe auf ein Feld, um die Beschreibung zu lesen.';

  @override
  String get squareEmpty => 'keine';

  @override
  String get cyclesTitle => 'Lebenszyklen: Gipfel und Herausforderungen';

  @override
  String get cyclesIntro =>
      'Die Numerologie teilt das Leben in vier Abschnitte. Jeder hat seinen „Gipfel“, ein Thema für Wachstum, und seine „Herausforderung“, eine Lektion zum Durcharbeiten. Wie lang der erste Abschnitt ist, hängt von deiner Lebenszahl ab.';

  @override
  String ageRange(int from, int to) {
    return '$from–$to Jahre';
  }

  @override
  String ageFrom(int from) {
    return 'ab $from Jahren';
  }

  @override
  String get cyclesNow => 'JETZT';

  @override
  String get ichingTitle => 'I-Ging-Orakel';

  @override
  String get ichingIntro =>
      'Das Buch der Wandlungen ist ein klassisches chinesisches Orakel. Denk an deine Frage und wirf sechsmal drei Münzen; das Hexagramm baut sich von unten nach oben auf. Mit einem Punkt markierte Linien sind „wandelnd“ und zeigen, wohin sich die Situation entwickelt.';

  @override
  String ichingToss(int n) {
    return 'Münzen werfen ($n/6)';
  }

  @override
  String ichingLastToss(String sum) {
    String _temp0 = intl.Intl.selectLogic(sum, {
      '6': 'Zahl, Zahl, Zahl = 6 (altes Yin, wandelnd)',
      '7': 'zweimal Zahl und einmal Kopf = 7 (Yang)',
      '8': 'zweimal Kopf und einmal Zahl = 8 (Yin)',
      'other': 'Kopf, Kopf, Kopf = 9 (altes Yang, wandelnd)',
    });
    return 'Letzter Wurf: $_temp0';
  }

  @override
  String get ichingMeaning => 'Bedeutung';

  @override
  String get ichingChange => 'Richtung der Wandlung';

  @override
  String ichingChangingLines(String lines) {
    return 'Wandelnde Linien: $lines. Die Situation entwickelt sich zu:';
  }

  @override
  String get ichingAgain => 'Neue Frage';

  @override
  String get ichingNote =>
      'Die Beschreibungen der Hexagramme und Linien sind eigene, kurze Deutungen dieser App, inspiriert von den Bildern des alten chinesischen Textes. Verstehe sie als Anstoß zum Nachdenken.';

  @override
  String get exploreIching => 'Eine Frage und sechs Münzwürfe';

  @override
  String get ritualsTitle => 'Mondrituale';

  @override
  String get exploreRituals => 'Absichten für Neu- und Vollmond';

  @override
  String get ritualsIntro =>
      'Neu- und Vollmond geben dem Monat seinen Rhythmus. Schreib bei Neumond eine Absicht auf und schau bei Vollmond zurück, was geschehen ist. Deine Einträge landen in deinem Tagebuch.';

  @override
  String get moonRemindersToggle => 'An Neu- und Vollmond erinnern';

  @override
  String get moonRemindersNote =>
      'Eine Benachrichtigung um 9:00 Uhr am Tag von Neu- und Vollmond. Funktioniert offline.';

  @override
  String get moonReminderNewTitle => 'Neumond: Zeit für eine Absicht';

  @override
  String get moonReminderNewBody =>
      'Schreib auf, was du in diesem Zyklus beginnen möchtest.';

  @override
  String get moonReminderFullTitle => 'Vollmond: Zeit für einen Rückblick';

  @override
  String get moonReminderFullBody =>
      'Was ist seit Neumond gut gelaufen? Wofür bist du dankbar?';

  @override
  String get forYouToday => 'Nur für dich';

  @override
  String get advice => 'Rat';

  @override
  String get karmicTitle => 'Karma in Zahlen';

  @override
  String get karmicIntro =>
      'Karmische Schulden sind die Zahlen 13, 14, 16 und 19, die auf dem Weg zu deinen Zahlen auftauchen. Karmische Lektionen sind die Ziffern, die in deinem vollständigen Namen fehlen. In der Tradition beschreiben sie Themen zum Bearbeiten, keine Urteile.';

  @override
  String get karmicNone =>
      'In deinen Zahlen gibt es keine karmischen Schulden.';

  @override
  String get karmicLessonsTitle =>
      'Karmische Lektionen (in deinem Namen fehlende Ziffern)';

  @override
  String get houseTitle => 'Numerologie von Haus- und Telefonnummer';

  @override
  String get houseHint => 'Haus-, Wohnungs- oder Telefonnummer, z. B. 12A';

  @override
  String luckyMeaning(int n, int reduced, String keywords) {
    return '$n → $reduced: $keywords';
  }

  @override
  String dayColor(String color) {
    return 'Farbe des Tages: $color';
  }

  @override
  String signExtras(String color, String stone, String day, String planet) {
    return 'Farbe: $color · Stein: $stone · Tag: $day · Planet: $planet';
  }

  @override
  String get periodTitle => 'Horoskop für Woche und Monat';

  @override
  String get explorePeriod => 'Schlüsseltage und dein persönlicher Monat';

  @override
  String get periodIntro =>
      'Berechnet nach dem echten Himmel: Mondphasen, Finsternisse, rückläufiger Merkur, der Eintritt der Sonne in das nächste Zeichen und die Tage, an denen der Mond in deinem Zeichen steht, dazu deine persönlichen Zahlen.';

  @override
  String get tabWeek => 'Woche';

  @override
  String get tabMonth => 'Monat';

  @override
  String get weekGeneral => 'Allgemein';

  @override
  String get keyDays => 'Schlüsseltage';

  @override
  String get noKeyDays =>
      'In diesem Zeitraum gibt es am Himmel keine besonderen Ereignisse. Eine gute Zeit für ruhiges, stetiges Arbeiten.';

  @override
  String evPhase(String phase) {
    return '$phase';
  }

  @override
  String evMoonInSign(String sign) {
    return 'Mond in deinem Zeichen ($sign)';
  }

  @override
  String evSunIngress(String sign) {
    return 'Die Sonne wechselt ins Zeichen $sign';
  }

  @override
  String get evMercuryStart => 'Merkur wird rückläufig';

  @override
  String get evMercuryEnd => 'Merkur wird direktläufig';

  @override
  String evEclipse(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'solar': 'Sonnenfinsternis',
      'partial': 'Mondfinsternis (partiell oder total)',
      'other': 'Halbschatten-Mondfinsternis (kaum sichtbar)',
    });
    return '$_temp0';
  }

  @override
  String dayNumberLine(int n, String title) {
    return 'Tageszahl $n: $title';
  }

  @override
  String get eclipsesTitle => 'Finsternisse im kommenden Jahr';

  @override
  String get eclipseVisibility =>
      'Die Sichtbarkeit hängt davon ab, wo auf der Erde du bist: Nicht jede Finsternis ist von deinem Ort aus zu sehen.';

  @override
  String eclipseSoon(String when) {
    return 'Eine Finsternis steht bevor: $when';
  }

  @override
  String get loveLabel => 'Liebe';

  @override
  String get workLabel => 'Arbeit';

  @override
  String get wellbeingLabel => 'Wohlbefinden';

  @override
  String ichingImage(String upper, String lower) {
    return 'Bild: $upper über $lower';
  }

  @override
  String get ichingLinesTitle => 'Wandelnde Linien';

  @override
  String ichingLine(int n, String text) {
    return 'Linie $n: $text';
  }

  @override
  String get revealCard => 'Karte aufdecken';

  @override
  String get revealCardHint =>
      'Tippe auf die Karte, um zu sehen, was der Tag bringt.';

  @override
  String get cardOfDayMore => 'Mehr über die Karte';

  @override
  String get moodQuestion => 'Wie fühlst du dich heute?';

  @override
  String moodName(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      '1': 'Schwer',
      '2': 'Gedrückt',
      '3': 'Geht so',
      '4': 'Gut',
      'other': 'Super',
    });
    return '$_temp0';
  }

  @override
  String get moodSaved => 'Nur auf diesem Gerät gespeichert.';

  @override
  String countdown(String what, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'in $days Tagen',
      one: 'morgen',
      zero: 'heute',
    );
    return '$what $_temp0';
  }

  @override
  String get yourBirthday => 'Dein Geburtstag';

  @override
  String notifMoon(String sign) {
    return 'Mond $sign';
  }

  @override
  String notifDayNumber(int n) {
    return 'Tageszahl $n';
  }

  @override
  String get notifCard => 'deine Tageskarte wartet';

  @override
  String get tabStars => 'Sterne';

  @override
  String get starsMore => 'Mehr aus den Sternen';

  @override
  String get deckTitle => 'Das Deck';

  @override
  String get fullHoroscope => 'Ganzes Horoskop';

  @override
  String get upcoming => 'Demnächst';

  @override
  String get suggested => 'Vorschläge für heute';

  @override
  String get suggestBigThree =>
      'Ergänze Geburtszeit und -ort, um deinen Mond und Aszendenten zu entdecken';

  @override
  String get dayNumberShort => 'Tageszahl';

  @override
  String get dayColorShort => 'Farbe des Tages';

  @override
  String get fullNumerology => 'Ganze Numerologie und Porträt';

  @override
  String get firstEntry => 'Ersten Gedanken aufschreiben';

  @override
  String get greetDay => 'Guten Morgen';

  @override
  String get greetEvening => 'Guten Abend';

  @override
  String get dayHoroscope => 'Horoskop';

  @override
  String get dayNumbers => 'Meine Zahlen';

  @override
  String get dayCard => 'Karte';

  @override
  String get dayDone => 'Für heute ist alles erledigt.';

  @override
  String tomorrowIs(String what) {
    return 'Morgen: $what.';
  }

  @override
  String tomorrowMoon(String sign) {
    return 'Morgen: Mond $sign.';
  }

  @override
  String tomorrowNumber(int n) {
    return 'Morgen: eine neue Karte und Tageszahl $n.';
  }

  @override
  String get tomorrowCard => 'Morgen: eine neue Tageskarte.';

  @override
  String get tabDreams => 'Träume';

  @override
  String get dreamAsk => 'Was hast du heute Nacht geträumt?';

  @override
  String get dreamAskHint =>
      'Schreib den Traum auf, bevor er verblasst, oder schlag unten ein Symbol nach.';

  @override
  String get dreamSave => 'Traum aufschreiben';

  @override
  String get dreamEntry => 'Traum';

  @override
  String get dreamOfDay => 'Symbol des Tages';

  @override
  String get dreamsAll => 'Alle Symbole';

  @override
  String get widgetCardWaiting => 'Wartet darauf, aufgedeckt zu werden';

  @override
  String get widgetStale => 'Tippe, um deinen Tag zu sehen';

  @override
  String widgetCardSays(String advice) {
    return 'Die Karte sagt: $advice';
  }

  @override
  String get widgetNeedBirth =>
      'Gib dein Geburtsdatum ein, um deinen Tag zu sehen.';

  @override
  String get language => 'Sprache';

  @override
  String get dateHint => 'TT.MM.JJJJ';

  @override
  String get layTarot => 'Tarot legen';

  @override
  String get tarotWelcomeTitle => 'Was raten dir die Karten heute?';

  @override
  String get tarotWelcomeBody =>
      'Denk an das, was dich beschäftigt, wähle eine Legung und decke die Karten auf. Jede Legung ist ein neuer Blick. Komm wieder, wenn eine neue Frage auftaucht.';

  @override
  String get seeDeck => 'Deck ansehen';

  @override
  String get tarotWelcomeSetting => 'Einführung im Tab „Tarot“';

  @override
  String get hide => 'Ausblenden';

  @override
  String get tapHint => 'tippen';

  @override
  String get dailyMood => 'Wie du dich heute fühlen könntest';

  @override
  String get dailyEvents => 'Was dir heute begegnen kann';

  @override
  String get dailyAdvice => 'Rat für heute';

  @override
  String get energyLabel => 'Energie';

  @override
  String meterValue(String label, int n) {
    return '$label: $n von 5';
  }

  @override
  String get cheerAll => 'Ein schöner Tag — die Sterne sind auf deiner Seite';

  @override
  String get cheerLove => 'Ein guter Tag für das Herz';

  @override
  String get cheerWork => 'Ein guter Tag zum Anpacken';

  @override
  String get cheerEnergy => 'Ein Tag voller Energie';

  @override
  String get cheerUpLove => 'In der Liebe besser als gestern';

  @override
  String get cheerUpWork => 'In der Arbeit besser als gestern';

  @override
  String get cheerUpEnergy => 'Mehr Energie als gestern';

  @override
  String get cheerNewMoon => 'Neumond — gute Zeit für einen neuen Vorsatz';

  @override
  String get cheerWaxing => 'Der Mond wächst und mit ihm deine Pläne';

  @override
  String get cheerFullMoon => 'Vollmond — Zeit, zu schätzen, was du schon hast';

  @override
  String get cheerWaning =>
      'Der Mond nimmt ab — leichter, loszulassen, was belastet';

  @override
  String get cheerNewMoon2 =>
      'Neumond — ein leeres Blatt. Schreib etwas Gutes darauf';

  @override
  String get cheerNewMoon3 =>
      'Neumond — in der Stille entstehen die besten Ideen';

  @override
  String get cheerWaxing2 =>
      'Der Mond nimmt zu — gute Zeit für kleine Schritte';

  @override
  String get cheerWaxing3 => 'Der wachsende Mond begünstigt, was du beginnst';

  @override
  String get cheerFullMoon2 =>
      'Vollmond — heute sieht man mehr. Auch das, was gelungen ist';

  @override
  String get cheerFullMoon3 =>
      'Vollmond — ein guter Abend, um Kleines zu feiern';

  @override
  String get cheerWaning2 =>
      'Der Mond nimmt ab — gute Zeit zum Aufräumen und Durchatmen';

  @override
  String get cheerWaning3 =>
      'Der abnehmende Mond begünstigt Ruhe und Abschlüsse';

  @override
  String get threeGood => 'Drei gute Dinge aufschreiben';

  @override
  String get threeGoodPrompt =>
      'Drei gute Dinge aus dieser Woche — und was dazu geführt hat:';

  @override
  String moodReply(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      '1': 'Schwere Tage kommen vor. Du musst heute nichts aufholen.',
      '2': 'Ein schwächerer Tag ist auch in Ordnung. Ein kleiner Schritt genügt.',
      '3': 'Auch ein gewöhnlicher Tag zählt.',
      '4': 'Schön zu hören.',
      'other': 'Wunderbar. Merk dir ruhig, was dazu beigetragen hat.',
    });
    return '$_temp0';
  }

  @override
  String get reminderAsk => 'Soll die Tageskarte morgens auf dich warten?';

  @override
  String get reminderAskSub =>
      'Eine Mitteilung pro Tag um 8:00 Uhr, mit dem Inhalt des Tages. Uhrzeit ändern oder ausschalten kannst du in den Einstellungen.';

  @override
  String get reminderYes => 'Ja, erinnere mich';

  @override
  String get reminderNo => 'Nein, danke';

  @override
  String get onboardBirthHint =>
      'Freiwillig. Mit dem Datum siehst du sofort dein Zeichen, dein Horoskop und deine Zahlen.';

  @override
  String get lookBack => 'Deine Tage';

  @override
  String get lookBackHint =>
      'Tageskarten und Stimmung, Tag für Tag. Nur auf diesem Gerät gespeichert.';
}
