import 'dart:convert';

import 'package:flutter/foundation.dart' show FlutterError;
import 'package:flutter/services.dart';

import '../engine/lang.dart';
import '../engine/numerology.dart';

/// Bump when interpretation texts change; saved entries keep the version they were written with.
const contentVersion = 'pl-2026.11-1';

class TarotCard {
  final String id, name, arcana, symbolism, upright, reversed;
  final String advice, adviceReversed; // used as the reading's answer
  final String astrology;
  final String? suit;
  final int rank;
  final List<String> keywords, reflection;
  TarotCard.fromJson(Map<String, dynamic> j)
    : id = j['id'],
      name = j['name'],
      arcana = j['arcana'],
      suit = j['suit'],
      rank = j['rank'],
      keywords = List<String>.from(j['keywords']),
      symbolism = j['symbolism'],
      upright = j['upright'],
      reversed = j['reversed'],
      advice = j['advice'],
      adviceReversed = j['adviceReversed'],
      astrology = j['astrology'],
      reflection = List<String>.from(j['reflection']);

  String get group => arcana == 'major'
      ? tr(
          pl: 'Wielkie Arkana',
          en: 'Major Arcana',
          de: 'Große Arkana',
          fr: 'Arcanes majeurs',
          es: 'Arcanos mayores',
          uk: 'Старші аркани',
          it: 'Arcani maggiori',
          pt: 'Arcanos maiores',
          nl: 'Grote Arcana',
        )
      : '${tr(pl: 'Małe Arkana', en: 'Minor Arcana', de: 'Kleine Arkana', fr: 'Arcanes mineurs', es: 'Arcanos menores', uk: 'Молодші аркани', it: 'Arcani minori', pt: 'Arcanos menores', nl: 'Kleine Arcana')} · ${suitNames[suit]}';
  static Map<String, String> get suitNames => inLang(const {
    'pl': {
      'wands': 'Buławy',
      'cups': 'Kielichy',
      'swords': 'Miecze',
      'pentacles': 'Denary',
    },
    'en': {
      'wands': 'Wands',
      'cups': 'Cups',
      'swords': 'Swords',
      'pentacles': 'Pentacles',
    },
    'de': {
      'wands': 'Stäbe',
      'cups': 'Kelche',
      'swords': 'Schwerter',
      'pentacles': 'Münzen',
    },
    'fr': {
      'wands': 'Bâtons',
      'cups': 'Coupes',
      'swords': 'Épées',
      'pentacles': 'Deniers',
    },
    'es': {
      'wands': 'Bastos',
      'cups': 'Copas',
      'swords': 'Espadas',
      'pentacles': 'Oros',
    },
    'uk': {
      'wands': 'Жезли',
      'cups': 'Кубки',
      'swords': 'Мечі',
      'pentacles': 'Пентаклі',
    },
    'it': {
      'wands': 'Bastoni',
      'cups': 'Coppe',
      'swords': 'Spade',
      'pentacles': 'Denari',
    },
    'pt': {
      'wands': 'Paus',
      'cups': 'Copas',
      'swords': 'Espadas',
      'pentacles': 'Ouros',
    },
    'nl': {
      'wands': 'Staven',
      'cups': 'Bekers',
      'swords': 'Zwaarden',
      'pentacles': 'Pentakels',
    },
  });
}

class Interpretation {
  final String title, text, reflection;
  Interpretation.fromJson(Map<String, dynamic> j)
    : title = j['title'],
      text = j['text'],
      reflection = j['reflection'];
}

class Archetype {
  final String id, name, summary, gifts, shadow;
  final List<String> reflection;
  Archetype.fromJson(Map<String, dynamic> j)
    : id = j['id'],
      name = j['name'],
      summary = j['summary'],
      gifts = j['gifts'],
      shadow = j['shadow'],
      reflection = List<String>.from(j['reflection']);
}

class Prompt {
  final String id, category, text;
  Prompt.fromJson(Map<String, dynamic> j)
    : id = j['id'],
      category = j['category'],
      text = j['text'];
}

class Term {
  final String term, definition;
  Term.fromJson(Map<String, dynamic> j)
    : term = j['term'],
      definition = j['definition'];
}

class Article {
  final String id, title, body;
  Article.fromJson(Map<String, dynamic> j)
    : id = j['id'],
      title = j['title'],
      body = j['body'];
}

typedef Named = ({String name, String text});

class Sign {
  final String id, name, locative, dates, text;
  final String color, stone, day, planet, love, work, wellbeing;
  Sign.fromJson(Map<String, dynamic> j)
    : love = j['love'],
      work = j['work'],
      wellbeing = j['wellbeing'],
      color = j['color'],
      stone = j['stone'],
      day = j['day'],
      planet = j['planet'],
      id = j['id'],
      name = j['name'],
      locative = j['locative'],
      dates = j['dates'],
      text = j['text'];
}

/// Texts for the daily horoscope, moon and compatibility; indexes follow engine/astro.dart.
class Astro {
  final Map<String, String> elements, compat, yearForecast, chineseCompat;
  final Map<String, String> haircut, week, eclipseText;
  final List<Sign> signs;
  final List<
    ({String name, String text, String long, String love, String work})
  >
  chinese;
  final List<Named> phases;
  final List<String> moonSigns, ascSigns;
  final Map<String, ({String name, String adj, String text})> elements5;
  final Map<String, Named> dayTypes;
  final String mercury;
  final Map<String, String> transits;
  final Map<String, ({String title, String text, List<String> prompts})>
  rituals;
  final Map<String, List<String>> today;
  final Map<int, String> caution;
  Astro.fromJson(Map<String, dynamic> j)
    : elements = Map<String, String>.from(j['elements']),
      compat = Map<String, String>.from(j['compat']),
      yearForecast = Map<String, String>.from(j['yearForecast']),
      chineseCompat = Map<String, String>.from(j['chineseCompat']),
      haircut = Map<String, String>.from(j['haircut']),
      week = Map<String, String>.from(j['week']),
      eclipseText = Map<String, String>.from(j['eclipseText']),
      moonSigns = List<String>.from(j['moonSigns']),
      ascSigns = List<String>.from(j['ascSigns']),
      mercury = j['mercury'],
      transits = Map<String, String>.from(j['transits']),
      rituals = {
        for (final e in (j['rituals'] as Map<String, dynamic>).entries)
          e.key: (
            title: e.value['title'] as String,
            text: e.value['text'] as String,
            prompts: List<String>.from(e.value['prompts']),
          ),
      },
      elements5 = {
        for (final e in (j['elements5'] as Map<String, dynamic>).entries)
          e.key: (
            name: e.value['name'] as String,
            adj: e.value['adj'] as String,
            text: e.value['text'] as String,
          ),
      },
      dayTypes = {
        for (final e in (j['dayTypes'] as Map<String, dynamic>).entries)
          e.key: (
            name: e.value['name'] as String,
            text: e.value['text'] as String,
          ),
      },
      signs = [for (final e in j['signs']) Sign.fromJson(e)],
      chinese = [
        for (final e in j['chinese'])
          (
            name: e['name'],
            text: e['text'],
            long: e['long'],
            love: e['love'],
            work: e['work'],
          ),
      ],
      phases = [
        for (final e in j['phases']) (name: e['name'], text: e['text']),
      ],
      today = {
        for (final e in (j['today'] as Map<String, dynamic>).entries)
          e.key: List<String>.from(e.value),
      },
      caution = {
        for (final e in (j['caution'] as Map<String, dynamic>).entries)
          int.parse(e.key): e.value as String,
      };
}

class Dream {
  final String symbol, meaning, reflection;
  Dream.fromJson(Map<String, dynamic> j)
    : symbol = j['symbol'],
      meaning = j['meaning'],
      reflection = j['reflection'];
}

class NumerologyExtra {
  final Map<int, ({String title, List<String> levels})> square;
  final Map<int, Named> pinnacles, challenges, karmicDebts;
  final Map<int, String> karmicLessons, keywords, dayColors;
  NumerologyExtra.fromJson(Map<String, dynamic> j)
    : karmicDebts = _named(j['karmicDebts']),
      karmicLessons = _ints(j['karmicLessons']),
      keywords = _ints(j['keywords']),
      dayColors = _ints(j['dayColors']),
      square = {
        for (final e in (j['square'] as Map<String, dynamic>).entries)
          int.parse(e.key): (
            title: e.value['title'] as String,
            levels: List<String>.from(e.value['levels']),
          ),
      },
      pinnacles = _named(j['pinnacles']),
      challenges = _named(j['challenges']);

  static Map<int, String> _ints(Map<String, dynamic> m) => {
    for (final e in m.entries) int.parse(e.key): e.value as String,
  };

  static Map<int, Named> _named(Map<String, dynamic> m) => {
    for (final e in m.entries)
      int.parse(e.key): (
        name: e.value['title'] as String,
        text: e.value['text'] as String,
      ),
  };
}

class Hexagram {
  final int n;
  final String name, text, advice;
  final List<String> lines; // bottom → top
  Hexagram.fromJson(Map<String, dynamic> j)
    : lines = List<String>.from(j['lines']),
      n = j['n'],
      name = j['name'],
      text = j['text'],
      advice = j['advice'];
}

/// All bundled, offline content.
class Content {
  final Map<String, TarotCard> cards; // ordered as in the deck
  final Map<Indicator, Map<int, Interpretation>> numerology;
  final List<Archetype> archetypes;
  final List<Prompt> prompts;
  final List<Term> glossary;
  final List<Article> articles;
  final Astro astro;
  final List<Dream> dreams;
  final NumerologyExtra numerologyExtra;
  final Map<int, Hexagram> iching;

  /// Texts of the personal daily reading; null in a language that does not have them
  /// yet (the app then shows the older, shorter horoscope).
  final Daily? daily;

  /// Kind words for everyone, one per day of the month; unrelated to the day's reading.
  final List<String> messages;
  Content._(
    this.cards,
    this.numerology,
    this.archetypes,
    this.prompts,
    this.glossary,
    this.articles,
    this.astro,
    this.dreams,
    this.numerologyExtra,
    this.iching,
    this.daily,
    this.messages,
  );

  Interpretation? interpretation(Indicator i, int? v) =>
      v == null ? null : numerology[i]?[v];

  /// Polish lives in assets/content, other languages in `assets/content/<lang>`,
  /// with the same files, ids and structure.
  static Future<Content> load({String lang = 'pl', AssetBundle? bundle}) async {
    final b = bundle ?? rootBundle;
    final dir = lang == 'pl' ? 'assets/content' : 'assets/content/$lang';
    Future<dynamic> j(String f) async =>
        jsonDecode(await b.loadString('$dir/$f'));
    final cards = [
      ...await j('tarot_part_a.json'),
      ...await j('tarot_part_b.json'),
    ].map((e) => TarotCard.fromJson(e)).toList();
    final num = (await j('numerology.json')) as Map<String, dynamic>;
    return Content._(
      {for (final c in cards) c.id: c},
      {
        for (final i in Indicator.values)
          i: {
            for (final e in (num[i.name] as Map<String, dynamic>).entries)
              int.parse(e.key): Interpretation.fromJson(e.value),
          },
      },
      [for (final e in await j('archetypes.json')) Archetype.fromJson(e)],
      [for (final e in await j('journal_prompts.json')) Prompt.fromJson(e)],
      [for (final e in await j('glossary.json')) Term.fromJson(e)],
      [for (final e in await j('articles.json')) Article.fromJson(e)],
      Astro.fromJson(await j('astro.json')),
      [for (final e in await j('dreams.json')) Dream.fromJson(e)],
      NumerologyExtra.fromJson(await j('numerology_extra.json')),
      {
        for (final e in await j('iching.json'))
          e['n'] as int: Hexagram.fromJson(e),
      },
      await _daily(b, '$dir/daily.json'),
      List<String>.from(await j('messages.json')),
    );
  }

  static Future<Daily?> _daily(AssetBundle b, String path) async {
    final String text;
    try {
      text = await b.loadString(path);
    } on FlutterError {
      return null; // not translated into this language yet
    }
    return Daily.fromJson(jsonDecode(text));
  }
}

/// Personal daily reading: mood by Moon sign and element relation (two variants each),
/// what the day may bring and advice by personal day number, three areas by meter level.
class Daily {
  final Map<String, Map<String, List<String>>> mood;
  final Map<int, List<String>> events, advice;
  final Map<String, List<String>> love, work, energy;
  final String birthday;
  Daily.fromJson(Map<String, dynamic> j)
    : mood = {
        for (final s in (j['mood'] as Map<String, dynamic>).entries)
          s.key: _lists(s.value),
      },
      events = _byNumber(j['events']),
      advice = _byNumber(j['advice']),
      love = _lists(j['love']),
      work = _lists(j['work']),
      energy = _lists(j['energy']),
      birthday = j['birthday'];
  static Map<String, List<String>> _lists(Map<String, dynamic> m) => {
    for (final e in m.entries) e.key: List<String>.from(e.value),
  };
  static Map<int, List<String>> _byNumber(Map<String, dynamic> m) => {
    for (final e in m.entries) int.parse(e.key): List<String>.from(e.value),
  };
}
