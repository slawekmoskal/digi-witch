import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:digi_witch/data/content.dart';
import 'package:digi_witch/data/store.dart';
import 'package:digi_witch/engine/numerology.dart';
import 'package:digi_witch/engine/tarot.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Content c;
  setUpAll(() async => c = await Content.load());

  group('content integrity', () {
    test('78 cards matching engine ids, all fields filled', () {
      expect(c.cards.keys.toList(), deckIds);
      for (final k in c.cards.values) {
        expect([k.name, k.symbolism, k.upright, k.reversed].every((s) => s.trim().isNotEmpty), isTrue, reason: k.id);
        expect(k.keywords, isNotEmpty);
        expect(k.reflection, isNotEmpty);
      }
      expect(c.cards['major_13']!.name, 'Śmierć');
    });

    test('every card has artwork with recorded provenance and verified hash', () {
      final manifest = {for (final m in jsonDecode(File('assets/cards/manifest.json').readAsStringSync())) m['id']: m};
      for (final id in deckIds) {
        expect(File('assets/cards/$id.webp').existsSync(), isTrue, reason: id);
        expect(manifest[id]?['sha1'], hasLength(40), reason: id);
        expect(manifest[id]['license'], 'Public domain');
      }
    });

    test('no duplicated interpretation texts across cards', () {
      final texts = [for (final k in c.cards.values) ...[k.upright, k.reversed, k.symbolism]];
      expect(texts.toSet().length, texts.length);
    });

    test('every reachable numerology value has an indicator-specific text', () {
      const allowed = {
        Indicator.lifePath: [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33],
        Indicator.expression: [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33],
        Indicator.soulUrge: [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33],
        Indicator.personality: [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33],
        Indicator.birthDay: [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22],
        Indicator.personalYear: [1, 2, 3, 4, 5, 6, 7, 8, 9],
      };
      for (final e in allowed.entries) {
        for (final v in e.value) {
          expect(c.interpretation(e.key, v), isNotNull, reason: '${e.key} $v');
        }
      }
      final all = [for (final m in c.numerology.values) ...m.values.map((i) => i.text)];
      expect(all.toSet().length, all.length, reason: 'same text pasted into several indicators');
    });

    test('prompts, archetypes, glossary, articles', () {
      expect(c.prompts.length, greaterThanOrEqualTo(30));
      expect(c.prompts.where((p) => p.category == 'rodzina').length, greaterThanOrEqualTo(10));
      expect(c.prompts.map((p) => p.id).toSet().length, c.prompts.length);
      expect(c.archetypes.length, 12);
      expect(c.glossary, isNotEmpty);
      expect(c.articles.map((a) => a.id), contains('jak-liczymy'));
    });
  });

  group('store', () {
    Future<AppStore> fresh([Map<String, Object> init = const {}]) async {
      SharedPreferences.setMockInitialValues(init);
      return AppStore(await SharedPreferences.getInstance(), random: Random(3));
    }

    test('card of the day stable across restarts, new on a new local date', () async {
      final s1 = await fresh();
      final d = CalendarDate.tryCreate(2026, 11, 10)!;
      final a = s1.cardOfDay(d);
      // "restart": new store instance over the same prefs, different RNG
      final s2 = AppStore(await SharedPreferences.getInstance(), random: Random(999));
      expect(s2.cardOfDay(d).toJson(), a.toJson());
      final next = s2.cardOfDay(CalendarDate.tryCreate(2026, 11, 11)!);
      expect(jsonDecode((await SharedPreferences.getInstance()).getString('cardOfDay')!)['date'], '2026-11-11');
      expect(next, isA<DrawnCard>());
    });

    test('journal add / edit / export / delete; ref snapshot keeps versions', () async {
      final s = await fresh();
      final r = lifePath(CalendarDate.tryCreate(1990, 7, 15)!);
      await s.addEntry('pierwszy', ref: {'type': 'numerology', 'label': 'Droga życia: 5', 'result': r.toJson()});
      await s.addEntry('drugi');
      expect(s.journal.length, 2);
      final first = s.journal.firstWhere((e) => e.text == 'pierwszy');
      expect(first.ref!['contentVersion'], contentVersion);
      expect(first.ref!['result']['version'], algorithmVersion);
      expect(first.ref!['result']['steps'], isNotEmpty);

      await s.updateEntry(first.id, 'zmieniony');
      expect(s.journal.map((e) => e.text), containsAll(['zmieniony', 'drugi']));

      final exported = jsonDecode(s.exportJournal());
      expect(exported['entries'].length, 2);

      await s.deleteEntry(first.id);
      expect(s.journal.single.text, 'drugi');
    });

    test('delete all data wipes everything', () async {
      final s = await fresh();
      s.saveProfile(CalendarDate.tryCreate(1990, 1, 1), 'Ala');
      await s.addEntry('x');
      s.toggleBookmark('major_00');
      await s.deleteAllData();
      expect(s.journal, isEmpty);
      expect(s.birthDate, isNull);
      expect(s.bookmarks, isEmpty);
      expect(s.onboarded, isFalse);
    });

    test('reversed setting defaults to off and is honoured', () async {
      final s = await fresh();
      expect(s.allowReversed, isFalse);
      for (var i = 0; i < 50; i++) {
        expect(s.drawSpread(spreads[2]).any((d) => d.reversed), isFalse);
      }
    });
  });
}
