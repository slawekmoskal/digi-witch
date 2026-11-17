// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Digi Witch';

  @override
  String get tabToday => 'Oggi';

  @override
  String get tabNumerology => 'Numeri';

  @override
  String get tabTarot => 'Tarocchi';

  @override
  String get tabLibrary => 'Biblioteca';

  @override
  String get tabJournal => 'Diario';

  @override
  String get settings => 'Impostazioni';

  @override
  String get start => 'Cominciamo';

  @override
  String get onboardWhat =>
      'La tua guida quotidiana ai simboli: oroscopo di oggi, Luna, tarocchi, numerologia, segno cinese e dizionario dei sogni. Ogni calcolo è mostrato passo dopo passo e ogni carta è spiegata nella biblioteca.';

  @override
  String get onboardNot =>
      'È uno strumento di intrattenimento, di scoperta del simbolismo e di riflessione su di sé. Non predice il futuro, non misura la personalità in senso scientifico e non sostituisce una consulenza professionale.';

  @override
  String get onboardPrivacy =>
      'Non serve un account. Date, nomi e diario restano su questo dispositivo.';

  @override
  String get onboardAdults => 'Questa app è pensata per un pubblico adulto.';

  @override
  String get reversed => 'rovesciata';

  @override
  String get writeReflection => 'Scrivi una riflessione nel diario';

  @override
  String get exportJournal => 'Esporta il diario';

  @override
  String get newEntry => 'Nuova voce';

  @override
  String get editEntry => 'Voce';

  @override
  String get journalEmpty =>
      'Il tuo diario è vuoto. Annota un primo pensiero. Puoi partire dalla domanda del giorno o da una carta che hai estratto.';

  @override
  String get journalPrivacy =>
      'Le voci sono salvate solo su questo dispositivo.';

  @override
  String get deleteEntryConfirm =>
      'Eliminare questa voce? L’azione non si può annullare.';

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Elimina';

  @override
  String get save => 'Salva';

  @override
  String get linkedResult => 'Risultato collegato';

  @override
  String get promptsTitle => 'Una domanda da cui partire (facoltativa)';

  @override
  String promptCategory(String c) {
    String _temp0 = intl.Intl.selectLogic(c, {
      'ogolne': 'Generale',
      'rodzina': 'Famiglia',
      'tarot': 'Tarocchi',
      'liczby': 'Numeri',
      'other': 'Altro',
    });
    return '$_temp0';
  }

  @override
  String get randomPrompt => 'Scegli una domanda a caso';

  @override
  String get familyNote =>
      'Scrivi solo ciò che ti va di condividere. Puoi usare dei soprannomi al posto dei nomi delle persone care.';

  @override
  String get entryHint => 'I tuoi pensieri…';

  @override
  String get tarotIntro =>
      'Trattiamo le carte come uno spunto di riflessione, non come una previsione. Le posizioni di una stesa sono domande che vale la pena farsi.';

  @override
  String get drawCards => 'Estrai le carte';

  @override
  String get drawAgain => 'Estrai di nuovo';

  @override
  String get reversedOn =>
      'Carte rovesciate: attive (ogni carta in modo indipendente, con una probabilità su due).';

  @override
  String get reversedOff =>
      'Carte rovesciate: disattivate. Puoi attivarle nelle Impostazioni.';

  @override
  String get spreadReflectionPrompt =>
      'Che cosa mi ha colpito di più in questa stesa, e perché?';

  @override
  String get questionLabel => 'La tua domanda (facoltativa)';

  @override
  String get questionHint =>
      'es. Che cosa devo tenere a mente se cambio lavoro?';

  @override
  String get readingTitle => 'Che cosa dicono le carte sulla tua domanda';

  @override
  String get readingTitleNoQuestion => 'Riepilogo della stesa';

  @override
  String get summaryMajors =>
      'Prevalgono gli Arcani maggiori: la questione tocca qualcosa di importante, più grande delle scelte di ogni giorno.';

  @override
  String summarySuit(String suit) {
    String _temp0 = intl.Intl.selectLogic(suit, {
      'wands': 'Prevalgono i Bastoni: sullo sfondo ci sono energia, azione e iniziativa.',
      'cups': 'Prevalgono le Coppe: sullo sfondo ci sono emozioni, sentimenti e relazioni.',
      'swords': 'Prevalgono le Spade: sullo sfondo ci sono pensieri, decisioni e conversazioni difficili.',
      'pentacles': 'Prevalgono i Denari: sullo sfondo ci sono lavoro, denaro e questioni pratiche.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get summaryReversed =>
      'La maggior parte delle carte è rovesciata: qualcosa potrebbe essere bloccato, rimandato o vissuto più dentro che fuori.';

  @override
  String get summaryBalanced =>
      'Le carte sono distribuite in modo equilibrato: nessun ambito prevale con chiarezza.';

  @override
  String summaryAnswer(String position, String card, String advice) {
    return 'La risposta delle carte: $card nella posizione «$position»: $advice';
  }

  @override
  String get addBookmark => 'Aggiungi ai preferiti';

  @override
  String get removeBookmark => 'Rimuovi dai preferiti';

  @override
  String get group => 'Gruppo';

  @override
  String get keywords => 'Parole chiave';

  @override
  String get symbolism => 'Simbolismo';

  @override
  String get upright => 'Significato dritto';

  @override
  String get reversedMeaning => 'Significato rovesciato';

  @override
  String get reflectionQuestions => 'Domande per riflettere';

  @override
  String get reflectionQuestion => 'Domanda per riflettere';

  @override
  String get sourcesAndRights => 'Fonti e diritti';

  @override
  String get cardSourceNote =>
      'Le descrizioni delle carte sono testi originali scritti per questa app. Illustrazione: Pamela Colman Smith (1878–1951), mazzo pubblicato nel 1909, di pubblico dominio; scansione di un esemplare «Roses & Lilies» (Saskia Jansen), condivisa su Wikimedia Commons. L’immagine è stata solo ridimensionata.';

  @override
  String get numerologyIntro =>
      'Inserisci la tua data di nascita e, se vuoi, il tuo nome completo. Salvati come profilo, sbloccano l’oroscopo di oggi, il tuo numero del giorno, i tuoi tre grandi e il tuo segno cinese. I dati restano solo su questo telefono.';

  @override
  String get birthDate => 'Data di nascita';

  @override
  String get birthDateHelp => 'Solo cifre: giorno, mese, anno, es. 15071990';

  @override
  String get fullNameOptional => 'Nome completo (facoltativo)';

  @override
  String get fullNameHelp =>
      'Serve solo per i numeri ricavati dalle lettere. Sono supportate le lettere accentate italiane (à è é ì ò ù) e quelle polacche, tedesche, francesi e spagnole; spazi, trattini e apostrofi vengono ignorati.';

  @override
  String get personalYearFor => 'Anno personale per:';

  @override
  String get previousYear => 'Anno precedente';

  @override
  String get nextYear => 'Anno successivo';

  @override
  String get calculate => 'Calcola';

  @override
  String get saveAsProfile => 'Salva come mio profilo';

  @override
  String get profileSaved => 'Salvato su questo dispositivo.';

  @override
  String get portrait => 'Ritratto numerologico';

  @override
  String get portraitNote =>
      'Apri un numero per vedere il calcolo e la sua interpretazione simbolica. I risultati seguono la convenzione descritta nella Biblioteca («Come calcoliamo»).';

  @override
  String indicatorName(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'lifePath': 'Cammino di vita',
      'birthDay': 'Numero del giorno di nascita',
      'expression': 'Numero dell’espressione',
      'soulUrge': 'Numero dell’anima',
      'personality': 'Numero della personalità',
      'personalYear': 'Anno personale',
      'personalDay': 'Numero del giorno',
      'relation': 'Numero di relazione',
      'personalMonth': 'Mese personale',
      'maturity': 'Numero della maturità',
      'house': 'Numero della casa',
      'other': 'Numero',
    });
    return '$_temp0';
  }

  @override
  String get noBasis => 'Niente da calcolare';

  @override
  String get calculation => 'Calcolo';

  @override
  String get symbolicInterpretation => 'Interpretazione simbolica';

  @override
  String get enterDateOrName =>
      'Inserisci una data di nascita o un nome completo.';

  @override
  String get dateInvalid =>
      'Questa data non esiste. Controlla il giorno e il mese.';

  @override
  String get dateFuture => 'La data non può essere nel futuro.';

  @override
  String get nameNoLetters => 'Inserisci almeno una lettera.';

  @override
  String nameUnsupported(String chars) {
    return 'Caratteri non supportati: $chars. Inserisci la grafia in alfabeto latino (una traslitterazione) che vuoi usare per il calcolo.';
  }

  @override
  String get cardOfDay => 'Carta del giorno';

  @override
  String get cardOfDayNote =>
      'La carta del giorno resta la stessa fino alla fine della giornata secondo l’orologio di questo dispositivo.';

  @override
  String get promptOfDay => 'Domanda del giorno';

  @override
  String yourPersonalYear(int year) {
    final intl.NumberFormat yearNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String yearString = yearNumberFormat.format(year);

    return 'Il tuo anno personale $yearString';
  }

  @override
  String get search => 'Cerca carte, termini, articoli';

  @override
  String get bookmarks => 'Preferiti';

  @override
  String get articles => 'Articoli';

  @override
  String cardsCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Carte ($n)',
      one: 'Carta (1)',
    );
    return '$_temp0';
  }

  @override
  String get archetypes => 'Archetipi';

  @override
  String get archetypesNote =>
      'Le descrizioni dei 12 archetipi sono testi originali di questa app. La suddivisione in sé riprende un noto insieme di dodici archetipi: uno dei tanti modi possibili di suddividere le cose, non un canone né un test psicologico.';

  @override
  String get aboutModel => 'Sul modello';

  @override
  String get archetypeGifts => 'Doni';

  @override
  String get archetypeShadow => 'Ombra';

  @override
  String get glossary => 'Glossario';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get allowReversed => 'Carte rovesciate';

  @override
  String get allowReversedRule =>
      'Se attivo, ogni carta estratta è rovesciata in modo indipendente con una probabilità su due.';

  @override
  String get profile => 'Il mio profilo';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyBody =>
      'Non creiamo account e non inviamo a nessun server le tue date, i tuoi nomi o le tue voci. I dati restano solo su questo dispositivo, a meno che tu non li esporti.';

  @override
  String get deleteAllTitle => 'Elimina tutti i dati';

  @override
  String get deleteAllBody =>
      'Rimuoveremo da questo dispositivo il tuo diario, il profilo, i preferiti, la carta del giorno e le impostazioni. L’azione non si può annullare.';

  @override
  String get deleteAllFailed =>
      'Non è stato possibile eliminare tutti i dati. Riprova.';

  @override
  String get sourcesBody =>
      'Le interpretazioni, le domande, gli archetipi e gli articoli sono testi originali. Illustrazioni delle carte: Pamela Colman Smith, mazzo del 1909 (pubblico dominio), scansioni da Wikimedia Commons; i dettagli sono indicati con ogni carta. Le fonti storiche sono elencate in fondo agli articoli. Questa app non è affiliata a U.S. Games Systems, Inc.';

  @override
  String get purchases => 'Digi Witch Pro';

  @override
  String get help => 'Aiuto';

  @override
  String get helpBody =>
      'Se stai attraversando una crisi, rivolgiti a un professionista della salute mentale o a un servizio di ascolto: in Italia, Telefono Amico Italia, 02 2327 2327 (gratuito, di solito attivo ogni giorno dalle 10 alle 24). In caso di emergenza chiama il 112.';

  @override
  String get versions => 'Versioni';

  @override
  String get algorithm => 'algoritmo';

  @override
  String get contentVer => 'contenuti';

  @override
  String get disclaimer =>
      'Questi contenuti sono pensati per l’intrattenimento, l’apprendimento e la riflessione su di sé. Non costituiscono consulenza medica, psicologica, legale o finanziaria.';

  @override
  String get proShort =>
      'Acquisto una tantum: niente pubblicità, stese in più.';

  @override
  String get proTitle => 'Digi Witch Pro';

  @override
  String get proBenefits =>
      '• Nessuna pubblicità in tutta l’app\n• Stese extra: «Relazione» (6 carte) e «Croce della riflessione» (10 carte)\n• Pagamento unico, senza abbonamento';

  @override
  String get proFreeStays =>
      'La numerologia, la carta del giorno, le stese da 1, 3 e 5 carte, la biblioteca e il diario restano gratuiti. Acquistare Pro non influisce su quali carte vengono estratte né su come si calcolano i risultati.';

  @override
  String get proActive => 'Hai Pro. Grazie!';

  @override
  String get proUnavailable =>
      'L’acquisto al momento non è disponibile. Controlla la connessione a internet e riprova più tardi.';

  @override
  String proBuy(String price) {
    return 'Acquista Pro a $price';
  }

  @override
  String get purchaseError =>
      'L’acquisto non è stato completato. Non ti è stato addebitato nulla, a meno che lo store non abbia confermato la transazione.';

  @override
  String get restorePurchases => 'Ripristina gli acquisti';

  @override
  String get proOnly => 'Disponibile in Pro';

  @override
  String get adPrivacyOptions => 'Impostazioni privacy per la pubblicità';

  @override
  String get privacyPolicy => 'Informativa sulla privacy';

  @override
  String get reminder => 'Promemoria quotidiano';

  @override
  String get reminderOff => 'Disattivato';

  @override
  String reminderAt(String time) {
    return 'Ogni giorno alle $time';
  }

  @override
  String get reminderTitle => 'Digi Witch';

  @override
  String get reminderBody => 'Un momento per riflettere, se ti va.';

  @override
  String get reminderDenied =>
      'Le notifiche non sono consentite. Puoi consentirle nelle impostazioni di sistema.';

  @override
  String get proStoreNote =>
      'Il pagamento ed eventuali rimborsi sono gestiti dall’App Store o da Google Play secondo le loro regole. L’acquisto funziona sia che tu acconsenta alla pubblicità sia che no.';

  @override
  String get horoscopeToday => 'Oggi';

  @override
  String get horoscopeStars => 'Dicono le stelle';

  @override
  String get horoscopeCaution => 'Attenzione a';

  @override
  String moonIn(String sign, String phase) {
    return 'Luna in $sign, $phase.';
  }

  @override
  String get luckyNumbers => 'Numeri fortunati del giorno';

  @override
  String get luckyNote =>
      'Per gioco: i numeri derivano dalla tua data di nascita e dalla data di oggi, quindi restano gli stessi tutto il giorno. Non predicono vincite.';

  @override
  String get whyThis => 'Da dove viene';

  @override
  String whySign(
    String sign,
    String dates,
    String element,
    String chinese,
    String chineseText,
  ) {
    return 'Il tuo segno: $sign ($dates), elemento: $element. Segno cinese: $chinese. $chineseText';
  }

  @override
  String whyMoon(String sign, String element, String relation) {
    String _temp0 = intl.Intl.selectLogic(relation, {
      'same': 'lo stesso elemento',
      'supportive': 'di sostegno',
      'tense': 'di tensione',
      'other': 'neutro',
    });
    return 'A mezzogiorno di oggi la Luna è in $sign (elemento: $element). Rapporto con il tuo elemento: $_temp0.';
  }

  @override
  String get whyMethod =>
      'La posizione della Luna è calcolata con formule astronomiche, offline (precisione di circa 0,5°). Il testo «Oggi» dipende dal rapporto tra gli elementi, «Dicono le stelle» dalla fase della Luna e «Attenzione a» dal tuo numero del giorno.';

  @override
  String get horoscopeNeedsBirth =>
      'Inserisci la tua data di nascita e vedrai subito il tuo segno, l’oroscopo di oggi, il tuo numero del giorno e i tuoi numeri fortunati.';

  @override
  String get moonToday => 'La Luna oggi';

  @override
  String moonState(String phase, int percent, String sign) {
    return '$phase · $percent% illuminata · in $sign';
  }

  @override
  String get moonCalendar => 'Calendario lunare';

  @override
  String get moonCalendarIntro =>
      'Le prossime fasi principali della Luna, in ora locale (precisione di circa 1 ora).';

  @override
  String get compatibility => 'Compatibilità di due persone';

  @override
  String get compatIntro =>
      'Inserisci due date di nascita. Confronteremo segni zodiacali, elementi, segni cinesi e numeri del cammino di vita. È un gioco e uno spunto di conversazione, non un verdetto su una relazione.';

  @override
  String personDate(int n) {
    return 'Data di nascita: persona $n';
  }

  @override
  String get check => 'Confronta';

  @override
  String get compatElements => 'Elementi';

  @override
  String personLine(
    int n,
    String sign,
    String element,
    String chinese,
    int lifePath,
  ) {
    return 'Persona $n: $sign ($element) · segno cinese: $chinese · cammino di vita $lifePath';
  }

  @override
  String get birthCardTitle => 'Carta di nascita';

  @override
  String get birthCardNote =>
      'Metodo: giorno + mese + anno di nascita, poi si sommano le cifre finché il risultato non supera 22 (22 = Il Matto). Un risultato a due cifre dà anche una carta compagna.';

  @override
  String get birthCardSecond => 'Carta compagna';

  @override
  String yesNoAnswer(String a) {
    String _temp0 = intl.Intl.selectLogic(a, {
      'yes': 'La risposta delle carte: SÌ',
      'no': 'La risposta delle carte: NO',
      'other':
          'La risposta delle carte: INCERTO. La questione è ancora in bilico',
    });
    return '$_temp0';
  }

  @override
  String get horoscopeFor => 'Oggi per te';

  @override
  String get licenses => 'Licenze (caratteri e librerie)';

  @override
  String get cardAdvice => 'Il consiglio della carta';

  @override
  String get correspondences =>
      'Corrispondenze astrologiche (Golden Dawn, XIX secolo)';

  @override
  String get chooseSpread => 'Scegli una stesa';

  @override
  String get tapDeck => 'Tieni a mente la tua domanda e tocca il mazzo';

  @override
  String spreadCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n carte',
      one: '1 carta',
    );
    return '$_temp0';
  }

  @override
  String get bigThree => 'I tuoi tre grandi';

  @override
  String get bigThreeIntro =>
      'Il Sole è il tuo segno zodiacale. La Luna descrive le tue emozioni e l’ascendente descrive come ti vedono gli altri. Per la Luna di solito basta la data; per l’ascendente servono l’ora e il luogo di nascita. I dati restano solo su questo dispositivo.';

  @override
  String get birthTime => 'Ora di nascita';

  @override
  String get notGiven => 'non indicata';

  @override
  String get birthPlace => 'Luogo di nascita';

  @override
  String get placesNote =>
      'Città della Polonia e grandi città del mondo. Se la tua manca, scegli la più vicina nello stesso paese oppure inserisci le coordinate. Qualche decina di chilometri cambia l’ascendente di meno di 1°.';

  @override
  String get sunLabel => 'Sole';

  @override
  String get moonLabel => 'Luna';

  @override
  String get ascLabel => 'Ascendente';

  @override
  String moonTwoSigns(String a, String b) {
    return 'Quel giorno la Luna ha cambiato segno: $a o $b, a seconda dell’ora di nascita.';
  }

  @override
  String get ascNeeds =>
      'Inserisci l’ora e il luogo di nascita per calcolare l’ascendente.';

  @override
  String traceTime(String local, String utc, String zone) {
    return 'Ora locale $local → $utc UTC (fuso $zone, con la storia dell’ora legale).';
  }

  @override
  String traceMoon(String deg, String sign) {
    return 'Longitudine eclittica della Luna: $deg° → $sign.';
  }

  @override
  String traceAsc(
    String deg,
    String sign,
    String place,
    String lat,
    String lon,
  ) {
    return 'Ascendente: $deg° → $sign ($place, $lat° N, $lon° E).';
  }

  @override
  String get needBirthDate =>
      'Prima salva la tua data di nascita nella scheda Numeri (il pulsante «Salva come mio profilo»).';

  @override
  String get clear => 'Cancella';

  @override
  String get chineseTitle => 'Oroscopo cinese';

  @override
  String chineseBirthYear(int year, String element, String yy) {
    String _temp0 = intl.Intl.selectLogic(yy, {'yang': 'yang', 'other': 'yin'});
    return 'Anno nel calendario cinese: $year · $element · $_temp0';
  }

  @override
  String get chineseNewYearNote =>
      'Il Capodanno cinese cade tra il 21 gennaio e il 20 febbraio. Se sei nato prima, appartieni al segno dell’anno precedente. Qui questo è già considerato.';

  @override
  String chineseCurrentYear(int year, String animal, String element) {
    return 'Anno $year: $animal · $element';
  }

  @override
  String chineseYearSince(String date) {
    return 'L’attuale anno cinese è iniziato il $date.';
  }

  @override
  String get chineseCompatTitle => 'Compatibilità dei segni cinesi';

  @override
  String get chineseFriend => 'Amico segreto';

  @override
  String get chineseTrine => 'Trigono di alleati';

  @override
  String get chineseClash => 'Segno opposto';

  @override
  String get chineseElement => 'Elemento dell’anno di nascita';

  @override
  String get mercuryRetro => 'Mercurio retrogrado';

  @override
  String mercuryNow(String date) {
    return 'Mercurio retrogrado fino al $date';
  }

  @override
  String get mercuryNone =>
      'Nessun periodo di retrogradazione nel prossimo anno.';

  @override
  String get upcomingPhases => 'Prossime fasi';

  @override
  String get dayByDay => 'Giorno per giorno (30 giorni)';

  @override
  String moonDayLine(String sign, String phase) {
    return 'Luna in $sign · $phase';
  }

  @override
  String get dreams => 'Dizionario dei sogni';

  @override
  String dreamsCount(int n) {
    return '$n simboli dei sogni: che cosa può dirti un sogno su di te';
  }

  @override
  String get dreamsIntro =>
      'I sogni non predicono il futuro. Il dizionario suggerisce a che cosa viene spesso associato un simbolo, e la domanda ti aiuta a capire che cosa significa per te. Ciò che conta di più è come ti sei sentito nel sogno.';

  @override
  String get dreamsSearch => 'Cerca un simbolo, es. acqua, denti, casa';

  @override
  String get dreamsEmpty =>
      'Nessun simbolo di questo tipo. Prova una parola simile, oppure annota il sogno nel diario.';

  @override
  String chineseSignButton(String animal) {
    return 'Segno cinese: $animal';
  }

  @override
  String get otherPlace => 'Altro luogo: inserisci le coordinate';

  @override
  String otherPlaceSet(String place, String zone) {
    return 'Altro luogo: $place ($zone)';
  }

  @override
  String get otherPlaceHelp =>
      'Le coordinate si trovano in un’app di mappe (per esempio toccando un luogo su Google Maps). Sud e ovest si inseriscono con il segno meno. Il fuso orario è una regione, es. Europe/Rome, America/Chicago.';

  @override
  String get latitude => 'Latitudine';

  @override
  String get longitude => 'Longitudine';

  @override
  String get timeZone => 'Fuso orario';

  @override
  String get otherPlaceMissing =>
      'Inserisci latitudine, longitudine e fuso orario.';

  @override
  String get otherPlaceRange =>
      'La latitudine deve essere tra -66° e 66° (oltre i circoli polari l’ascendente può essere indefinito), la longitudine tra -180° e 180°.';

  @override
  String get numbersStartTitle => 'Parti dalla tua data di nascita';

  @override
  String get numbersEditTitle => 'Cambia i dati o calcola per un’altra persona';

  @override
  String get calculateOnce => 'Solo calcolo (senza salvare)';

  @override
  String get compatibilityHint => 'Confronta due date di nascita';

  @override
  String get yourNumbers => 'I tuoi numeri';

  @override
  String get editOrOther => 'Cambia i dati o calcola per un’altra persona';

  @override
  String get showMyHoroscope => 'Mostra il mio oroscopo';

  @override
  String get privacyShort =>
      'La data resta solo su questo telefono. Puoi cambiarla nella scheda Numeri.';

  @override
  String get explore => 'Esplora';

  @override
  String get exploreBigThree => 'Sole, Luna e ascendente';

  @override
  String get exploreChinese => 'Segno, elemento e il tuo anno';

  @override
  String get exploreTarot => 'Chiedi alle carte';

  @override
  String get exploreTarotSub => 'Stese e domande sì o no';

  @override
  String get exploreNumbersSub => 'Cammino di vita e carta di nascita';

  @override
  String get exploreMoon => 'Fasi, giardinaggio, Mercurio retrogrado';

  @override
  String get exploreDreams => 'Che cosa dice il tuo sogno';

  @override
  String get exploreLibrary =>
      '78 carte, articoli, glossario: nella Biblioteca';

  @override
  String get exploreLibraryTitle => 'Carte e articoli';

  @override
  String get squareTitle => 'Quadrato di Pitagora';

  @override
  String get squareIntro =>
      'Una griglia con le cifre della tua data di nascita (metodo di Aleksandrov): più una cifra compare, più il tratto è forte. Tocca una casella per leggerne la descrizione.';

  @override
  String get squareEmpty => 'nessuna';

  @override
  String get cyclesTitle => 'Cicli di vita: apici e sfide';

  @override
  String get cyclesIntro =>
      'La numerologia divide la vita in quattro fasi. Ognuna ha il suo «apice», un tema di crescita, e la sua «sfida», una lezione da affrontare. La durata della prima fase dipende dal tuo cammino di vita.';

  @override
  String ageRange(int from, int to) {
    return 'età $from–$to';
  }

  @override
  String ageFrom(int from) {
    return 'dall’età di $from';
  }

  @override
  String get cyclesNow => 'ORA';

  @override
  String get ichingTitle => 'Oracolo dell’I Ching';

  @override
  String get ichingIntro =>
      'Il Libro dei Mutamenti è un classico oracolo cinese. Pensa alla tua domanda, poi lancia tre monete per sei volte; l’esagramma si costruisce dal basso verso l’alto. Le linee segnate con un punto sono «mutevoli» e mostrano in che cosa si sta trasformando la situazione.';

  @override
  String ichingToss(int n) {
    return 'Lancia le monete ($n/6)';
  }

  @override
  String ichingLastToss(String sum) {
    String _temp0 = intl.Intl.selectLogic(sum, {
      '6': 'croce, croce, croce = 6 (yin antico, mutevole)',
      '7': 'due croci e una testa = 7 (yang)',
      '8': 'due teste e una croce = 8 (yin)',
      'other': 'testa, testa, testa = 9 (yang antico, mutevole)',
    });
    return 'Ultimo lancio: $_temp0';
  }

  @override
  String get ichingMeaning => 'Significato';

  @override
  String get ichingChange => 'Direzione del cambiamento';

  @override
  String ichingChangingLines(String lines) {
    return 'Linee mutevoli: $lines. La situazione si sta trasformando in:';
  }

  @override
  String get ichingAgain => 'Nuova domanda';

  @override
  String get ichingNote =>
      'Le descrizioni degli esagrammi e delle linee sono brevi interpretazioni originali di questa app, ispirate alle immagini dell’antico testo cinese. Trattale come uno spunto di riflessione.';

  @override
  String get exploreIching => 'Una domanda e sei lanci di monete';

  @override
  String get ritualsTitle => 'Rituali lunari';

  @override
  String get exploreRituals => 'Intenzioni per la luna nuova e la luna piena';

  @override
  String get ritualsIntro =>
      'La luna nuova e la luna piena scandiscono il ritmo del mese. Alla luna nuova annota un’intenzione, e alla luna piena guarda indietro a ciò che è successo. Le tue note finiscono nel diario.';

  @override
  String get moonRemindersToggle => 'Ricordami la luna nuova e la luna piena';

  @override
  String get moonRemindersNote =>
      'Una notifica alle 9:00 nel giorno della luna nuova e della luna piena. Funziona offline.';

  @override
  String get moonReminderNewTitle =>
      'Luna nuova: è il momento di un’intenzione';

  @override
  String get moonReminderNewBody =>
      'Scrivi che cosa vuoi iniziare in questo ciclo.';

  @override
  String get moonReminderFullTitle =>
      'Luna piena: è il momento di guardare indietro';

  @override
  String get moonReminderFullBody =>
      'Che cosa è andato bene dalla luna nuova? Di che cosa sei grato?';

  @override
  String get forYouToday => 'Solo per te';

  @override
  String get advice => 'Consiglio';

  @override
  String get karmicTitle => 'Il karma nei numeri';

  @override
  String get karmicIntro =>
      'I debiti karmici sono i numeri 13, 14, 16 e 19 che compaiono lungo il calcolo dei tuoi numeri. Le lezioni karmiche sono le cifre che mancano nel tuo nome completo. Nella tradizione descrivono temi su cui lavorare, non verdetti.';

  @override
  String get karmicNone => 'Nessun debito karmico nei tuoi numeri.';

  @override
  String get karmicLessonsTitle =>
      'Lezioni karmiche (cifre che mancano nel tuo nome)';

  @override
  String get houseTitle => 'Numerologia della casa e del telefono';

  @override
  String get houseHint => 'Numero di casa, appartamento o telefono, es. 12A';

  @override
  String luckyMeaning(int n, int reduced, String keywords) {
    return '$n → $reduced: $keywords';
  }

  @override
  String dayColor(String color) {
    return 'Colore del giorno: $color';
  }

  @override
  String signExtras(String color, String stone, String day, String planet) {
    return 'Colore: $color · pietra: $stone · giorno: $day · pianeta: $planet';
  }

  @override
  String get periodTitle => 'Oroscopo della settimana e del mese';

  @override
  String get explorePeriod => 'Giorni chiave e il tuo mese personale';

  @override
  String get periodIntro =>
      'Calcolato sul cielo reale: le fasi della Luna, le eclissi, Mercurio retrogrado, l’ingresso del Sole nel segno successivo e i giorni in cui la Luna è nel tuo segno, più i tuoi numeri personali.';

  @override
  String get tabWeek => 'Settimana';

  @override
  String get tabMonth => 'Mese';

  @override
  String get weekGeneral => 'In generale';

  @override
  String get keyDays => 'Giorni chiave';

  @override
  String get noKeyDays =>
      'In questo periodo non ci sono eventi particolari nel cielo. È un buon momento per un lavoro calmo e costante.';

  @override
  String evPhase(String phase) {
    return '$phase';
  }

  @override
  String evMoonInSign(String sign) {
    return 'Luna nel tuo segno ($sign)';
  }

  @override
  String evSunIngress(String sign) {
    return 'Il Sole entra in $sign';
  }

  @override
  String get evMercuryStart => 'Mercurio diventa retrogrado';

  @override
  String get evMercuryEnd => 'Mercurio torna diretto';

  @override
  String evEclipse(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'solar': 'Eclissi solare',
      'partial': 'Eclissi lunare (parziale o totale)',
      'other': 'Eclissi lunare penombrale (lieve)',
    });
    return '$_temp0';
  }

  @override
  String dayNumberLine(int n, String title) {
    return 'Numero del giorno $n: $title';
  }

  @override
  String get eclipsesTitle => 'Eclissi nel prossimo anno';

  @override
  String get eclipseVisibility =>
      'La visibilità dipende da dove ti trovi sulla Terra: non tutte le eclissi si vedono dal tuo luogo.';

  @override
  String eclipseSoon(String when) {
    return 'Si avvicina un’eclissi: $when';
  }

  @override
  String get loveLabel => 'Amore';

  @override
  String get workLabel => 'Lavoro';

  @override
  String get wellbeingLabel => 'Benessere';

  @override
  String ichingImage(String upper, String lower) {
    return 'Immagine: $upper sopra $lower';
  }

  @override
  String get ichingLinesTitle => 'Linee mutevoli';

  @override
  String ichingLine(int n, String text) {
    return 'Linea $n: $text';
  }

  @override
  String get revealCard => 'Scopri la carta';

  @override
  String get revealCardHint =>
      'Tocca la carta per vedere cosa porta la giornata.';

  @override
  String get cardOfDayMore => 'Di più sulla carta';

  @override
  String get moodQuestion => 'Come ti senti oggi?';

  @override
  String moodName(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      '1': 'Pesante',
      '2': 'Giù',
      '3': 'Così così',
      '4': 'Bene',
      'other': 'Benissimo',
    });
    return '$_temp0';
  }

  @override
  String get moodSaved => 'Salvato solo su questo dispositivo.';

  @override
  String countdown(String what, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'tra $days giorni',
      one: 'domani',
      zero: 'oggi',
    );
    return '$what $_temp0';
  }

  @override
  String get yourBirthday => 'Il tuo compleanno';

  @override
  String notifMoon(String sign) {
    return 'Luna in $sign';
  }

  @override
  String notifDayNumber(int n) {
    return 'numero del giorno $n';
  }

  @override
  String get notifCard => 'ti aspetta la tua carta del giorno';

  @override
  String get tabStars => 'Stelle';

  @override
  String get starsMore => 'Di più dalle stelle';

  @override
  String get deckTitle => 'Il mazzo';

  @override
  String get fullHoroscope => 'Oroscopo completo';

  @override
  String get upcoming => 'In arrivo';

  @override
  String get suggested => 'Consigliato oggi';

  @override
  String get suggestBigThree =>
      'Aggiungi ora e luogo di nascita per scoprire la tua Luna e il tuo ascendente';

  @override
  String get dayNumberShort => 'numero del giorno';

  @override
  String get dayColorShort => 'colore del giorno';

  @override
  String get fullNumerology => 'Numerologia completa e ritratto';

  @override
  String get firstEntry => 'Scrivi un primo pensiero';

  @override
  String get greetDay => 'Buongiorno';

  @override
  String get greetEvening => 'Buonasera';

  @override
  String get dayHoroscope => 'Oroscopo';

  @override
  String get dayNumbers => 'I miei numeri';

  @override
  String get dayCard => 'Carta';

  @override
  String get dayDone => 'Per oggi è tutto fatto.';

  @override
  String tomorrowIs(String what) {
    return 'Domani: $what.';
  }

  @override
  String tomorrowMoon(String sign) {
    return 'Domani: Luna in $sign.';
  }

  @override
  String tomorrowNumber(int n) {
    return 'Domani: una nuova carta e il numero del giorno $n.';
  }

  @override
  String get tomorrowCard => 'Domani: una nuova carta del giorno.';

  @override
  String get tabDreams => 'Sogni';

  @override
  String get dreamAsk => 'Che cosa hai sognato stanotte?';

  @override
  String get dreamAskHint =>
      'Annota il sogno prima che svanisca, oppure cerca un simbolo qui sotto.';

  @override
  String get dreamSave => 'Annota il sogno';

  @override
  String get dreamEntry => 'Sogno';

  @override
  String get dreamOfDay => 'Simbolo del giorno';

  @override
  String get dreamsAll => 'Tutti i simboli';

  @override
  String get widgetCardWaiting => 'In attesa di essere scoperta';

  @override
  String get widgetStale => 'Tocca per vedere la tua giornata';

  @override
  String widgetCardSays(String advice) {
    return 'La carta dice: $advice';
  }

  @override
  String get widgetNeedBirth =>
      'Inserisci la tua data di nascita per vedere la tua giornata.';

  @override
  String get language => 'Lingua';

  @override
  String get dateHint => 'GG.MM.AAAA';

  @override
  String get layTarot => 'Fai una stesa';

  @override
  String get tarotWelcomeTitle => 'Che cosa suggeriranno oggi le carte?';

  @override
  String get tarotWelcomeBody =>
      'Pensa a ciò che hai in mente, scegli una stesa e gira le carte. Ogni stesa è uno sguardo nuovo. Torna ogni volta che nasce una nuova domanda.';

  @override
  String get seeDeck => 'Vedi il mazzo';

  @override
  String get tarotWelcomeSetting => 'Introduzione nella scheda Tarocchi';

  @override
  String get hide => 'Nascondi';

  @override
  String get tapHint => 'tocca';

  @override
  String get dailyMood => 'Come potresti sentirti oggi';

  @override
  String get dailyEvents => 'Che cosa può portare oggi';

  @override
  String get dailyAdvice => 'Consiglio per oggi';

  @override
  String get energyLabel => 'Energia';

  @override
  String meterValue(String label, int n) {
    return '$label: $n su 5';
  }

  @override
  String get cheerAll => 'Una bella giornata — le stelle sono dalla tua parte';

  @override
  String get cheerLove => 'Un buon giorno per il cuore';

  @override
  String get cheerWork => 'Un buon giorno per concludere le cose';

  @override
  String get cheerEnergy => 'Una giornata piena di energia';

  @override
  String get cheerUpLove => 'L’amore si presenta meglio di ieri';

  @override
  String get cheerUpWork => 'Il lavoro si presenta meglio di ieri';

  @override
  String get cheerUpEnergy => 'Più energia di ieri';

  @override
  String get cheerNewMoon =>
      'Luna nuova — un buon momento per una nuova intenzione';

  @override
  String get cheerWaxing => 'La Luna cresce, e con lei i tuoi progetti';

  @override
  String get cheerFullMoon =>
      'Luna piena — è il momento di apprezzare ciò che hai già';

  @override
  String get cheerWaning =>
      'La Luna cala — è più facile lasciar andare ciò che ti pesa';

  @override
  String get cheerNewMoon2 =>
      'Luna nuova — una pagina pulita. Scrivici qualcosa di bello';

  @override
  String get cheerNewMoon3 =>
      'Luna nuova — le idee migliori nascono nel silenzio';

  @override
  String get cheerWaxing2 =>
      'La Luna cresce — un buon momento per aggiungere piccoli passi';

  @override
  String get cheerWaxing3 => 'La Luna crescente favorisce ciò che inizi';

  @override
  String get cheerFullMoon2 =>
      'Luna piena — oggi vedi di più. Anche ciò che è andato bene';

  @override
  String get cheerFullMoon3 =>
      'Luna piena — una buona sera per festeggiare le piccole cose';

  @override
  String get cheerWaning2 =>
      'La Luna cala — un buon momento per mettere in ordine e respirare';

  @override
  String get cheerWaning3 =>
      'La Luna calante favorisce il riposo e il portare a termine le cose';

  @override
  String get threeGood => 'Annota tre cose belle';

  @override
  String get threeGoodPrompt =>
      'Tre cose belle di questa settimana — e che cosa le ha rese possibili:';

  @override
  String moodReply(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      '1': 'I giorni difficili capitano. Oggi non devi recuperare niente.',
      '2': 'Anche una giornata più debole va bene. Basta un piccolo passo.',
      '3': 'Anche un giorno qualunque conta.',
      '4': 'Che bello sentirlo.',
      'other': 'Che bello. Vale la pena ricordare che cosa l’ha reso tale.',
    });
    return '$_temp0';
  }

  @override
  String get reminderAsk =>
      'Vuoi che la carta del giorno ti aspetti ogni mattina?';

  @override
  String get reminderAskSub =>
      'Una notifica al giorno alle 8:00, con i contenuti della giornata. Cambia l’orario o disattivala nelle Impostazioni.';

  @override
  String get reminderYes => 'Sì, ricordamelo';

  @override
  String get reminderNo => 'No, grazie';

  @override
  String get onboardBirthHint =>
      'Facoltativo. Con la data vedrai subito il tuo segno, l’oroscopo e i numeri.';

  @override
  String get lookBack => 'I tuoi giorni';

  @override
  String get lookBackHint =>
      'Carte del giorno e umore, giorno per giorno. Salvati solo su questo dispositivo.';
}
