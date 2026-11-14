// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Digi Witch';

  @override
  String get tabToday => 'Today';

  @override
  String get tabNumerology => 'Numbers';

  @override
  String get tabTarot => 'Tarot';

  @override
  String get tabLibrary => 'Library';

  @override
  String get tabJournal => 'Journal';

  @override
  String get settings => 'Settings';

  @override
  String get start => 'Let\'s begin';

  @override
  String get onboardWhat =>
      'Your daily guide to symbols: today\'s horoscope, the Moon, tarot, numerology, your Chinese sign and a dream dictionary. Every calculation is shown step by step, and every card is explained in the library.';

  @override
  String get onboardNot =>
      'This is a tool for entertainment, learning about symbolism and self-reflection. It does not predict the future, measure personality in any scientific sense or replace professional advice.';

  @override
  String get onboardPrivacy =>
      'You don\'t need an account. Dates, names and your journal stay on this device.';

  @override
  String get onboardAdults => 'This app is intended for adults.';

  @override
  String get reversed => 'reversed';

  @override
  String get writeReflection => 'Write a reflection in your journal';

  @override
  String get exportJournal => 'Export journal';

  @override
  String get newEntry => 'New entry';

  @override
  String get editEntry => 'Entry';

  @override
  String get journalEmpty =>
      'Your journal is empty. Write down a first thought. You could start with the question of the day or a card you have drawn.';

  @override
  String get journalPrivacy => 'Entries are stored only on this device.';

  @override
  String get deleteEntryConfirm => 'Delete this entry? This cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get linkedResult => 'Linked result';

  @override
  String get promptsTitle => 'A question to start with (optional)';

  @override
  String promptCategory(String c) {
    String _temp0 = intl.Intl.selectLogic(c, {
      'ogolne': 'General',
      'rodzina': 'Family',
      'tarot': 'Tarot',
      'liczby': 'Numbers',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String get randomPrompt => 'Pick a random question';

  @override
  String get familyNote =>
      'Write only about what you are comfortable sharing. You can use nicknames instead of your loved ones\' names.';

  @override
  String get entryHint => 'Your thoughts…';

  @override
  String get tarotIntro =>
      'We treat the cards as a prompt for reflection, not as a prediction. The positions in a spread are questions worth asking yourself.';

  @override
  String get drawCards => 'Draw cards';

  @override
  String get drawAgain => 'Draw again';

  @override
  String get reversedOn =>
      'Reversed cards: on (each card independently, with a 1 in 2 chance).';

  @override
  String get reversedOff =>
      'Reversed cards: off. You can turn them on in Settings.';

  @override
  String get spreadReflectionPrompt =>
      'What moved me most in this spread, and why?';

  @override
  String get questionLabel => 'Your question (optional)';

  @override
  String get questionHint =>
      'e.g. What should I keep in mind when changing jobs?';

  @override
  String get readingTitle => 'What the cards say about your question';

  @override
  String get readingTitleNoQuestion => 'Spread summary';

  @override
  String get summaryMajors =>
      'Major Arcana dominate: this touches something important, bigger than everyday decisions.';

  @override
  String summarySuit(String suit) {
    String _temp0 = intl.Intl.selectLogic(suit, {
      'wands':
          'Mostly Wands: energy, action and initiative are in the background.',
      'cups': 'Mostly Cups: emotions, feelings and relationships are in the background.',
      'swords': 'Mostly Swords: thoughts, decisions and difficult conversations are in the background.',
      'pentacles': 'Mostly Pentacles: work, money and practical matters are in the background.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get summaryReversed =>
      'Most of the cards are reversed: something may be blocked, delayed or lived more on the inside than on the outside.';

  @override
  String get summaryBalanced =>
      'The cards are evenly spread: no single area clearly dominates.';

  @override
  String summaryAnswer(String position, String card, String advice) {
    return 'The cards\' answer: $card in the position “$position”: $advice';
  }

  @override
  String get addBookmark => 'Add bookmark';

  @override
  String get removeBookmark => 'Remove bookmark';

  @override
  String get group => 'Group';

  @override
  String get keywords => 'Keywords';

  @override
  String get symbolism => 'Symbolism';

  @override
  String get upright => 'Upright meaning';

  @override
  String get reversedMeaning => 'Reversed meaning';

  @override
  String get reflectionQuestions => 'Questions for reflection';

  @override
  String get reflectionQuestion => 'Question for reflection';

  @override
  String get sourcesAndRights => 'Sources and rights';

  @override
  String get cardSourceNote =>
      'The card descriptions are original texts written for this app. Illustration: Pamela Colman Smith (1878–1951), deck published in 1909, in the public domain; scan of a “Roses & Lilies” copy (Saskia Jansen), shared on Wikimedia Commons. The image has only been resized.';

  @override
  String get numerologyIntro =>
      'Enter your date of birth and, if you like, your full name. Saved as your profile, they unlock today\'s horoscope, your day number, your big three and your Chinese sign. The data stays on this phone only.';

  @override
  String get birthDate => 'Date of birth';

  @override
  String get birthDateHelp => 'Digits only: day, month, year, e.g. 15071990';

  @override
  String get fullNameOptional => 'Full name (optional)';

  @override
  String get fullNameHelp =>
      'Only needed for the numbers based on letters. Polish, German, French and Spanish letters are supported; spaces, hyphens and apostrophes are skipped.';

  @override
  String get personalYearFor => 'Personal year for:';

  @override
  String get previousYear => 'Previous year';

  @override
  String get nextYear => 'Next year';

  @override
  String get calculate => 'Calculate';

  @override
  String get saveAsProfile => 'Save as my profile';

  @override
  String get profileSaved => 'Saved on this device.';

  @override
  String get portrait => 'Numerology portrait';

  @override
  String get portraitNote =>
      'Expand a number to see the calculation and its symbolic interpretation. Results follow the convention described in the Library (“How we calculate”).';

  @override
  String indicatorName(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'lifePath': 'Life path',
      'birthDay': 'Birthday number',
      'expression': 'Expression number',
      'soulUrge': 'Soul urge number',
      'personality': 'Personality number',
      'personalYear': 'Personal year',
      'personalDay': 'Day number',
      'relation': 'Relationship number',
      'personalMonth': 'Personal month',
      'maturity': 'Maturity number',
      'house': 'House number',
      'other': 'Number',
    });
    return '$_temp0';
  }

  @override
  String get noBasis => 'Nothing to calculate';

  @override
  String get calculation => 'Calculation';

  @override
  String get symbolicInterpretation => 'Symbolic interpretation';

  @override
  String get enterDateOrName => 'Enter a date of birth or a full name.';

  @override
  String get dateInvalid =>
      'That date does not exist. Check the day and month.';

  @override
  String get dateFuture => 'The date cannot be in the future.';

  @override
  String get nameNoLetters => 'Enter at least one letter.';

  @override
  String nameUnsupported(String chars) {
    return 'Unsupported characters: $chars. Enter the spelling in the Latin alphabet (a transliteration) that you want to use for the calculation.';
  }

  @override
  String get cardOfDay => 'Card of the day';

  @override
  String get cardOfDayNote =>
      'The card of the day stays the same until the end of the day by this device\'s clock.';

  @override
  String get promptOfDay => 'Question of the day';

  @override
  String yourPersonalYear(int year) {
    final intl.NumberFormat yearNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String yearString = yearNumberFormat.format(year);

    return 'Your personal year $yearString';
  }

  @override
  String get search => 'Search cards, terms, articles';

  @override
  String get bookmarks => 'Bookmarks';

  @override
  String get articles => 'Articles';

  @override
  String cardsCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Cards ($n)',
      one: 'Card (1)',
    );
    return '$_temp0';
  }

  @override
  String get archetypes => 'Archetypes';

  @override
  String get archetypesNote =>
      'The 12 archetypes are this app\'s own editorial model: one of many possible ways to divide things up, not a canon or a psychological test.';

  @override
  String get aboutModel => 'About the model';

  @override
  String get archetypeGifts => 'Gifts';

  @override
  String get archetypeShadow => 'Shadow';

  @override
  String get glossary => 'Glossary';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get allowReversed => 'Reversed cards';

  @override
  String get allowReversedRule =>
      'When on, each drawn card is independently reversed with a 1 in 2 chance.';

  @override
  String get profile => 'My profile';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyBody =>
      'We do not create accounts or send your dates, names or entries to a server. Your data is on this device only, unless you export it yourself.';

  @override
  String get deleteAllTitle => 'Delete all data';

  @override
  String get deleteAllBody =>
      'We will remove your journal, profile, bookmarks, card of the day and settings from this device. This cannot be undone.';

  @override
  String get sourcesBody =>
      'The interpretations, questions, archetypes and articles are original texts. Card illustrations: Pamela Colman Smith, 1909 deck (public domain), scans from Wikimedia Commons; details are given with each card. Historical sources are listed at the end of the articles.';

  @override
  String get purchases => 'Digi Witch Pro';

  @override
  String get help => 'Help';

  @override
  String get helpBody =>
      'If you are in crisis, contact a mental health professional or a local crisis line. In an emergency, call your local emergency number (112 in the EU, 999 in the UK, 911 in the US).';

  @override
  String get versions => 'Versions';

  @override
  String get algorithm => 'algorithm';

  @override
  String get contentVer => 'content';

  @override
  String get disclaimer =>
      'This content is for entertainment, education and self-reflection. It is not medical, psychological, legal or financial advice.';

  @override
  String get proShort => 'One-time purchase: no ads, extra spreads.';

  @override
  String get proTitle => 'Digi Witch Pro';

  @override
  String get proBenefits =>
      '• No ads anywhere in the app\n• Extra spreads: “Relationship” (6 cards) and “Reflection cross” (10 cards)\n• One-time payment, no subscription';

  @override
  String get proFreeStays =>
      'Numerology, the card of the day, the 1, 3 and 5 card spreads, the library and the journal stay free. Buying Pro does not affect which cards are drawn or how results are calculated.';

  @override
  String get proActive => 'You have Pro. Thank you!';

  @override
  String get proUnavailable =>
      'Purchasing is unavailable right now. Check your internet connection and try again later.';

  @override
  String proBuy(String price) {
    return 'Buy Pro for $price';
  }

  @override
  String get purchaseError =>
      'The purchase was not completed. You have not been charged unless the store confirmed the transaction.';

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get proOnly => 'Available in Pro';

  @override
  String get adPrivacyOptions => 'Ad privacy settings';

  @override
  String get reminder => 'Daily reminder';

  @override
  String get reminderOff => 'Off';

  @override
  String reminderAt(String time) {
    return 'Every day at $time';
  }

  @override
  String get reminderTitle => 'Digi Witch';

  @override
  String get reminderBody => 'A moment to reflect, if you feel like it.';

  @override
  String get reminderDenied =>
      'Notifications are not allowed. You can allow them in system settings.';

  @override
  String get proStoreNote =>
      'Payment and any refunds are handled by the App Store or Google Play under their own rules. The purchase works whether or not you consent to ads.';

  @override
  String get horoscopeToday => 'Today';

  @override
  String get horoscopeStars => 'The stars say';

  @override
  String get horoscopeCaution => 'Watch out';

  @override
  String moonIn(String sign, String phase) {
    return 'Moon in $sign, $phase.';
  }

  @override
  String get luckyNumbers => 'Lucky numbers of the day';

  @override
  String get luckyNote =>
      'For fun: the numbers come from your date of birth and today\'s date, so they stay the same all day. They do not predict winnings.';

  @override
  String get whyThis => 'Where this comes from';

  @override
  String whySign(
    String sign,
    String dates,
    String element,
    String chinese,
    String chineseText,
  ) {
    return 'Your sign: $sign ($dates), element: $element. Chinese sign: $chinese. $chineseText';
  }

  @override
  String whyMoon(String sign, String element, String relation) {
    String _temp0 = intl.Intl.selectLogic(relation, {
      'same': 'the same element',
      'supportive': 'supportive',
      'tense': 'tense',
      'other': 'neutral',
    });
    return 'At noon today the Moon is in $sign (element: $element). Relation to your element: $_temp0.';
  }

  @override
  String get whyMethod =>
      'The Moon\'s position is calculated with astronomical formulas, offline (accurate to about 0.5°). The “Today” text depends on the relation between the elements, “The stars say” on the Moon\'s phase, and “Watch out” on your day number.';

  @override
  String get horoscopeNeedsBirth =>
      'Enter your date of birth and you will see your sign, today\'s horoscope, your day number and your lucky numbers straight away.';

  @override
  String get moonToday => 'The Moon today';

  @override
  String moonState(String phase, int percent, String sign) {
    return '$phase · $percent% illuminated · in $sign';
  }

  @override
  String get moonCalendar => 'Moon calendar';

  @override
  String get moonCalendarIntro =>
      'The next main phases of the Moon, in local time (accurate to about 1 hour).';

  @override
  String get compatibility => 'Compatibility of two people';

  @override
  String get compatIntro =>
      'Enter two dates of birth. We will compare zodiac signs, elements, Chinese signs and life path numbers. It is a bit of fun and a conversation starter, not a verdict on a relationship.';

  @override
  String personDate(int n) {
    return 'Date of birth: person $n';
  }

  @override
  String get check => 'Compare';

  @override
  String get compatElements => 'Elements';

  @override
  String personLine(
    int n,
    String sign,
    String element,
    String chinese,
    int lifePath,
  ) {
    return 'Person $n: $sign ($element) · Chinese sign: $chinese · life path $lifePath';
  }

  @override
  String get birthCardTitle => 'Birth card';

  @override
  String get birthCardNote =>
      'Method: day + month + year of birth, then the digits are added until the result is no greater than 22 (22 = The Fool). A two-digit result also gives a companion card.';

  @override
  String get birthCardSecond => 'Companion card';

  @override
  String yesNoAnswer(String a) {
    String _temp0 = intl.Intl.selectLogic(a, {
      'yes': 'The cards\' answer: YES',
      'no': 'The cards\' answer: NO',
      'other':
          'The cards\' answer: UNCLEAR. The matter is still in the balance',
    });
    return '$_temp0';
  }

  @override
  String get horoscopeFor => 'Today for you';

  @override
  String get licenses => 'Licences (fonts and libraries)';

  @override
  String get cardAdvice => 'The card\'s advice';

  @override
  String get correspondences =>
      'Astrological correspondences (Golden Dawn, 19th century)';

  @override
  String get chooseSpread => 'Choose a spread';

  @override
  String get tapDeck => 'Hold your question in mind and tap the deck';

  @override
  String spreadCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cards',
      one: '1 card',
    );
    return '$_temp0';
  }

  @override
  String get bigThree => 'Your big three';

  @override
  String get bigThreeIntro =>
      'The Sun is your zodiac sign. The Moon describes your emotions, and the ascendant describes how others see you. The date is usually enough for the Moon; the ascendant needs your time and place of birth. The data stays on this device only.';

  @override
  String get birthTime => 'Time of birth';

  @override
  String get notGiven => 'not given';

  @override
  String get birthPlace => 'Place of birth';

  @override
  String get placesNote =>
      'Cities in Poland and major cities abroad. If yours is missing, choose the nearest one in the same country or enter coordinates. A few dozen kilometres change the ascendant by less than 1°.';

  @override
  String get sunLabel => 'Sun';

  @override
  String get moonLabel => 'Moon';

  @override
  String get ascLabel => 'Ascendant';

  @override
  String moonTwoSigns(String a, String b) {
    return 'The Moon changed sign that day: $a or $b, depending on your time of birth.';
  }

  @override
  String get ascNeeds =>
      'Enter your time and place of birth to calculate the ascendant.';

  @override
  String traceTime(String local, String utc, String zone) {
    return 'Local time $local → $utc UTC (zone $zone, with daylight saving history).';
  }

  @override
  String traceMoon(String deg, String sign) {
    return 'Moon\'s ecliptic longitude: $deg° → $sign.';
  }

  @override
  String traceAsc(
    String deg,
    String sign,
    String place,
    String lat,
    String lon,
  ) {
    return 'Ascendant: $deg° → $sign ($place, $lat° N, $lon° E).';
  }

  @override
  String get needBirthDate =>
      'First save your date of birth in the Numbers tab (the “Save as my profile” button).';

  @override
  String get clear => 'Clear';

  @override
  String get chineseTitle => 'Chinese horoscope';

  @override
  String chineseBirthYear(int year, String element, String yy) {
    String _temp0 = intl.Intl.selectLogic(yy, {'yang': 'yang', 'other': 'yin'});
    return 'Year in the Chinese calendar: $year · $element · $_temp0';
  }

  @override
  String get chineseNewYearNote =>
      'Chinese New Year falls between 21 January and 20 February. If you were born before it, you belong to the previous year\'s sign. This is already taken into account here.';

  @override
  String chineseCurrentYear(int year, String animal, String element) {
    return 'Year $year: $animal · $element';
  }

  @override
  String chineseYearSince(String date) {
    return 'The current Chinese year began on $date.';
  }

  @override
  String get chineseCompatTitle => 'Chinese sign compatibility';

  @override
  String get chineseFriend => 'Secret friend';

  @override
  String get chineseTrine => 'Trine of allies';

  @override
  String get chineseClash => 'Opposite sign';

  @override
  String get chineseElement => 'Element of the birth year';

  @override
  String get mercuryRetro => 'Mercury retrograde';

  @override
  String mercuryNow(String date) {
    return 'Mercury retrograde until $date';
  }

  @override
  String get mercuryNone => 'No retrograde periods in the coming year.';

  @override
  String get upcomingPhases => 'Upcoming phases';

  @override
  String get dayByDay => 'Day by day (30 days)';

  @override
  String moonDayLine(String sign, String phase) {
    return 'Moon in $sign · $phase';
  }

  @override
  String get dreams => 'Dream dictionary';

  @override
  String dreamsCount(int n) {
    return '$n dream symbols: what a dream may be telling you about yourself';
  }

  @override
  String get dreamsIntro =>
      'Dreams do not predict the future. The dictionary suggests what a symbol is often associated with, and the question helps you check what it means for you. What matters most is how you felt in the dream.';

  @override
  String get dreamsSearch => 'Search for a symbol, e.g. water, teeth, house';

  @override
  String get dreamsEmpty =>
      'No such symbol. Try a similar word, or write the dream down in your journal.';

  @override
  String chineseSignButton(String animal) {
    return 'Chinese sign: $animal';
  }

  @override
  String get otherPlace => 'Another place: enter coordinates';

  @override
  String otherPlaceSet(String place, String zone) {
    return 'Another place: $place ($zone)';
  }

  @override
  String get otherPlaceHelp =>
      'You can find coordinates in a maps app (for example, tap a place in Google Maps). Enter south and west with a minus sign. The time zone is a region, e.g. Europe/London, America/Chicago.';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get timeZone => 'Time zone';

  @override
  String get otherPlaceMissing =>
      'Enter the latitude, longitude and time zone.';

  @override
  String get otherPlaceRange =>
      'Latitude must be between -66° and 66° (beyond the polar circles the ascendant can be undefined), longitude between -180° and 180°.';

  @override
  String get numbersStartTitle => 'Start with your date of birth';

  @override
  String get numbersEditTitle => 'Change details or calculate for someone else';

  @override
  String get calculateOnce => 'Calculate only (without saving)';

  @override
  String get compatibilityHint => 'Compare two dates of birth';

  @override
  String get yourNumbers => 'Your numbers';

  @override
  String get editOrOther => 'Change details or calculate for someone else';

  @override
  String get showMyHoroscope => 'Show my horoscope';

  @override
  String get privacyShort =>
      'The date stays on this phone only. You can change it in the Numbers tab.';

  @override
  String get explore => 'Explore';

  @override
  String get exploreBigThree => 'Sun, Moon and ascendant';

  @override
  String get exploreChinese => 'Sign, element and your year';

  @override
  String get exploreTarot => 'Ask the cards';

  @override
  String get exploreTarotSub => 'Spreads and yes-or-no questions';

  @override
  String get exploreNumbersSub => 'Life path and birth card';

  @override
  String get exploreMoon => 'Phases, gardening, Mercury retrograde';

  @override
  String get exploreDreams => 'What your dream is saying';

  @override
  String get exploreLibrary => '78 cards, articles, glossary: in the Library';

  @override
  String get exploreLibraryTitle => 'Cards and articles';

  @override
  String get squareTitle => 'Pythagoras square';

  @override
  String get squareIntro =>
      'A grid of the digits from your date of birth (Aleksandrov\'s method): the more often a digit appears, the stronger the trait. Tap a cell to read its description.';

  @override
  String get squareEmpty => 'none';

  @override
  String get cyclesTitle => 'Life cycles: pinnacles and challenges';

  @override
  String get cyclesIntro =>
      'Numerology divides life into four stages. Each has its “pinnacle”, a theme for growth, and its “challenge”, a lesson to work through. The length of the first stage depends on your life path.';

  @override
  String ageRange(int from, int to) {
    return 'ages $from–$to';
  }

  @override
  String ageFrom(int from) {
    return 'from age $from';
  }

  @override
  String get cyclesNow => 'NOW';

  @override
  String get ichingTitle => 'I Ching oracle';

  @override
  String get ichingIntro =>
      'The Book of Changes is a classic Chinese oracle. Think of your question, then toss three coins six times; the hexagram is built from the bottom up. Lines marked with a dot are “changing” and show what the situation is turning into.';

  @override
  String ichingToss(int n) {
    return 'Toss the coins ($n/6)';
  }

  @override
  String ichingLastToss(String sum) {
    String _temp0 = intl.Intl.selectLogic(sum, {
      '6': 'tails, tails, tails = 6 (old yin, changing)',
      '7': 'two tails and a head = 7 (yang)',
      '8': 'two heads and a tail = 8 (yin)',
      'other': 'heads, heads, heads = 9 (old yang, changing)',
    });
    return 'Last toss: $_temp0';
  }

  @override
  String get ichingMeaning => 'Meaning';

  @override
  String get ichingChange => 'Direction of change';

  @override
  String ichingChangingLines(String lines) {
    return 'Changing lines: $lines. The situation is turning into:';
  }

  @override
  String get ichingAgain => 'New question';

  @override
  String get ichingNote =>
      'The descriptions of hexagrams and lines are this app\'s own short interpretations, inspired by the images of the ancient Chinese text. Treat them as a prompt for reflection.';

  @override
  String get exploreIching => 'A question and six coin tosses';

  @override
  String get ritualsTitle => 'Moon rituals';

  @override
  String get exploreRituals => 'Intentions for the new and full moon';

  @override
  String get ritualsIntro =>
      'The new and full moon set the rhythm of the month. Write down an intention at the new moon, and at the full moon look back at what has happened. Your entries go into your journal.';

  @override
  String get moonRemindersToggle => 'Remind me of the new and full moon';

  @override
  String get moonRemindersNote =>
      'A notification at 9:00 on the day of the new and full moon. Works offline.';

  @override
  String get moonReminderNewTitle => 'New moon: time for an intention';

  @override
  String get moonReminderNewBody =>
      'Write down what you want to begin in this cycle.';

  @override
  String get moonReminderFullTitle => 'Full moon: time to look back';

  @override
  String get moonReminderFullBody =>
      'What has gone well since the new moon? What are you grateful for?';

  @override
  String get forYouToday => 'Just for you';

  @override
  String get advice => 'Advice';

  @override
  String get karmicTitle => 'Karma in numbers';

  @override
  String get karmicIntro =>
      'Karmic debts are the numbers 13, 14, 16 and 19 that appear on the way to your numbers. Karmic lessons are the digits missing from your full name. In the tradition they describe themes to work through, not verdicts.';

  @override
  String get karmicNone => 'No karmic debts in your numbers.';

  @override
  String get karmicLessonsTitle =>
      'Karmic lessons (digits missing from your name)';

  @override
  String get houseTitle => 'House and phone numerology';

  @override
  String get houseHint => 'House, flat or phone number, e.g. 12A';

  @override
  String luckyMeaning(int n, int reduced, String keywords) {
    return '$n → $reduced: $keywords';
  }

  @override
  String dayColor(String color) {
    return 'Colour of the day: $color';
  }

  @override
  String signExtras(String color, String stone, String day, String planet) {
    return 'Colour: $color · stone: $stone · day: $day · planet: $planet';
  }

  @override
  String get periodTitle => 'Horoscope for the week and month';

  @override
  String get explorePeriod => 'Key days and your personal month';

  @override
  String get periodIntro =>
      'Calculated from the real sky: the Moon\'s phases, eclipses, Mercury retrograde, the Sun entering the next sign and the days when the Moon is in your sign, plus your personal numbers.';

  @override
  String get tabWeek => 'Week';

  @override
  String get tabMonth => 'Month';

  @override
  String get weekGeneral => 'In general';

  @override
  String get keyDays => 'Key days';

  @override
  String get noKeyDays =>
      'There are no special events in the sky in this period. It is a good time for calm, steady work.';

  @override
  String evPhase(String phase) {
    return '$phase';
  }

  @override
  String evMoonInSign(String sign) {
    return 'Moon in your sign ($sign)';
  }

  @override
  String evSunIngress(String sign) {
    return 'The Sun enters $sign';
  }

  @override
  String get evMercuryStart => 'Mercury turns retrograde';

  @override
  String get evMercuryEnd => 'Mercury turns direct';

  @override
  String evEclipse(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'solar': 'Solar eclipse',
      'partial': 'Lunar eclipse (partial or total)',
      'other': 'Penumbral lunar eclipse (subtle)',
    });
    return '$_temp0';
  }

  @override
  String dayNumberLine(int n, String title) {
    return 'Day number $n: $title';
  }

  @override
  String get eclipsesTitle => 'Eclipses in the coming year';

  @override
  String get eclipseVisibility =>
      'Visibility depends on where you are on Earth: not every eclipse can be seen from your location.';

  @override
  String eclipseSoon(String when) {
    return 'An eclipse is coming: $when';
  }

  @override
  String get loveLabel => 'Love';

  @override
  String get workLabel => 'Work';

  @override
  String get wellbeingLabel => 'Wellbeing';

  @override
  String ichingImage(String upper, String lower) {
    return 'Image: $upper over $lower';
  }

  @override
  String get ichingLinesTitle => 'Changing lines';

  @override
  String ichingLine(int n, String text) {
    return 'Line $n: $text';
  }

  @override
  String get revealCard => 'Reveal the card';

  @override
  String get revealCardHint => 'Tap the card to see what the day brings.';

  @override
  String get cardOfDayMore => 'More about the card';

  @override
  String get moodQuestion => 'How are you feeling today?';

  @override
  String moodName(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      '1': 'Rough',
      '2': 'Low',
      '3': 'So-so',
      '4': 'Good',
      'other': 'Great',
    });
    return '$_temp0';
  }

  @override
  String get moodSaved => 'Saved on this device only.';

  @override
  String countdown(String what, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'in $days days',
      one: 'tomorrow',
      zero: 'today',
    );
    return '$what $_temp0';
  }

  @override
  String get yourBirthday => 'Your birthday';

  @override
  String notifMoon(String sign) {
    return 'Moon in $sign';
  }

  @override
  String notifDayNumber(int n) {
    return 'day number $n';
  }

  @override
  String get notifCard => 'your card of the day is waiting';

  @override
  String get tabStars => 'Stars';

  @override
  String get starsMore => 'More from the stars';

  @override
  String get deckTitle => 'The deck';

  @override
  String get fullHoroscope => 'Full horoscope';

  @override
  String get upcoming => 'Coming up';

  @override
  String get suggested => 'Suggested today';

  @override
  String get suggestBigThree =>
      'Add your time and place of birth to discover your Moon and ascendant';

  @override
  String get dayNumberShort => 'day number';

  @override
  String get dayColorShort => 'colour of the day';

  @override
  String get fullNumerology => 'Full numerology and portrait';

  @override
  String get firstEntry => 'Write a first thought';

  @override
  String get greetDay => 'Good morning';

  @override
  String get greetEvening => 'Good evening';

  @override
  String get dayHoroscope => 'Horoscope';

  @override
  String get dayNumbers => 'My numbers';

  @override
  String get dayCard => 'Card';

  @override
  String get dayDone => 'All done for today.';

  @override
  String tomorrowIs(String what) {
    return 'Tomorrow: $what.';
  }

  @override
  String tomorrowMoon(String sign) {
    return 'Tomorrow: Moon in $sign.';
  }

  @override
  String tomorrowNumber(int n) {
    return 'Tomorrow: a new card and day number $n.';
  }

  @override
  String get tomorrowCard => 'Tomorrow: a new card of the day.';

  @override
  String get tabDreams => 'Dreams';

  @override
  String get dreamAsk => 'What did you dream last night?';

  @override
  String get dreamAskHint =>
      'Write the dream down before it fades, or look up a symbol below.';

  @override
  String get dreamSave => 'Write down the dream';

  @override
  String get dreamEntry => 'Dream';

  @override
  String get dreamOfDay => 'Symbol of the day';

  @override
  String get dreamsAll => 'All symbols';

  @override
  String get widgetCardWaiting => 'Waiting to be revealed';

  @override
  String get widgetStale => 'Tap to see your day';

  @override
  String widgetCardSays(String advice) {
    return 'The card says: $advice';
  }

  @override
  String get widgetNeedBirth => 'Enter your date of birth to see your day.';

  @override
  String get language => 'Language';

  @override
  String get dateHint => 'DD.MM.YYYY';

  @override
  String get layTarot => 'Do a tarot reading';

  @override
  String get tarotWelcomeTitle => 'What will the cards suggest today?';

  @override
  String get tarotWelcomeBody =>
      'Think of what is on your mind, choose a spread and turn the cards. Every spread is a fresh view. Come back whenever a new question comes up.';

  @override
  String get seeDeck => 'See the deck';

  @override
  String get tarotWelcomeSetting => 'Intro on the Tarot tab';

  @override
  String get hide => 'Hide';

  @override
  String get tapHint => 'tap';

  @override
  String get dailyMood => 'How you may feel today';

  @override
  String get dailyEvents => 'What today may bring';

  @override
  String get dailyAdvice => 'Advice for today';

  @override
  String get energyLabel => 'Energy';

  @override
  String meterValue(String label, int n) {
    return '$label: $n out of 5';
  }

  @override
  String get cheerAll => 'A beautiful day — the stars are on your side';

  @override
  String get cheerLove => 'A good day for the heart';

  @override
  String get cheerWork => 'A good day to get things done';

  @override
  String get cheerEnergy => 'A day full of energy';

  @override
  String get cheerUpLove => 'Love looks better than yesterday';

  @override
  String get cheerUpWork => 'Work looks better than yesterday';

  @override
  String get cheerUpEnergy => 'More energy than yesterday';

  @override
  String get cheerNewMoon => 'New Moon — a good time for a fresh intention';

  @override
  String get cheerWaxing => 'The Moon is growing, and so are your plans';

  @override
  String get cheerFullMoon =>
      'Full Moon — time to appreciate what you already have';

  @override
  String get cheerWaning =>
      'The Moon is waning — easier to let go of what weighs on you';

  @override
  String get cheerNewMoon2 =>
      'New Moon — a clean page. Write something good on it';

  @override
  String get cheerNewMoon3 => 'New Moon — the best ideas are born in quiet';

  @override
  String get cheerWaxing2 =>
      'The Moon is waxing — a good time to add small steps';

  @override
  String get cheerWaxing3 => 'The growing Moon favours what you begin';

  @override
  String get cheerFullMoon2 =>
      'Full Moon — you can see more today. Also what went well';

  @override
  String get cheerFullMoon3 =>
      'Full Moon — a good evening to celebrate small things';

  @override
  String get cheerWaning2 =>
      'The Moon is waning — a good time to tidy up and breathe';

  @override
  String get cheerWaning3 =>
      'The waning Moon favours rest and finishing things';

  @override
  String get threeGood => 'Write down three good things';

  @override
  String get threeGoodPrompt =>
      'Three good things from this week — and what made them happen:';

  @override
  String moodReply(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      '1': 'Hard days happen. You don\'t have to make up for anything today.',
      '2': 'A weaker day is fine too. One small step is enough.',
      '3': 'An ordinary day counts as well.',
      '4': 'Good to hear.',
      'other': 'Lovely. Worth remembering what made it so.',
    });
    return '$_temp0';
  }

  @override
  String get reminderAsk =>
      'Would you like the card of the day to wait for you each morning?';

  @override
  String get reminderAskSub =>
      'One notification a day at 8:00, with the day\'s content. Change the time or turn it off in Settings.';

  @override
  String get reminderYes => 'Yes, remind me';

  @override
  String get reminderNo => 'No, thanks';

  @override
  String get onboardBirthHint =>
      'Optional. With the date you will see your sign, horoscope and numbers right away.';

  @override
  String get lookBack => 'Your days';

  @override
  String get lookBackHint =>
      'Cards of the day and mood, day by day. Stored only on this device.';
}
