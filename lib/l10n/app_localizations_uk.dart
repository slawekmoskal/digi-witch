// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Digi Witch';

  @override
  String get tabToday => 'Сьогодні';

  @override
  String get tabNumerology => 'Числа';

  @override
  String get tabTarot => 'Таро';

  @override
  String get tabLibrary => 'Бібліотека';

  @override
  String get tabJournal => 'Щоденник';

  @override
  String get settings => 'Налаштування';

  @override
  String get start => 'Почнімо';

  @override
  String get onboardWhat =>
      'Твій щоденний провідник у світі символів: гороскоп на сьогодні, Місяць, таро, нумерологія, китайський знак і сонник. Кожен розрахунок показано крок за кроком, а кожну карту пояснено в бібліотеці.';

  @override
  String get onboardNot =>
      'Цей застосунок — інструмент для розваги, знайомства із символікою та саморефлексії. Він не передбачає майбутнього, не вимірює особистість у науковому сенсі й не замінює порад фахівця.';

  @override
  String get onboardPrivacy =>
      'Обліковий запис не потрібен. Дати, імена та твій щоденник залишаються на цьому пристрої.';

  @override
  String get onboardAdults => 'Застосунок призначений для дорослих.';

  @override
  String get reversed => 'перевернута';

  @override
  String get writeReflection => 'Записати роздуми в щоденник';

  @override
  String get exportJournal => 'Експортувати щоденник';

  @override
  String get newEntry => 'Новий запис';

  @override
  String get editEntry => 'Запис';

  @override
  String get journalEmpty =>
      'Твій щоденник порожній. Запиши першу думку — наприклад, про питання дня або витягнуту карту.';

  @override
  String get journalPrivacy => 'Записи зберігаються лише на цьому пристрої.';

  @override
  String get deleteEntryConfirm =>
      'Видалити цей запис? Цю дію не можна скасувати.';

  @override
  String get cancel => 'Скасувати';

  @override
  String get delete => 'Видалити';

  @override
  String get save => 'Зберегти';

  @override
  String get linkedResult => 'Пов’язаний результат';

  @override
  String get promptsTitle => 'Питання для початку (необов’язково)';

  @override
  String promptCategory(String c) {
    String _temp0 = intl.Intl.selectLogic(c, {
      'ogolne': 'Загальні',
      'rodzina': 'Родина',
      'tarot': 'Таро',
      'liczby': 'Числа',
      'other': 'Інше',
    });
    return '$_temp0';
  }

  @override
  String get randomPrompt => 'Випадкове питання';

  @override
  String get familyNote =>
      'Пиши лише те, чим хочеш поділитися. Замість імен близьких можна використовувати прізвиська.';

  @override
  String get entryHint => 'Твої думки…';

  @override
  String get tarotIntro =>
      'Ми сприймаємо карти як привід для роздумів, а не як передбачення. Позиції розкладу — це питання, які варто поставити собі.';

  @override
  String get drawCards => 'Витягнути карти';

  @override
  String get drawAgain => 'Витягнути знову';

  @override
  String get reversedOn =>
      'Перевернуті карти: увімкнено (кожна карта окремо, з імовірністю 1 до 2).';

  @override
  String get reversedOff =>
      'Перевернуті карти: вимкнено. Їх можна увімкнути в налаштуваннях.';

  @override
  String get spreadReflectionPrompt =>
      'Що в цьому розкладі зачепило мене найбільше і чому?';

  @override
  String get questionLabel => 'Твоє питання (необов’язково)';

  @override
  String get questionHint => 'напр. На що зважати, змінюючи роботу?';

  @override
  String get readingTitle => 'Що карти кажуть про твоє питання';

  @override
  String get readingTitleNoQuestion => 'Підсумок розкладу';

  @override
  String get summaryMajors =>
      'Переважають Старші аркани: ідеться про щось важливе, більше за повсякденні рішення.';

  @override
  String summarySuit(String suit) {
    String _temp0 = intl.Intl.selectLogic(suit, {
      'wands': 'Переважно Жезли: на тлі — енергія, дія та ініціатива.',
      'cups': 'Переважно Кубки: на тлі — емоції, почуття та стосунки.',
      'swords': 'Переважно Мечі: на тлі — думки, рішення та складні розмови.',
      'pentacles':
          'Переважно Пентаклі: на тлі — робота, гроші та практичні справи.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get summaryReversed =>
      'Більшість карт перевернуті: можливо, щось заблоковане, відкладене або переживається більше всередині, ніж назовні.';

  @override
  String get summaryBalanced =>
      'Карти розподілені рівномірно: жодна сфера явно не переважає.';

  @override
  String summaryAnswer(String position, String card, String advice) {
    return 'Відповідь карт: $card у позиції «$position»: $advice';
  }

  @override
  String get addBookmark => 'Додати закладку';

  @override
  String get removeBookmark => 'Прибрати закладку';

  @override
  String get group => 'Група';

  @override
  String get keywords => 'Ключові слова';

  @override
  String get symbolism => 'Символіка';

  @override
  String get upright => 'Пряме значення';

  @override
  String get reversedMeaning => 'Перевернуте значення';

  @override
  String get reflectionQuestions => 'Питання для роздумів';

  @override
  String get reflectionQuestion => 'Питання для роздумів';

  @override
  String get sourcesAndRights => 'Джерела та права';

  @override
  String get cardSourceNote =>
      'Описи карт — оригінальні тексти, написані для цього застосунку. Ілюстрація: Памела Колман Сміт (1878–1951), колода 1909 року, суспільне надбання; скан примірника «Roses & Lilies» (Saskia Jansen), опублікований на Wikimedia Commons. Зображення лише змінено за розміром.';

  @override
  String get numerologyIntro =>
      'Введи дату народження і, за бажанням, повне ім’я. Збережені як профіль, вони відкривають гороскоп на сьогодні, число дня, твою велику трійку та китайський знак. Дані залишаються лише на цьому телефоні.';

  @override
  String get birthDate => 'Дата народження';

  @override
  String get birthDateHelp => 'Лише цифри: день, місяць, рік, напр. 15071990';

  @override
  String get fullNameOptional => 'Повне ім’я (необов’язково)';

  @override
  String get fullNameHelp =>
      'Потрібне лише для чисел, що рахуються з літер. Ім’я потрібно ввести латиницею (транслітерацією); пробіли, дефіси та апострофи пропускаються.';

  @override
  String get personalYearFor => 'Особистий рік для:';

  @override
  String get previousYear => 'Попередній рік';

  @override
  String get nextYear => 'Наступний рік';

  @override
  String get calculate => 'Розрахувати';

  @override
  String get saveAsProfile => 'Зберегти як мій профіль';

  @override
  String get profileSaved => 'Збережено на цьому пристрої.';

  @override
  String get portrait => 'Нумерологічний портрет';

  @override
  String get portraitNote =>
      'Розгорни число, щоб побачити розрахунок і його символічне тлумачення. Результати відповідають умовам, описаним у бібліотеці («Як ми рахуємо»).';

  @override
  String indicatorName(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'lifePath': 'Число життєвого шляху',
      'birthDay': 'Число дня народження',
      'expression': 'Число вираження',
      'soulUrge': 'Число душі',
      'personality': 'Число особистості',
      'personalYear': 'Особистий рік',
      'personalDay': 'Число дня',
      'relation': 'Число стосунків',
      'personalMonth': 'Особистий місяць',
      'maturity': 'Число зрілості',
      'house': 'Число дому',
      'other': 'Число',
    });
    return '$_temp0';
  }

  @override
  String get noBasis => 'Немає що рахувати';

  @override
  String get calculation => 'Розрахунок';

  @override
  String get symbolicInterpretation => 'Символічне тлумачення';

  @override
  String get enterDateOrName => 'Введи дату народження або повне ім’я.';

  @override
  String get dateInvalid => 'Такої дати не існує. Перевір день і місяць.';

  @override
  String get dateFuture => 'Дата не може бути в майбутньому.';

  @override
  String get nameNoLetters => 'Введи хоча б одну літеру.';

  @override
  String nameUnsupported(String chars) {
    return 'Непідтримувані символи: $chars. Введи написання латиницею (транслітерацію), яке хочеш використати для розрахунку, напр. «Olena Kovalenko».';
  }

  @override
  String get cardOfDay => 'Карта дня';

  @override
  String get cardOfDayNote =>
      'Карта дня не змінюється до кінця дня за годинником цього пристрою.';

  @override
  String get promptOfDay => 'Питання дня';

  @override
  String yourPersonalYear(int year) {
    final intl.NumberFormat yearNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String yearString = yearNumberFormat.format(year);

    return 'Твій особистий рік $yearString';
  }

  @override
  String get search => 'Шукати карти, терміни, статті';

  @override
  String get bookmarks => 'Закладки';

  @override
  String get articles => 'Статті';

  @override
  String cardsCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Карти ($n)',
      many: 'Карти ($n)',
      few: 'Карти ($n)',
      one: 'Карти ($n)',
    );
    return '$_temp0';
  }

  @override
  String get archetypes => 'Архетипи';

  @override
  String get archetypesNote =>
      'Описи 12 архетипів — власні тексти цього застосунку. Сам поділ спирається на відомий набір дванадцяти архетипів: один із багатьох можливих поділів, а не канон і не психологічний тест.';

  @override
  String get aboutModel => 'Про модель';

  @override
  String get archetypeGifts => 'Дари';

  @override
  String get archetypeShadow => 'Тінь';

  @override
  String get glossary => 'Словник';

  @override
  String get theme => 'Тема';

  @override
  String get themeSystem => 'Системна';

  @override
  String get themeLight => 'Світла';

  @override
  String get themeDark => 'Темна';

  @override
  String get allowReversed => 'Перевернуті карти';

  @override
  String get allowReversedRule =>
      'Якщо увімкнено, кожна витягнута карта незалежно перевертається з імовірністю 1 до 2.';

  @override
  String get profile => 'Мій профіль';

  @override
  String get privacy => 'Конфіденційність';

  @override
  String get privacyBody =>
      'Ми не створюємо облікових записів і не надсилаємо твоїх дат, імен чи записів на сервер. Твої дані є лише на цьому пристрої, якщо ти не експортуєш їх самостійно.';

  @override
  String get deleteAllTitle => 'Видалити всі дані';

  @override
  String get deleteAllBody =>
      'Ми видалимо з цього пристрою щоденник, профіль, закладки, карту дня та налаштування. Цю дію не можна скасувати.';

  @override
  String get deleteAllFailed => 'Не вдалося видалити всі дані. Спробуй ще раз.';

  @override
  String get sourcesBody =>
      'Тлумачення, питання, архетипи та статті — оригінальні тексти. Ілюстрації карт: Памела Колман Сміт, колода 1909 року (суспільне надбання), скани з Wikimedia Commons; подробиці наведено біля кожної карти. Історичні джерела вказано наприкінці статей. Застосунок не пов’язаний з U.S. Games Systems, Inc.';

  @override
  String get purchases => 'Digi Witch Pro';

  @override
  String get help => 'Допомога';

  @override
  String get helpBody =>
      'Якщо ти в кризі, звернися до фахівця з психічного здоров’я або на лінію підтримки: в Україні — Lifeline Ukraine 7333 (цілодобово, безкоштовно), у Польщі — 116 123. У разі небезпеки телефонуй 112.';

  @override
  String get versions => 'Версії';

  @override
  String get algorithm => 'алгоритм';

  @override
  String get contentVer => 'вміст';

  @override
  String get disclaimer =>
      'Цей вміст призначений для розваги, навчання та саморефлексії. Він не є медичною, психологічною, юридичною чи фінансовою порадою.';

  @override
  String get proShort => 'Одноразова покупка: без реклами, додаткові розклади.';

  @override
  String get proTitle => 'Digi Witch Pro';

  @override
  String get proBenefits =>
      '• Жодної реклами в усьому застосунку\n• Додаткові розклади: «Стосунки» (6 карт) і «Хрест роздумів» (10 карт)\n• Одноразовий платіж, без підписки';

  @override
  String get proFreeStays =>
      'Нумерологія, карта дня, розклади на 1, 3 і 5 карт, бібліотека та щоденник залишаються безкоштовними. Купівля Pro не впливає ні на те, які карти випадають, ні на те, як рахуються результати.';

  @override
  String get proActive => 'У тебе є Pro. Дякуємо!';

  @override
  String get proUnavailable =>
      'Покупка зараз недоступна. Перевір підключення до інтернету та спробуй пізніше.';

  @override
  String proBuy(String price) {
    return 'Купити Pro за $price';
  }

  @override
  String get purchaseError =>
      'Покупку не завершено. Кошти не списано, якщо магазин не підтвердив транзакцію.';

  @override
  String get restorePurchases => 'Відновити покупки';

  @override
  String get proOnly => 'Доступно в Pro';

  @override
  String get adPrivacyOptions => 'Налаштування конфіденційності реклами';

  @override
  String get privacyPolicy => 'Політика конфіденційності';

  @override
  String get reminder => 'Щоденне нагадування';

  @override
  String get reminderOff => 'Вимкнено';

  @override
  String reminderAt(String time) {
    return 'Щодня о $time';
  }

  @override
  String get reminderTitle => 'Digi Witch';

  @override
  String get reminderBody => 'Хвилинка для роздумів, якщо маєш бажання.';

  @override
  String get reminderDenied =>
      'Сповіщення не дозволено. Їх можна дозволити в системних налаштуваннях.';

  @override
  String get proStoreNote =>
      'Оплату й можливі повернення коштів обробляють App Store або Google Play за власними правилами. Покупка діє незалежно від того, чи погоджуєшся ти на рекламу.';

  @override
  String get horoscopeToday => 'Сьогодні';

  @override
  String get horoscopeStars => 'Зорі кажуть';

  @override
  String get horoscopeCaution => 'Зважай на';

  @override
  String moonIn(String sign, String phase) {
    return 'Місяць $sign, $phase.';
  }

  @override
  String get luckyNumbers => 'Щасливі числа дня';

  @override
  String get luckyNote =>
      'Для розваги: числа виходять із твоєї дати народження та сьогоднішньої дати, тому не змінюються протягом дня. Вони не передбачають виграшів.';

  @override
  String get whyThis => 'Звідки це';

  @override
  String whySign(
    String sign,
    String dates,
    String element,
    String chinese,
    String chineseText,
  ) {
    return 'Твій знак: $sign ($dates), стихія: $element. Китайський знак: $chinese. $chineseText';
  }

  @override
  String whyMoon(String sign, String element, String relation) {
    String _temp0 = intl.Intl.selectLogic(relation, {
      'same': 'та сама стихія',
      'supportive': 'підтримувальний',
      'tense': 'напружений',
      'other': 'нейтральний',
    });
    return 'Сьогодні опівдні Місяць у знаку $sign (стихія: $element). Зв’язок із твоєю стихією: $_temp0.';
  }

  @override
  String get whyMethod =>
      'Положення Місяця розраховується офлайн за астрономічними формулами (з точністю близько 0,5°). Текст «Сьогодні» залежить від зв’язку стихій, «Зорі кажуть» — від фази Місяця, а «Зважай на» — від твого числа дня.';

  @override
  String get horoscopeNeedsBirth =>
      'Введи дату народження — і одразу побачиш свій знак, гороскоп на сьогодні, число дня та щасливі числа.';

  @override
  String get moonToday => 'Місяць сьогодні';

  @override
  String moonState(String phase, int percent, String sign) {
    return '$phase · освітлено $percent% · $sign';
  }

  @override
  String get moonCalendar => 'Місячний календар';

  @override
  String get moonCalendarIntro =>
      'Найближчі головні фази Місяця за місцевим часом (з точністю близько 1 години).';

  @override
  String get compatibility => 'Сумісність двох людей';

  @override
  String get compatIntro =>
      'Введи дві дати народження. Ми порівняємо знаки зодіаку, стихії, китайські знаки та числа життєвого шляху. Це гра й привід для розмови, а не вирок стосункам.';

  @override
  String personDate(int n) {
    return 'Дата народження: особа $n';
  }

  @override
  String get check => 'Порівняти';

  @override
  String get compatElements => 'Стихії';

  @override
  String personLine(
    int n,
    String sign,
    String element,
    String chinese,
    int lifePath,
  ) {
    return 'Особа $n: $sign ($element) · китайський знак: $chinese · життєвий шлях $lifePath';
  }

  @override
  String get birthCardTitle => 'Карта народження';

  @override
  String get birthCardNote =>
      'Метод: день + місяць + рік народження, потім цифри додаються, доки результат не стане не більшим за 22 (22 = Блазень). Двоцифровий результат дає ще й карту-супутницю.';

  @override
  String get birthCardSecond => 'Карта-супутниця';

  @override
  String yesNoAnswer(String a) {
    String _temp0 = intl.Intl.selectLogic(a, {
      'yes': 'Відповідь карт: ТАК',
      'no': 'Відповідь карт: НІ',
      'other': 'Відповідь карт: НЕЯСНО. Справа ще не вирішена',
    });
    return '$_temp0';
  }

  @override
  String get horoscopeFor => 'Сьогодні для тебе';

  @override
  String get licenses => 'Ліцензії (шрифти та бібліотеки)';

  @override
  String get cardAdvice => 'Порада карти';

  @override
  String get correspondences =>
      'Астрологічні відповідності (Golden Dawn, XIX століття)';

  @override
  String get chooseSpread => 'Обери розклад';

  @override
  String get tapDeck => 'Подумай про своє питання й торкнися колоди';

  @override
  String spreadCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n карти',
      many: '$n карт',
      few: '$n карти',
      one: '$n карта',
    );
    return '$_temp0';
  }

  @override
  String get bigThree => 'Твоя велика трійка';

  @override
  String get bigThreeIntro =>
      'Сонце — це твій знак зодіаку. Місяць описує емоції, а асцендент — те, як тебе бачать інші. Для Місяця зазвичай досить дати; для асцендента потрібні час і місце народження. Дані залишаються лише на цьому пристрої.';

  @override
  String get birthTime => 'Час народження';

  @override
  String get notGiven => 'не вказано';

  @override
  String get birthPlace => 'Місце народження';

  @override
  String get placesNote =>
      'Міста Польщі та великі міста світу, зокрема України. Якщо твого немає, обери найближче в тій самій країні або введи координати. Кілька десятків кілометрів змінюють асцендент менш ніж на 1°.';

  @override
  String get sunLabel => 'Сонце';

  @override
  String get moonLabel => 'Місяць';

  @override
  String get ascLabel => 'Асцендент';

  @override
  String moonTwoSigns(String a, String b) {
    return 'Того дня Місяць змінив знак: $a або $b, залежно від часу народження.';
  }

  @override
  String get ascNeeds =>
      'Введи час і місце народження, щоб розрахувати асцендент.';

  @override
  String traceTime(String local, String utc, String zone) {
    return 'Місцевий час $local → $utc UTC (зона $zone, з історією переходу на літній час).';
  }

  @override
  String traceMoon(String deg, String sign) {
    return 'Екліптична довгота Місяця: $deg° → $sign.';
  }

  @override
  String traceAsc(
    String deg,
    String sign,
    String place,
    String lat,
    String lon,
  ) {
    return 'Асцендент: $deg° → $sign ($place, $lat° пн. ш., $lon° сх. д.).';
  }

  @override
  String get needBirthDate =>
      'Спершу збережи дату народження на вкладці «Числа» (кнопка «Зберегти як мій профіль»).';

  @override
  String get clear => 'Очистити';

  @override
  String get chineseTitle => 'Китайський гороскоп';

  @override
  String chineseBirthYear(int year, String element, String yy) {
    String _temp0 = intl.Intl.selectLogic(yy, {'yang': 'ян', 'other': 'інь'});
    return 'Рік за китайським календарем: $year · $element · $_temp0';
  }

  @override
  String get chineseNewYearNote =>
      'Китайський Новий рік припадає на період між 21 січня та 20 лютого. Якщо дата народження припадає раніше, діє знак попереднього року. Тут це вже враховано.';

  @override
  String chineseCurrentYear(int year, String animal, String element) {
    return 'Рік $year: $animal · $element';
  }

  @override
  String chineseYearSince(String date) {
    return 'Поточний китайський рік почався $date.';
  }

  @override
  String get chineseCompatTitle => 'Сумісність китайських знаків';

  @override
  String get chineseFriend => 'Таємний друг';

  @override
  String get chineseTrine => 'Трикутник союзників';

  @override
  String get chineseClash => 'Протилежний знак';

  @override
  String get chineseElement => 'Стихія року народження';

  @override
  String get mercuryRetro => 'Ретроградний Меркурій';

  @override
  String mercuryNow(String date) {
    return 'Меркурій ретроградний до $date';
  }

  @override
  String get mercuryNone =>
      'Протягом наступного року ретроградних періодів немає.';

  @override
  String get upcomingPhases => 'Найближчі фази';

  @override
  String get dayByDay => 'День за днем (30 днів)';

  @override
  String moonDayLine(String sign, String phase) {
    return 'Місяць $sign · $phase';
  }

  @override
  String get dreams => 'Сонник';

  @override
  String dreamsCount(int n) {
    return '$n символів снів: що сон може сказати тобі про тебе';
  }

  @override
  String get dreamsIntro =>
      'Сни не передбачають майбутнього. Сонник підказує, з чим символ часто пов’язують, а питання допомагає з’ясувати, що він означає саме для тебе. Найважливіше — які почуття були уві сні.';

  @override
  String get dreamsSearch => 'Шукай символ, напр. вода, зуби, дім';

  @override
  String get dreamsEmpty =>
      'Такого символу немає. Спробуй схоже слово або запиши сон у щоденник.';

  @override
  String chineseSignButton(String animal) {
    return 'Китайський знак: $animal';
  }

  @override
  String get otherPlace => 'Інше місце: ввести координати';

  @override
  String otherPlaceSet(String place, String zone) {
    return 'Інше місце: $place ($zone)';
  }

  @override
  String get otherPlaceHelp =>
      'Координати можна знайти в застосунку з картами (наприклад, торкнувшись місця в Google Maps). Південь і захід вводь зі знаком мінус. Часова зона — це регіон, напр. Europe/Kyiv, America/Toronto.';

  @override
  String get latitude => 'Широта';

  @override
  String get longitude => 'Довгота';

  @override
  String get timeZone => 'Часова зона';

  @override
  String get otherPlaceMissing => 'Введи широту, довготу й часову зону.';

  @override
  String get otherPlaceRange =>
      'Широта має бути від -66° до 66° (за полярним колом асцендент може бути невизначеним), довгота — від -180° до 180°.';

  @override
  String get numbersStartTitle => 'Почни з дати народження';

  @override
  String get numbersEditTitle =>
      'Змінити дані або розрахувати для когось іншого';

  @override
  String get calculateOnce => 'Лише розрахувати (без збереження)';

  @override
  String get compatibilityHint => 'Порівняти дві дати народження';

  @override
  String get yourNumbers => 'Твої числа';

  @override
  String get editOrOther => 'Змінити дані або розрахувати для когось іншого';

  @override
  String get showMyHoroscope => 'Показати мій гороскоп';

  @override
  String get privacyShort =>
      'Дата залишається лише на цьому телефоні. Її можна змінити на вкладці «Числа».';

  @override
  String get explore => 'Досліджуй';

  @override
  String get exploreBigThree => 'Сонце, Місяць і асцендент';

  @override
  String get exploreChinese => 'Знак, стихія і твій рік';

  @override
  String get exploreTarot => 'Запитай карти';

  @override
  String get exploreTarotSub => 'Розклади та питання «так чи ні»';

  @override
  String get exploreNumbersSub => 'Життєвий шлях і карта народження';

  @override
  String get exploreMoon => 'Фази, сад, ретроградний Меркурій';

  @override
  String get exploreDreams => 'Про що говорить твій сон';

  @override
  String get exploreLibrary => '78 карт, статті, словник — у бібліотеці';

  @override
  String get exploreLibraryTitle => 'Карти та статті';

  @override
  String get squareTitle => 'Квадрат Піфагора';

  @override
  String get squareIntro =>
      'Таблиця цифр із твоєї дати народження (метод Александрова): що частіше трапляється цифра, то сильніша риса. Торкнися клітинки, щоб прочитати опис.';

  @override
  String get squareEmpty => 'немає';

  @override
  String get cyclesTitle => 'Життєві цикли: вершини й виклики';

  @override
  String get cyclesIntro =>
      'Нумерологія ділить життя на чотири етапи. Кожен має свою «вершину» — тему для зростання — і свій «виклик» — урок, який варто пропрацювати. Тривалість першого етапу залежить від твого життєвого шляху.';

  @override
  String ageRange(int from, int to) {
    return '$from–$to років';
  }

  @override
  String ageFrom(int from) {
    return 'від $from років';
  }

  @override
  String get cyclesNow => 'ЗАРАЗ';

  @override
  String get ichingTitle => 'Оракул І Цзин';

  @override
  String get ichingIntro =>
      'Книга змін — класичний китайський оракул. Подумай про своє питання й шість разів підкинь три монети; гексаграма будується знизу вгору. Риси, позначені крапкою, — «змінні»: вони показують, на що перетворюється ситуація.';

  @override
  String ichingToss(int n) {
    return 'Підкинути монети ($n/6)';
  }

  @override
  String ichingLastToss(String sum) {
    String _temp0 = intl.Intl.selectLogic(sum, {
      '6': 'решка, решка, решка = 6 (старий інь, змінна)',
      '7': 'дві решки й орел = 7 (ян)',
      '8': 'два орли й решка = 8 (інь)',
      'other': 'орел, орел, орел = 9 (старий ян, змінна)',
    });
    return 'Останній кидок: $_temp0';
  }

  @override
  String get ichingMeaning => 'Значення';

  @override
  String get ichingChange => 'Напрям змін';

  @override
  String ichingChangingLines(String lines) {
    return 'Змінні риси: $lines. Ситуація перетворюється на:';
  }

  @override
  String get ichingAgain => 'Нове питання';

  @override
  String get ichingNote =>
      'Описи гексаграм і рис — власні короткі тлумачення цього застосунку, натхненні образами давнього китайського тексту. Сприймай їх як привід для роздумів.';

  @override
  String get exploreIching => 'Питання й шість кидків монет';

  @override
  String get ritualsTitle => 'Місячні ритуали';

  @override
  String get exploreRituals => 'Наміри на молодий і повний місяць';

  @override
  String get ritualsIntro =>
      'Молодий і повний місяць задають ритм місяця. На молодик запиши намір, а на повню озирнися на те, що сталося. Твої записи потрапляють у щоденник.';

  @override
  String get moonRemindersToggle => 'Нагадувати про молодик і повню';

  @override
  String get moonRemindersNote =>
      'Сповіщення о 9:00 в день молодика й повні. Працює офлайн.';

  @override
  String get moonReminderNewTitle => 'Молодик: час для наміру';

  @override
  String get moonReminderNewBody => 'Запиши, що хочеш почати в цьому циклі.';

  @override
  String get moonReminderFullTitle => 'Повня: час озирнутися';

  @override
  String get moonReminderFullBody =>
      'Що вдалося від молодика? За що хочеться подякувати?';

  @override
  String get forYouToday => 'Саме для тебе';

  @override
  String get advice => 'Порада';

  @override
  String get karmicTitle => 'Карма в числах';

  @override
  String get karmicIntro =>
      'Кармічні борги — це числа 13, 14, 16 і 19, що з’являються дорогою до твоїх чисел. Кармічні уроки — цифри, яких бракує у твоєму повному імені. У традиції вони описують теми для пропрацювання, а не вироки.';

  @override
  String get karmicNone => 'У твоїх числах немає кармічних боргів.';

  @override
  String get karmicLessonsTitle =>
      'Кармічні уроки (цифри, яких бракує в імені)';

  @override
  String get houseTitle => 'Нумерологія дому й телефону';

  @override
  String get houseHint => 'Номер будинку, квартири або телефону, напр. 12А';

  @override
  String luckyMeaning(int n, int reduced, String keywords) {
    return '$n → $reduced: $keywords';
  }

  @override
  String dayColor(String color) {
    return 'Колір дня: $color';
  }

  @override
  String signExtras(String color, String stone, String day, String planet) {
    return 'Колір: $color · камінь: $stone · день: $day · планета: $planet';
  }

  @override
  String get periodTitle => 'Гороскоп на тиждень і місяць';

  @override
  String get explorePeriod => 'Ключові дні та твій особистий місяць';

  @override
  String get periodIntro =>
      'Розраховано за справжнім небом: фази Місяця, затемнення, ретроградний Меркурій, перехід Сонця в наступний знак і дні, коли Місяць у твоєму знаку, а також твої особисті числа.';

  @override
  String get tabWeek => 'Тиждень';

  @override
  String get tabMonth => 'Місяць';

  @override
  String get weekGeneral => 'Загалом';

  @override
  String get keyDays => 'Ключові дні';

  @override
  String get noKeyDays =>
      'У цей період на небі немає особливих подій. Добрий час для спокійної, рівної роботи.';

  @override
  String evPhase(String phase) {
    return '$phase';
  }

  @override
  String evMoonInSign(String sign) {
    return 'Місяць у твоєму знаку ($sign)';
  }

  @override
  String evSunIngress(String sign) {
    return 'Сонце переходить у знак $sign';
  }

  @override
  String get evMercuryStart => 'Меркурій стає ретроградним';

  @override
  String get evMercuryEnd => 'Меркурій стає директним';

  @override
  String evEclipse(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'solar': 'Сонячне затемнення',
      'partial': 'Місячне затемнення (часткове або повне)',
      'other': 'Півтіньове місячне затемнення (ледь помітне)',
    });
    return '$_temp0';
  }

  @override
  String dayNumberLine(int n, String title) {
    return 'Число дня $n: $title';
  }

  @override
  String get eclipsesTitle => 'Затемнення наступного року';

  @override
  String get eclipseVisibility =>
      'Видимість залежить від того, де ти на Землі: не кожне затемнення видно з твого місця.';

  @override
  String eclipseSoon(String when) {
    return 'Наближається затемнення: $when';
  }

  @override
  String get loveLabel => 'Кохання';

  @override
  String get workLabel => 'Робота';

  @override
  String get wellbeingLabel => 'Самопочуття';

  @override
  String ichingImage(String upper, String lower) {
    return 'Образ: $upper над $lower';
  }

  @override
  String get ichingLinesTitle => 'Змінні риси';

  @override
  String ichingLine(int n, String text) {
    return 'Риса $n: $text';
  }

  @override
  String get revealCard => 'Відкрити карту';

  @override
  String get revealCardHint => 'Торкнися карти, щоб побачити, що принесе день.';

  @override
  String get cardOfDayMore => 'Більше про карту';

  @override
  String get moodQuestion => 'Як ти почуваєшся сьогодні?';

  @override
  String moodName(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      '1': 'Важко',
      '2': 'Сумно',
      '3': 'Так собі',
      '4': 'Добре',
      'other': 'Чудово',
    });
    return '$_temp0';
  }

  @override
  String get moodSaved => 'Збережено лише на цьому пристрої.';

  @override
  String countdown(String what, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'через $days дня',
      many: 'через $days днів',
      few: 'через $days дні',
      one: 'через $days день',
      zero: 'сьогодні',
    );
    return '$what $_temp0';
  }

  @override
  String get yourBirthday => 'Твій день народження';

  @override
  String notifMoon(String sign) {
    return 'Місяць $sign';
  }

  @override
  String notifDayNumber(int n) {
    return 'число дня $n';
  }

  @override
  String get notifCard => 'твоя карта дня чекає';

  @override
  String get tabStars => 'Зорі';

  @override
  String get starsMore => 'Більше від зірок';

  @override
  String get deckTitle => 'Колода';

  @override
  String get fullHoroscope => 'Повний гороскоп';

  @override
  String get upcoming => 'Незабаром';

  @override
  String get suggested => 'Пропозиції на сьогодні';

  @override
  String get suggestBigThree =>
      'Додай час і місце народження, щоб дізнатися свій Місяць і асцендент';

  @override
  String get dayNumberShort => 'число дня';

  @override
  String get dayColorShort => 'колір дня';

  @override
  String get fullNumerology => 'Повна нумерологія та портрет';

  @override
  String get firstEntry => 'Записати першу думку';

  @override
  String get greetDay => 'Доброго ранку';

  @override
  String get greetEvening => 'Добрий вечір';

  @override
  String get dayHoroscope => 'Гороскоп';

  @override
  String get dayNumbers => 'Мої числа';

  @override
  String get dayCard => 'Карта';

  @override
  String get dayDone => 'На сьогодні все готово.';

  @override
  String tomorrowIs(String what) {
    return 'Завтра: $what.';
  }

  @override
  String tomorrowMoon(String sign) {
    return 'Завтра: Місяць $sign.';
  }

  @override
  String tomorrowNumber(int n) {
    return 'Завтра: нова карта й число дня $n.';
  }

  @override
  String get tomorrowCard => 'Завтра: нова карта дня.';

  @override
  String get tabDreams => 'Сни';

  @override
  String get dreamAsk => 'Що тобі сьогодні наснилося?';

  @override
  String get dreamAskHint =>
      'Запиши сон, поки він не розвіявся, або знайди символ нижче.';

  @override
  String get dreamSave => 'Записати сон';

  @override
  String get dreamEntry => 'Сон';

  @override
  String get dreamOfDay => 'Символ дня';

  @override
  String get dreamsAll => 'Усі символи';

  @override
  String get widgetCardWaiting => 'Чекає, щоб її відкрили';

  @override
  String get widgetStale => 'Торкнися, щоб побачити свій день';

  @override
  String widgetCardSays(String advice) {
    return 'Карта каже: $advice';
  }

  @override
  String get widgetNeedBirth =>
      'Введи дату народження, щоб побачити свій день.';

  @override
  String get language => 'Мова';

  @override
  String get dateHint => 'ДД.ММ.РРРР';

  @override
  String get layTarot => 'Зробити розклад';

  @override
  String get tarotWelcomeTitle => 'Що сьогодні підкажуть карти?';

  @override
  String get tarotWelcomeBody =>
      'Подумай про те, що тебе хвилює, обери розклад і відкрий карти. Кожен розклад — це новий погляд. Повертайся, коли з’явиться нове питання.';

  @override
  String get seeDeck => 'Переглянути колоду';

  @override
  String get tarotWelcomeSetting => 'Вступ на вкладці «Таро»';

  @override
  String get hide => 'Сховати';

  @override
  String get tapHint => 'торкніться';

  @override
  String get dailyMood => 'Як ти можеш почуватися сьогодні';

  @override
  String get dailyEvents => 'Що може статися сьогодні';

  @override
  String get dailyAdvice => 'Порада на сьогодні';

  @override
  String get energyLabel => 'Енергія';

  @override
  String meterValue(String label, int n) {
    return '$label: $n з 5';
  }

  @override
  String get cheerAll => 'Чудовий день — зорі на твоєму боці';

  @override
  String get cheerLove => 'Добрий день для серця';

  @override
  String get cheerWork => 'Добрий день, щоб діяти';

  @override
  String get cheerEnergy => 'День, сповнений енергії';

  @override
  String get cheerUpLove => 'У коханні краще, ніж учора';

  @override
  String get cheerUpWork => 'У роботі краще, ніж учора';

  @override
  String get cheerUpEnergy => 'Більше енергії, ніж учора';

  @override
  String get cheerNewMoon => 'Молодик — добрий час для нового наміру';

  @override
  String get cheerWaxing => 'Місяць росте, а з ним і твої плани';

  @override
  String get cheerFullMoon => 'Повня — час цінувати те, що вже маєш';

  @override
  String get cheerWaning => 'Місяць спадає — легше відпустити те, що обтяжує';

  @override
  String get cheerNewMoon2 =>
      'Молодик — чиста сторінка. Запиши на ній щось добре';

  @override
  String get cheerNewMoon3 => 'Молодик — у тиші народжуються найкращі ідеї';

  @override
  String get cheerWaxing2 =>
      'Місяць прибуває — добрий час додавати маленькі кроки';

  @override
  String get cheerWaxing3 => 'Зростаючий Місяць сприяє тому, що ти починаєш';

  @override
  String get cheerFullMoon2 =>
      'Повня — сьогодні видно більше. І те, що тобі вдалося';

  @override
  String get cheerFullMoon3 =>
      'Повня — добрий вечір, щоб відсвяткувати дрібниці';

  @override
  String get cheerWaning2 =>
      'Місяць спадає — добрий час для порядку й перепочинку';

  @override
  String get cheerWaning3 =>
      'Спадний Місяць сприяє відпочинку й завершенню справ';

  @override
  String get threeGood => 'Записати три добрі речі';

  @override
  String get threeGoodPrompt =>
      'Три добрі речі цього тижня — і що допомогло їм статися:';

  @override
  String moodReply(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      '1': 'Важкі дні трапляються. Сьогодні не треба нічого надолужувати.',
      '2': 'Слабший день — це теж нормально. Досить одного малого кроку.',
      '3': 'Звичайний день теж має значення.',
      '4': 'Приємно це чути.',
      'other': 'Чудово. Варто запам’ятати, що до цього привело.',
    });
    return '$_temp0';
  }

  @override
  String get reminderAsk => 'Хочеш, щоб карта дня чекала на тебе зранку?';

  @override
  String get reminderAskSub =>
      'Одне сповіщення на день о 8:00, зі змістом дня. Час можна змінити або вимкнути в Налаштуваннях.';

  @override
  String get reminderYes => 'Так, нагадуй';

  @override
  String get reminderNo => 'Ні, дякую';

  @override
  String get onboardBirthHint =>
      'Необов’язково. З датою одразу побачиш свій знак, гороскоп і числа.';

  @override
  String get lookBack => 'Твої дні';

  @override
  String get lookBackHint =>
      'Карти дня і настрій, день за днем. Збережено лише на цьому пристрої.';
}
