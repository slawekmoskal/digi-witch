import 'dart:convert';

import 'package:flutter/services.dart';

import '../engine/numerology.dart';

/// Bump when interpretation texts change; saved entries keep the version they were written with.
const contentVersion = 'pl-2026.11-1';

class TarotCard {
  final String id, name, arcana, symbolism, upright, reversed;
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
        reflection = List<String>.from(j['reflection']);

  String get group => arcana == 'major' ? 'Wielkie Arkana' : 'Małe Arkana · ${suitNames[suit]}';
  static const suitNames = {'wands': 'Buławy', 'cups': 'Kielichy', 'swords': 'Miecze', 'pentacles': 'Denary'};
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

/// All bundled, offline content.
class Content {
  final Map<String, TarotCard> cards; // ordered as in the deck
  final Map<Indicator, Map<int, Interpretation>> numerology;
  final List<Archetype> archetypes;
  final List<Prompt> prompts;
  final List<Term> glossary;
  final List<Article> articles;
  Content._(this.cards, this.numerology, this.archetypes, this.prompts, this.glossary, this.articles);

  Interpretation? interpretation(Indicator i, int? v) => v == null ? null : numerology[i]?[v];

  static Future<Content> load([AssetBundle? bundle]) async {
    final b = bundle ?? rootBundle;
    Future<dynamic> j(String f) async => jsonDecode(await b.loadString('assets/content/$f'));
    final cards = [...await j('tarot_part_a.json'), ...await j('tarot_part_b.json')]
        .map((e) => TarotCard.fromJson(e))
        .toList();
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
    );
  }
}
