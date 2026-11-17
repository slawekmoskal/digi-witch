// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Digi Witch';

  @override
  String get tabToday => 'Aujourd’hui';

  @override
  String get tabNumerology => 'Nombres';

  @override
  String get tabTarot => 'Tarot';

  @override
  String get tabLibrary => 'Bibliothèque';

  @override
  String get tabJournal => 'Journal';

  @override
  String get settings => 'Réglages';

  @override
  String get start => 'C’est parti';

  @override
  String get onboardWhat =>
      'Votre guide quotidien des symboles : horoscope du jour, Lune, tarot, numérologie, signe chinois et dictionnaire des rêves. Chaque calcul est détaillé étape par étape, et chaque carte est expliquée dans la bibliothèque.';

  @override
  String get onboardNot =>
      'Cette application est un outil de divertissement, de découverte des symboles et de réflexion personnelle. Elle ne prédit pas l’avenir, ne mesure pas la personnalité au sens scientifique et ne remplace pas l’avis d’un professionnel.';

  @override
  String get onboardPrivacy =>
      'Aucun compte n’est nécessaire. Les dates, les noms et votre journal restent sur cet appareil.';

  @override
  String get onboardAdults => 'Cette application est destinée aux adultes.';

  @override
  String get reversed => 'renversée';

  @override
  String get writeReflection => 'Noter une réflexion dans le journal';

  @override
  String get exportJournal => 'Exporter le journal';

  @override
  String get newEntry => 'Nouvelle note';

  @override
  String get editEntry => 'Note';

  @override
  String get journalEmpty =>
      'Votre journal est vide. Notez une première pensée, par exemple à partir de la question du jour ou d’une carte tirée.';

  @override
  String get journalPrivacy =>
      'Les notes sont enregistrées uniquement sur cet appareil.';

  @override
  String get deleteEntryConfirm =>
      'Supprimer cette note ? Cette action est irréversible.';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get save => 'Enregistrer';

  @override
  String get linkedResult => 'Résultat associé';

  @override
  String get promptsTitle => 'Une question pour commencer (facultatif)';

  @override
  String promptCategory(String c) {
    String _temp0 = intl.Intl.selectLogic(c, {
      'ogolne': 'Général',
      'rodzina': 'Famille',
      'tarot': 'Tarot',
      'liczby': 'Nombres',
      'other': 'Autre',
    });
    return '$_temp0';
  }

  @override
  String get randomPrompt => 'Question au hasard';

  @override
  String get familyNote =>
      'N’écrivez que ce que vous avez envie de partager. Vous pouvez utiliser des surnoms à la place des prénoms de vos proches.';

  @override
  String get entryHint => 'Vos pensées…';

  @override
  String get tarotIntro =>
      'Nous voyons les cartes comme une invitation à la réflexion, pas comme une prédiction. Les positions d’un tirage sont des questions à se poser.';

  @override
  String get drawCards => 'Tirer les cartes';

  @override
  String get drawAgain => 'Nouveau tirage';

  @override
  String get reversedOn =>
      'Cartes renversées : activées (chaque carte indépendamment, avec une chance sur deux).';

  @override
  String get reversedOff =>
      'Cartes renversées : désactivées. Vous pouvez les activer dans les réglages.';

  @override
  String get spreadReflectionPrompt =>
      'Qu’est-ce qui m’a le plus touché dans ce tirage, et pourquoi ?';

  @override
  String get questionLabel => 'Votre question (facultatif)';

  @override
  String get questionHint =>
      'p. ex. À quoi dois-je faire attention en changeant de travail ?';

  @override
  String get readingTitle => 'Ce que les cartes disent de votre question';

  @override
  String get readingTitleNoQuestion => 'Synthèse du tirage';

  @override
  String get summaryMajors =>
      'Les arcanes majeurs dominent : il s’agit de quelque chose d’important, qui dépasse les décisions du quotidien.';

  @override
  String summarySuit(String suit) {
    String _temp0 = intl.Intl.selectLogic(suit, {
      'wands': 'Surtout des Bâtons : l’énergie, l’action et l’initiative sont en toile de fond.',
      'cups': 'Surtout des Coupes : les émotions, les sentiments et les relations sont en toile de fond.',
      'swords': 'Surtout des Épées : les pensées, les décisions et les conversations difficiles sont en toile de fond.',
      'pentacles': 'Surtout des Deniers : le travail, l’argent et les questions pratiques sont en toile de fond.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get summaryReversed =>
      'La plupart des cartes sont renversées : quelque chose est peut-être bloqué, retardé ou vécu davantage à l’intérieur qu’à l’extérieur.';

  @override
  String get summaryBalanced =>
      'Les cartes sont réparties de façon équilibrée : aucun domaine ne domine nettement.';

  @override
  String summaryAnswer(String position, String card, String advice) {
    return 'La réponse des cartes : $card en position « $position » : $advice';
  }

  @override
  String get addBookmark => 'Ajouter un favori';

  @override
  String get removeBookmark => 'Retirer le favori';

  @override
  String get group => 'Groupe';

  @override
  String get keywords => 'Mots-clés';

  @override
  String get symbolism => 'Symbolique';

  @override
  String get upright => 'Sens à l’endroit';

  @override
  String get reversedMeaning => 'Sens renversé';

  @override
  String get reflectionQuestions => 'Questions de réflexion';

  @override
  String get reflectionQuestion => 'Question de réflexion';

  @override
  String get sourcesAndRights => 'Sources et droits';

  @override
  String get cardSourceNote =>
      'Les descriptions des cartes sont des textes originaux écrits pour cette application. Illustration : Pamela Colman Smith (1878–1951), jeu publié en 1909, dans le domaine public ; numérisation d’un exemplaire « Roses & Lilies » (Saskia Jansen), partagée sur Wikimedia Commons. L’image a seulement été redimensionnée.';

  @override
  String get numerologyIntro =>
      'Saisissez votre date de naissance et, si vous le souhaitez, votre nom complet. Enregistrés comme profil, ils donnent accès à l’horoscope du jour, à votre nombre du jour, à votre trio astral et à votre signe chinois. Les données restent uniquement sur ce téléphone.';

  @override
  String get birthDate => 'Date de naissance';

  @override
  String get birthDateHelp =>
      'Chiffres uniquement : jour, mois, année, p. ex. 15071990';

  @override
  String get fullNameOptional => 'Nom complet (facultatif)';

  @override
  String get fullNameHelp =>
      'Nécessaire uniquement pour les nombres calculés à partir des lettres. Les accents et la cédille sont pris en charge ; les espaces, traits d’union et apostrophes sont ignorés.';

  @override
  String get personalYearFor => 'Année personnelle pour :';

  @override
  String get previousYear => 'Année précédente';

  @override
  String get nextYear => 'Année suivante';

  @override
  String get calculate => 'Calculer';

  @override
  String get saveAsProfile => 'Enregistrer comme mon profil';

  @override
  String get profileSaved => 'Enregistré sur cet appareil.';

  @override
  String get portrait => 'Portrait numérologique';

  @override
  String get portraitNote =>
      'Dépliez un nombre pour voir le calcul et son interprétation symbolique. Les résultats suivent la convention décrite dans la bibliothèque (« Comment nous calculons »).';

  @override
  String indicatorName(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'lifePath': 'Chemin de vie',
      'birthDay': 'Nombre du jour de naissance',
      'expression': 'Nombre d’expression',
      'soulUrge': 'Nombre intime',
      'personality': 'Nombre de personnalité',
      'personalYear': 'Année personnelle',
      'personalDay': 'Nombre du jour',
      'relation': 'Nombre de la relation',
      'personalMonth': 'Mois personnel',
      'maturity': 'Nombre de maturité',
      'house': 'Nombre de la maison',
      'other': 'Nombre',
    });
    return '$_temp0';
  }

  @override
  String get noBasis => 'Rien à calculer';

  @override
  String get calculation => 'Calcul';

  @override
  String get symbolicInterpretation => 'Interprétation symbolique';

  @override
  String get enterDateOrName =>
      'Saisissez une date de naissance ou un nom complet.';

  @override
  String get dateInvalid =>
      'Cette date n’existe pas. Vérifiez le jour et le mois.';

  @override
  String get dateFuture => 'La date ne peut pas être dans le futur.';

  @override
  String get nameNoLetters => 'Saisissez au moins une lettre.';

  @override
  String nameUnsupported(String chars) {
    return 'Caractères non pris en charge : $chars. Saisissez l’orthographe en alphabet latin (translittération) à utiliser pour le calcul.';
  }

  @override
  String get cardOfDay => 'Carte du jour';

  @override
  String get cardOfDayNote =>
      'La carte du jour reste la même jusqu’à la fin de la journée, selon l’horloge de cet appareil.';

  @override
  String get promptOfDay => 'Question du jour';

  @override
  String yourPersonalYear(int year) {
    final intl.NumberFormat yearNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String yearString = yearNumberFormat.format(year);

    return 'Votre année personnelle $yearString';
  }

  @override
  String get search => 'Rechercher cartes, termes, articles';

  @override
  String get bookmarks => 'Favoris';

  @override
  String get articles => 'Articles';

  @override
  String cardsCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Cartes ($n)',
      one: 'Carte ($n)',
    );
    return '$_temp0';
  }

  @override
  String get archetypes => 'Archétypes';

  @override
  String get archetypesNote =>
      'Les descriptions des 12 archétypes sont des textes propres à cette application. La répartition elle-même reprend un ensemble connu de douze archétypes : une répartition parmi d’autres, ni un canon ni un test psychologique.';

  @override
  String get aboutModel => 'À propos du modèle';

  @override
  String get archetypeGifts => 'Dons';

  @override
  String get archetypeShadow => 'Ombre';

  @override
  String get glossary => 'Glossaire';

  @override
  String get theme => 'Thème';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get allowReversed => 'Cartes renversées';

  @override
  String get allowReversedRule =>
      'Si l’option est activée, chaque carte tirée est renversée indépendamment, avec une chance sur deux.';

  @override
  String get profile => 'Mon profil';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get privacyBody =>
      'Nous ne créons pas de compte et n’envoyons ni vos dates, ni vos noms, ni vos notes à un serveur. Vos données restent uniquement sur cet appareil, sauf si vous les exportez vous-même.';

  @override
  String get deleteAllTitle => 'Supprimer toutes les données';

  @override
  String get deleteAllBody =>
      'Nous allons effacer de cet appareil votre journal, votre profil, vos favoris, la carte du jour et les réglages. Cette action est irréversible.';

  @override
  String get deleteAllFailed =>
      'Toutes les données n’ont pas pu être effacées. Veuillez réessayer.';

  @override
  String get sourcesBody =>
      'Les interprétations, questions, archétypes et articles sont des textes originaux. Illustrations des cartes : Pamela Colman Smith, jeu de 1909 (domaine public), numérisations issues de Wikimedia Commons ; les détails figurent avec chaque carte. Les sources historiques sont citées à la fin des articles. Cette application n’est pas affiliée à U.S. Games Systems, Inc.';

  @override
  String get purchases => 'Digi Witch Pro';

  @override
  String get help => 'Aide';

  @override
  String get helpBody =>
      'Si vous traversez une crise, contactez un professionnel de santé ou une ligne d’écoute : en France, le 3114 (numéro national de prévention du suicide), gratuit et disponible 24 h/24. En cas d’urgence, composez le 112.';

  @override
  String get versions => 'Versions';

  @override
  String get algorithm => 'algorithme';

  @override
  String get contentVer => 'contenus';

  @override
  String get disclaimer =>
      'Ces contenus servent au divertissement, à l’apprentissage et à la réflexion personnelle. Ils ne constituent pas un avis médical, psychologique, juridique ou financier.';

  @override
  String get proShort =>
      'Achat unique : sans publicité, tirages supplémentaires.';

  @override
  String get proTitle => 'Digi Witch Pro';

  @override
  String get proBenefits =>
      '• Aucune publicité dans toute l’application\n• Tirages supplémentaires : « Relation » (6 cartes) et « Croix de réflexion » (10 cartes)\n• Paiement unique, sans abonnement';

  @override
  String get proFreeStays =>
      'La numérologie, la carte du jour, les tirages à 1, 3 et 5 cartes, la bibliothèque et le journal restent gratuits. L’achat de Pro n’influence ni les cartes tirées ni le calcul des résultats.';

  @override
  String get proActive => 'Vous avez Pro. Merci !';

  @override
  String get proUnavailable =>
      'L’achat est indisponible pour le moment. Vérifiez votre connexion internet et réessayez plus tard.';

  @override
  String proBuy(String price) {
    return 'Acheter Pro pour $price';
  }

  @override
  String get purchaseError =>
      'L’achat n’a pas abouti. Vous n’avez pas été débité, sauf si la boutique a confirmé la transaction.';

  @override
  String get restorePurchases => 'Restaurer les achats';

  @override
  String get proOnly => 'Disponible avec Pro';

  @override
  String get adPrivacyOptions => 'Confidentialité des publicités';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get reminder => 'Rappel quotidien';

  @override
  String get reminderOff => 'Désactivé';

  @override
  String reminderAt(String time) {
    return 'Tous les jours à $time';
  }

  @override
  String get reminderTitle => 'Digi Witch';

  @override
  String get reminderBody => 'Un moment de réflexion, si vous en avez envie.';

  @override
  String get reminderDenied =>
      'Les notifications ne sont pas autorisées. Vous pouvez les autoriser dans les réglages du système.';

  @override
  String get proStoreNote =>
      'Le paiement et les éventuels remboursements sont gérés par l’App Store ou Google Play selon leurs propres règles. L’achat fonctionne que vous acceptiez ou non les publicités.';

  @override
  String get horoscopeToday => 'Aujourd’hui';

  @override
  String get horoscopeStars => 'Les astres disent';

  @override
  String get horoscopeCaution => 'Attention à';

  @override
  String moonIn(String sign, String phase) {
    return 'Lune en $sign, $phase.';
  }

  @override
  String get luckyNumbers => 'Nombres porte-bonheur du jour';

  @override
  String get luckyNote =>
      'Pour le plaisir : les nombres découlent de votre date de naissance et de la date du jour, ils restent donc les mêmes toute la journée. Ils ne prédisent aucun gain.';

  @override
  String get whyThis => 'D’où cela vient';

  @override
  String whySign(
    String sign,
    String dates,
    String element,
    String chinese,
    String chineseText,
  ) {
    return 'Votre signe : $sign ($dates), élément : $element. Signe chinois : $chinese. $chineseText';
  }

  @override
  String whyMoon(String sign, String element, String relation) {
    String _temp0 = intl.Intl.selectLogic(relation, {
      'same': 'le même élément',
      'supportive': 'favorable',
      'tense': 'tendue',
      'other': 'neutre',
    });
    return 'Aujourd’hui à midi, la Lune est en $sign (élément : $element). Relation avec votre élément : $_temp0.';
  }

  @override
  String get whyMethod =>
      'La position de la Lune est calculée hors ligne à l’aide de formules astronomiques (précision d’environ 0,5°). Le texte « Aujourd’hui » dépend de la relation entre les éléments, « Les astres disent » de la phase de la Lune et « Attention à » de votre nombre du jour.';

  @override
  String get horoscopeNeedsBirth =>
      'Saisissez votre date de naissance pour voir tout de suite votre signe, l’horoscope du jour, votre nombre du jour et vos nombres porte-bonheur.';

  @override
  String get moonToday => 'La Lune aujourd’hui';

  @override
  String moonState(String phase, int percent, String sign) {
    return '$phase · éclairée à $percent % · en $sign';
  }

  @override
  String get moonCalendar => 'Calendrier lunaire';

  @override
  String get moonCalendarIntro =>
      'Les prochaines phases principales de la Lune, en heure locale (précision d’environ 1 heure).';

  @override
  String get compatibility => 'Compatibilité de deux personnes';

  @override
  String get compatIntro =>
      'Saisissez deux dates de naissance. Nous comparons les signes du zodiaque, les éléments, les signes chinois et les chemins de vie. C’est un jeu et un point de départ pour discuter, pas un verdict sur une relation.';

  @override
  String personDate(int n) {
    return 'Date de naissance : personne $n';
  }

  @override
  String get check => 'Comparer';

  @override
  String get compatElements => 'Éléments';

  @override
  String personLine(
    int n,
    String sign,
    String element,
    String chinese,
    int lifePath,
  ) {
    return 'Personne $n : $sign ($element) · signe chinois : $chinese · chemin de vie $lifePath';
  }

  @override
  String get birthCardTitle => 'Carte de naissance';

  @override
  String get birthCardNote =>
      'Méthode : jour + mois + année de naissance, puis on additionne les chiffres jusqu’à obtenir un résultat inférieur ou égal à 22 (22 = Le Mat). Un résultat à deux chiffres donne aussi une carte compagne.';

  @override
  String get birthCardSecond => 'Carte compagne';

  @override
  String yesNoAnswer(String a) {
    String _temp0 = intl.Intl.selectLogic(a, {
      'yes': 'La réponse des cartes : OUI',
      'no': 'La réponse des cartes : NON',
      'other': 'La réponse des cartes : INCERTAIN. Rien n’est encore joué',
    });
    return '$_temp0';
  }

  @override
  String get horoscopeFor => 'Aujourd’hui pour vous';

  @override
  String get licenses => 'Licences (polices et bibliothèques)';

  @override
  String get cardAdvice => 'Le conseil de la carte';

  @override
  String get correspondences =>
      'Correspondances astrologiques (Golden Dawn, XIXe siècle)';

  @override
  String get chooseSpread => 'Choisir un tirage';

  @override
  String get tapDeck => 'Pensez à votre question et touchez le jeu';

  @override
  String spreadCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cartes',
      one: '$n carte',
    );
    return '$_temp0';
  }

  @override
  String get bigThree => 'Votre trio astral';

  @override
  String get bigThreeIntro =>
      'Le Soleil est votre signe du zodiaque. La Lune décrit vos émotions, l’ascendant la façon dont les autres vous perçoivent. La date suffit généralement pour la Lune ; l’ascendant nécessite l’heure et le lieu de naissance. Les données restent uniquement sur cet appareil.';

  @override
  String get birthTime => 'Heure de naissance';

  @override
  String get notGiven => 'non renseignée';

  @override
  String get birthPlace => 'Lieu de naissance';

  @override
  String get placesNote =>
      'Villes de Pologne et grandes villes du monde. Si la vôtre manque, choisissez la plus proche dans le même pays ou saisissez des coordonnées. Quelques dizaines de kilomètres modifient l’ascendant de moins de 1°.';

  @override
  String get sunLabel => 'Soleil';

  @override
  String get moonLabel => 'Lune';

  @override
  String get ascLabel => 'Ascendant';

  @override
  String moonTwoSigns(String a, String b) {
    return 'Ce jour-là, la Lune a changé de signe : $a ou $b, selon l’heure de naissance.';
  }

  @override
  String get ascNeeds =>
      'Saisissez l’heure et le lieu de naissance pour calculer l’ascendant.';

  @override
  String traceTime(String local, String utc, String zone) {
    return 'Heure locale $local → $utc UTC (fuseau $zone, avec l’historique de l’heure d’été).';
  }

  @override
  String traceMoon(String deg, String sign) {
    return 'Longitude écliptique de la Lune : $deg° → $sign.';
  }

  @override
  String traceAsc(
    String deg,
    String sign,
    String place,
    String lat,
    String lon,
  ) {
    return 'Ascendant : $deg° → $sign ($place, $lat° N, $lon° E).';
  }

  @override
  String get needBirthDate =>
      'Enregistrez d’abord votre date de naissance dans l’onglet Nombres (bouton « Enregistrer comme mon profil »).';

  @override
  String get clear => 'Effacer';

  @override
  String get chineseTitle => 'Horoscope chinois';

  @override
  String chineseBirthYear(int year, String element, String yy) {
    String _temp0 = intl.Intl.selectLogic(yy, {'yang': 'yang', 'other': 'yin'});
    return 'Année du calendrier chinois : $year · $element · $_temp0';
  }

  @override
  String get chineseNewYearNote =>
      'Le Nouvel An chinois tombe entre le 21 janvier et le 20 février. Si vous êtes né(e) avant, vous appartenez au signe de l’année précédente. C’est déjà pris en compte ici.';

  @override
  String chineseCurrentYear(int year, String animal, String element) {
    return 'Année $year : $animal · $element';
  }

  @override
  String chineseYearSince(String date) {
    return 'L’année chinoise en cours a commencé le $date.';
  }

  @override
  String get chineseCompatTitle => 'Compatibilité des signes chinois';

  @override
  String get chineseFriend => 'Ami secret';

  @override
  String get chineseTrine => 'Trigone des alliés';

  @override
  String get chineseClash => 'Signe opposé';

  @override
  String get chineseElement => 'Élément de l’année de naissance';

  @override
  String get mercuryRetro => 'Mercure rétrograde';

  @override
  String mercuryNow(String date) {
    return 'Mercure rétrograde jusqu’au $date';
  }

  @override
  String get mercuryNone => 'Aucune période rétrograde dans l’année à venir.';

  @override
  String get upcomingPhases => 'Prochaines phases';

  @override
  String get dayByDay => 'Jour après jour (30 jours)';

  @override
  String moonDayLine(String sign, String phase) {
    return 'Lune en $sign · $phase';
  }

  @override
  String get dreams => 'Dictionnaire des rêves';

  @override
  String dreamsCount(int n) {
    return '$n symboles de rêves : ce qu’un rêve peut vous dire sur vous-même';
  }

  @override
  String get dreamsIntro =>
      'Les rêves ne prédisent pas l’avenir. Le dictionnaire indique ce à quoi un symbole est souvent associé, et la question vous aide à voir ce qu’il signifie pour vous. Le plus important, c’est ce que vous avez ressenti dans le rêve.';

  @override
  String get dreamsSearch => 'Chercher un symbole, p. ex. eau, dents, maison';

  @override
  String get dreamsEmpty =>
      'Ce symbole n’existe pas. Essayez un mot proche ou notez le rêve dans votre journal.';

  @override
  String chineseSignButton(String animal) {
    return 'Signe chinois : $animal';
  }

  @override
  String get otherPlace => 'Autre lieu : saisir des coordonnées';

  @override
  String otherPlaceSet(String place, String zone) {
    return 'Autre lieu : $place ($zone)';
  }

  @override
  String get otherPlaceHelp =>
      'Vous trouverez les coordonnées dans une application de cartes (par exemple en touchant un lieu dans Google Maps). Saisissez le sud et l’ouest avec un signe moins. Le fuseau horaire est une région, p. ex. Europe/Paris, America/Montreal.';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get timeZone => 'Fuseau horaire';

  @override
  String get otherPlaceMissing =>
      'Saisissez la latitude, la longitude et le fuseau horaire.';

  @override
  String get otherPlaceRange =>
      'La latitude doit être comprise entre -66° et 66° (au-delà des cercles polaires, l’ascendant peut être indéterminé), la longitude entre -180° et 180°.';

  @override
  String get numbersStartTitle => 'Commencez par votre date de naissance';

  @override
  String get numbersEditTitle =>
      'Modifier les données ou calculer pour quelqu’un d’autre';

  @override
  String get calculateOnce => 'Calculer seulement (sans enregistrer)';

  @override
  String get compatibilityHint => 'Comparer deux dates de naissance';

  @override
  String get yourNumbers => 'Vos nombres';

  @override
  String get editOrOther =>
      'Modifier les données ou calculer pour quelqu’un d’autre';

  @override
  String get showMyHoroscope => 'Voir mon horoscope';

  @override
  String get privacyShort =>
      'La date reste uniquement sur ce téléphone. Vous pouvez la modifier dans l’onglet Nombres.';

  @override
  String get explore => 'Explorer';

  @override
  String get exploreBigThree => 'Soleil, Lune et ascendant';

  @override
  String get exploreChinese => 'Signe, élément et votre année';

  @override
  String get exploreTarot => 'Interroger les cartes';

  @override
  String get exploreTarotSub => 'Tirages et questions oui ou non';

  @override
  String get exploreNumbersSub => 'Chemin de vie et carte de naissance';

  @override
  String get exploreMoon => 'Phases, jardinage, Mercure rétrograde';

  @override
  String get exploreDreams => 'Ce que dit votre rêve';

  @override
  String get exploreLibrary =>
      '78 cartes, articles, glossaire : dans la bibliothèque';

  @override
  String get exploreLibraryTitle => 'Cartes et articles';

  @override
  String get squareTitle => 'Carré de Pythagore';

  @override
  String get squareIntro =>
      'Une grille des chiffres de votre date de naissance (méthode d’Alexandrov) : plus un chiffre revient souvent, plus le trait est marqué. Touchez une case pour lire sa description.';

  @override
  String get squareEmpty => 'aucun';

  @override
  String get cyclesTitle => 'Cycles de vie : réalisations et défis';

  @override
  String get cyclesIntro =>
      'La numérologie divise la vie en quatre étapes. Chacune a sa « réalisation », un thème de croissance, et son « défi », une leçon à travailler. La durée de la première étape dépend de votre chemin de vie.';

  @override
  String ageRange(int from, int to) {
    return 'de $from à $to ans';
  }

  @override
  String ageFrom(int from) {
    return 'à partir de $from ans';
  }

  @override
  String get cyclesNow => 'EN COURS';

  @override
  String get ichingTitle => 'Oracle du Yi King';

  @override
  String get ichingIntro =>
      'Le Livre des mutations est un oracle chinois classique. Pensez à votre question, puis lancez trois pièces six fois ; l’hexagramme se construit de bas en haut. Les traits marqués d’un point sont « mutants » et montrent ce que devient la situation.';

  @override
  String ichingToss(int n) {
    return 'Lancer les pièces ($n/6)';
  }

  @override
  String ichingLastToss(String sum) {
    String _temp0 = intl.Intl.selectLogic(sum, {
      '6': 'pile, pile, pile = 6 (vieux yin, mutant)',
      '7': 'deux piles et une face = 7 (yang)',
      '8': 'deux faces et un pile = 8 (yin)',
      'other': 'face, face, face = 9 (vieux yang, mutant)',
    });
    return 'Dernier lancer : $_temp0';
  }

  @override
  String get ichingMeaning => 'Signification';

  @override
  String get ichingChange => 'Sens de la mutation';

  @override
  String ichingChangingLines(String lines) {
    return 'Traits mutants : $lines. La situation évolue vers :';
  }

  @override
  String get ichingAgain => 'Nouvelle question';

  @override
  String get ichingNote =>
      'Les descriptions des hexagrammes et des traits sont de courtes interprétations propres à cette application, inspirées des images du texte chinois ancien. Voyez-les comme une invitation à la réflexion.';

  @override
  String get exploreIching => 'Une question et six lancers de pièces';

  @override
  String get ritualsTitle => 'Rituels lunaires';

  @override
  String get exploreRituals => 'Intentions de nouvelle et de pleine lune';

  @override
  String get ritualsIntro =>
      'La nouvelle et la pleine lune rythment le mois. Notez une intention à la nouvelle lune, puis, à la pleine lune, regardez ce qui s’est passé. Vos notes vont dans votre journal.';

  @override
  String get moonRemindersToggle => 'Me rappeler la nouvelle et la pleine lune';

  @override
  String get moonRemindersNote =>
      'Une notification à 9 h le jour de la nouvelle et de la pleine lune. Fonctionne hors ligne.';

  @override
  String get moonReminderNewTitle =>
      'Nouvelle lune : le moment d’une intention';

  @override
  String get moonReminderNewBody =>
      'Notez ce que vous voulez commencer dans ce cycle.';

  @override
  String get moonReminderFullTitle =>
      'Pleine lune : le moment de faire le point';

  @override
  String get moonReminderFullBody =>
      'Qu’est-ce qui s’est bien passé depuis la nouvelle lune ? Qu’est-ce qui vous inspire de la gratitude ?';

  @override
  String get forYouToday => 'Rien que pour vous';

  @override
  String get advice => 'Conseil';

  @override
  String get karmicTitle => 'Le karma en chiffres';

  @override
  String get karmicIntro =>
      'Les dettes karmiques sont les nombres 13, 14, 16 et 19 qui apparaissent dans le calcul de vos nombres. Les leçons karmiques sont les chiffres absents de votre nom complet. Dans la tradition, ce sont des thèmes à travailler, pas des verdicts.';

  @override
  String get karmicNone => 'Aucune dette karmique dans vos nombres.';

  @override
  String get karmicLessonsTitle =>
      'Leçons karmiques (chiffres absents de votre nom)';

  @override
  String get houseTitle => 'Numérologie de la maison et du téléphone';

  @override
  String get houseHint =>
      'Numéro de maison, d’appartement ou de téléphone, p. ex. 12A';

  @override
  String luckyMeaning(int n, int reduced, String keywords) {
    return '$n → $reduced : $keywords';
  }

  @override
  String dayColor(String color) {
    return 'Couleur du jour : $color';
  }

  @override
  String signExtras(String color, String stone, String day, String planet) {
    return 'Couleur : $color · pierre : $stone · jour : $day · planète : $planet';
  }

  @override
  String get periodTitle => 'Horoscope de la semaine et du mois';

  @override
  String get explorePeriod => 'Jours clés et votre mois personnel';

  @override
  String get periodIntro =>
      'Calculé d’après le ciel réel : phases de la Lune, éclipses, Mercure rétrograde, entrée du Soleil dans le signe suivant et jours où la Lune est dans votre signe, ainsi que vos nombres personnels.';

  @override
  String get tabWeek => 'Semaine';

  @override
  String get tabMonth => 'Mois';

  @override
  String get weekGeneral => 'En général';

  @override
  String get keyDays => 'Jours clés';

  @override
  String get noKeyDays =>
      'Aucun événement particulier dans le ciel sur cette période. Un bon moment pour un travail calme et régulier.';

  @override
  String evPhase(String phase) {
    return '$phase';
  }

  @override
  String evMoonInSign(String sign) {
    return 'Lune dans votre signe ($sign)';
  }

  @override
  String evSunIngress(String sign) {
    return 'Le Soleil entre en $sign';
  }

  @override
  String get evMercuryStart => 'Mercure devient rétrograde';

  @override
  String get evMercuryEnd => 'Mercure redevient direct';

  @override
  String evEclipse(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'solar': 'Éclipse solaire',
      'partial': 'Éclipse lunaire (partielle ou totale)',
      'other': 'Éclipse lunaire par la pénombre (discrète)',
    });
    return '$_temp0';
  }

  @override
  String dayNumberLine(int n, String title) {
    return 'Nombre du jour $n : $title';
  }

  @override
  String get eclipsesTitle => 'Éclipses de l’année à venir';

  @override
  String get eclipseVisibility =>
      'La visibilité dépend de l’endroit où vous êtes sur Terre : toutes les éclipses ne sont pas visibles depuis chez vous.';

  @override
  String eclipseSoon(String when) {
    return 'Une éclipse approche : $when';
  }

  @override
  String get loveLabel => 'Amour';

  @override
  String get workLabel => 'Travail';

  @override
  String get wellbeingLabel => 'Bien-être';

  @override
  String ichingImage(String upper, String lower) {
    return 'Image : en haut $upper, en bas $lower';
  }

  @override
  String get ichingLinesTitle => 'Traits mutants';

  @override
  String ichingLine(int n, String text) {
    return 'Trait $n : $text';
  }

  @override
  String get revealCard => 'Révéler la carte';

  @override
  String get revealCardHint =>
      'Touchez la carte pour découvrir ce que la journée vous réserve.';

  @override
  String get cardOfDayMore => 'En savoir plus sur la carte';

  @override
  String get moodQuestion => 'Comment vous sentez-vous aujourd’hui ?';

  @override
  String moodName(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      '1': 'Difficile',
      '2': 'Bof',
      '3': 'Moyen',
      '4': 'Bien',
      'other': 'Super',
    });
    return '$_temp0';
  }

  @override
  String get moodSaved => 'Enregistré uniquement sur cet appareil.';

  @override
  String countdown(String what, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'dans $days jours',
      one: 'demain',
      zero: 'aujourd’hui',
    );
    return '$what $_temp0';
  }

  @override
  String get yourBirthday => 'Votre anniversaire';

  @override
  String notifMoon(String sign) {
    return 'Lune en $sign';
  }

  @override
  String notifDayNumber(int n) {
    return 'nombre du jour $n';
  }

  @override
  String get notifCard => 'votre carte du jour vous attend';

  @override
  String get tabStars => 'Astres';

  @override
  String get starsMore => 'Plus d’astres';

  @override
  String get deckTitle => 'Le jeu';

  @override
  String get fullHoroscope => 'Horoscope complet';

  @override
  String get upcoming => 'À venir';

  @override
  String get suggested => 'Suggestions du jour';

  @override
  String get suggestBigThree =>
      'Ajoutez l’heure et le lieu de naissance pour découvrir votre Lune et votre ascendant';

  @override
  String get dayNumberShort => 'nombre du jour';

  @override
  String get dayColorShort => 'couleur du jour';

  @override
  String get fullNumerology => 'Numérologie complète et portrait';

  @override
  String get firstEntry => 'Noter une première pensée';

  @override
  String get greetDay => 'Bonjour';

  @override
  String get greetEvening => 'Bonsoir';

  @override
  String get dayHoroscope => 'Horoscope';

  @override
  String get dayNumbers => 'Mes nombres';

  @override
  String get dayCard => 'Carte';

  @override
  String get dayDone => 'Tout est fait pour aujourd’hui.';

  @override
  String tomorrowIs(String what) {
    return 'Demain : $what.';
  }

  @override
  String tomorrowMoon(String sign) {
    return 'Demain : Lune en $sign.';
  }

  @override
  String tomorrowNumber(int n) {
    return 'Demain : une nouvelle carte et le nombre du jour $n.';
  }

  @override
  String get tomorrowCard => 'Demain : une nouvelle carte du jour.';

  @override
  String get tabDreams => 'Rêves';

  @override
  String get dreamAsk => 'De quoi avez-vous rêvé cette nuit ?';

  @override
  String get dreamAskHint =>
      'Notez le rêve avant qu’il ne s’efface, ou cherchez un symbole ci-dessous.';

  @override
  String get dreamSave => 'Noter le rêve';

  @override
  String get dreamEntry => 'Rêve';

  @override
  String get dreamOfDay => 'Symbole du jour';

  @override
  String get dreamsAll => 'Tous les symboles';

  @override
  String get widgetCardWaiting => 'En attente d’être révélée';

  @override
  String get widgetStale => 'Touchez pour voir votre journée';

  @override
  String widgetCardSays(String advice) {
    return 'La carte dit : $advice';
  }

  @override
  String get widgetNeedBirth =>
      'Saisissez votre date de naissance pour voir votre journée.';

  @override
  String get language => 'Langue';

  @override
  String get dateHint => 'JJ.MM.AAAA';

  @override
  String get layTarot => 'Faire un tirage';

  @override
  String get tarotWelcomeTitle => 'Que suggèrent les cartes aujourd’hui ?';

  @override
  String get tarotWelcomeBody =>
      'Pensez à ce qui vous occupe, choisissez un tirage et retournez les cartes. Chaque tirage est un regard neuf. Revenez dès qu’une nouvelle question se présente.';

  @override
  String get seeDeck => 'Voir le jeu';

  @override
  String get tarotWelcomeSetting => 'Introduction de l’onglet Tarot';

  @override
  String get hide => 'Masquer';

  @override
  String get tapHint => 'toucher';

  @override
  String get dailyMood => 'Comment vous pourriez vous sentir aujourd’hui';

  @override
  String get dailyEvents => 'Ce que la journée peut vous réserver';

  @override
  String get dailyAdvice => 'Conseil du jour';

  @override
  String get energyLabel => 'Énergie';

  @override
  String meterValue(String label, int n) {
    return '$label : $n sur 5';
  }

  @override
  String get cheerAll => 'Une belle journée — les étoiles sont avec vous';

  @override
  String get cheerLove => 'Une bonne journée pour le cœur';

  @override
  String get cheerWork => 'Une bonne journée pour agir';

  @override
  String get cheerEnergy => 'Une journée pleine d’énergie';

  @override
  String get cheerUpLove => 'En amour, mieux qu’hier';

  @override
  String get cheerUpWork => 'Au travail, mieux qu’hier';

  @override
  String get cheerUpEnergy => 'Plus d’énergie qu’hier';

  @override
  String get cheerNewMoon =>
      'Nouvelle Lune — le bon moment pour une nouvelle intention';

  @override
  String get cheerWaxing => 'La Lune croît, et vos projets avec elle';

  @override
  String get cheerFullMoon =>
      'Pleine Lune — le moment d’apprécier ce que vous avez déjà';

  @override
  String get cheerWaning =>
      'La Lune décroît — plus facile de lâcher ce qui pèse';

  @override
  String get cheerNewMoon2 =>
      'Nouvelle Lune — une page blanche. Écrivez-y quelque chose de bon';

  @override
  String get cheerNewMoon3 =>
      'Nouvelle Lune — les meilleures idées naissent dans le calme';

  @override
  String get cheerWaxing2 =>
      'La Lune croît — le bon moment pour ajouter de petits pas';

  @override
  String get cheerWaxing3 =>
      'La Lune croissante favorise ce que vous commencez';

  @override
  String get cheerFullMoon2 =>
      'Pleine Lune — on y voit plus clair. Y compris ce qui a réussi';

  @override
  String get cheerFullMoon3 =>
      'Pleine Lune — une belle soirée pour fêter les petites choses';

  @override
  String get cheerWaning2 =>
      'La Lune décroît — le bon moment pour ranger et respirer';

  @override
  String get cheerWaning3 =>
      'La Lune décroissante favorise le repos et les fins sereines';

  @override
  String get threeGood => 'Noter trois bonnes choses';

  @override
  String get threeGoodPrompt =>
      'Trois bonnes choses de cette semaine — et ce qui les a rendues possibles :';

  @override
  String moodReply(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      '1': 'Les jours difficiles arrivent. Vous n\'avez rien à rattraper aujourd\'hui.',
      '2': 'Un jour plus faible, c\'est correct aussi. Un petit pas suffit.',
      '3': 'Un jour ordinaire compte aussi.',
      '4': 'Cela fait plaisir.',
      'other': 'Magnifique. Retenez ce qui y a contribué.',
    });
    return '$_temp0';
  }

  @override
  String get reminderAsk =>
      'Souhaitez-vous que la carte du jour vous attende chaque matin ?';

  @override
  String get reminderAskSub =>
      'Une notification par jour à 8 h, avec le contenu du jour. Vous pouvez changer l\'heure ou la désactiver dans les Réglages.';

  @override
  String get reminderYes => 'Oui, rappelez-le-moi';

  @override
  String get reminderNo => 'Non, merci';

  @override
  String get onboardBirthHint =>
      'Facultatif. Avec la date, vous verrez tout de suite votre signe, votre horoscope et vos nombres.';

  @override
  String get lookBack => 'Vos jours';

  @override
  String get lookBackHint =>
      'Cartes du jour et humeur, jour après jour. Enregistré uniquement sur cet appareil.';
}
