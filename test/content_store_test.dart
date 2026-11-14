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
        expect(
          [
            k.name,
            k.symbolism,
            k.upright,
            k.reversed,
            k.advice,
            k.adviceReversed,
          ].every((s) => s.trim().isNotEmpty),
          isTrue,
          reason: k.id,
        );
        expect(k.keywords, isNotEmpty);
        expect(k.reflection, isNotEmpty);
      }
      expect(c.cards['major_13']!.name, 'Śmierć');
    });

    test(
      'every card has artwork with recorded provenance and verified hash',
      () {
        final manifest = {
          for (final m in jsonDecode(
            File('assets/cards/manifest.json').readAsStringSync(),
          ))
            m['id']: m,
        };
        for (final id in deckIds) {
          expect(
            File('assets/cards/$id.webp').existsSync(),
            isTrue,
            reason: id,
          );
          expect(manifest[id]?['sha1'], hasLength(40), reason: id);
          expect(manifest[id]['license'], 'Public domain');
        }
      },
    );

    test('no duplicated interpretation texts across cards', () {
      final texts = [
        for (final k in c.cards.values) ...[k.upright, k.reversed, k.symbolism],
      ];
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
      final all = [
        for (final m in c.numerology.values) ...m.values.map((i) => i.text),
      ];
      expect(
        all.toSet().length,
        all.length,
        reason: 'same text pasted into several indicators',
      );
    });

    test('prompts, archetypes, glossary, articles', () {
      expect(c.prompts.length, greaterThanOrEqualTo(30));
      expect(
        c.prompts.where((p) => p.category == 'rodzina').length,
        greaterThanOrEqualTo(10),
      );
      expect(c.prompts.map((p) => p.id).toSet().length, c.prompts.length);
      expect(c.archetypes.length, 12);
      expect(c.glossary, isNotEmpty);
      expect(c.articles.map((a) => a.id), contains('jak-liczymy'));
    });

    test('astro and dream content complete', () {
      final a = c.astro;
      expect(a.signs.length, 12);
      expect(a.moonSigns.length, 12);
      expect(a.ascSigns.length, 12);
      expect(a.chinese.every((x) => x.long.isNotEmpty), isTrue);
      expect(a.chinese.length, 12);
      expect(a.elements5.keys.toSet(), {
        'wood',
        'fire',
        'earth',
        'metal',
        'water',
      });
      for (final k in ['same', 'friend', 'trine', 'clash', 'neutral']) {
        expect(a.yearForecast[k], isNotNull, reason: k);
        expect(a.chineseCompat[k], isNotNull, reason: k);
      }
      expect(a.dayTypes.keys.toSet(), {'fire', 'earth', 'air', 'water'});
      expect(c.dreams.length, greaterThan(100));
      expect(c.dreams.map((d) => d.symbol).toSet().length, c.dreams.length);
    });

    test('numerology extras, I Ching, transits and rituals complete', () {
      final x = c.numerologyExtra;
      expect(x.square.keys.toSet(), {for (var i = 1; i <= 9; i++) i});
      expect(x.square.values.every((v) => v.levels.length == 5), isTrue);
      expect(
        c.astro.signs.every(
          (s) =>
              s.love.isNotEmpty && s.work.isNotEmpty && s.wellbeing.isNotEmpty,
        ),
        isTrue,
      );
      expect(
        c.astro.chinese.every((s) => s.love.isNotEmpty && s.work.isNotEmpty),
        isTrue,
      );
      expect(x.pinnacles.keys.toSet(), {for (var i = 1; i <= 9; i++) i});
      expect(x.challenges.keys.toSet(), {for (var i = 0; i <= 8; i++) i});
      expect(c.iching.keys.toSet(), {for (var i = 1; i <= 64; i++) i});
      expect(c.iching.values.every((h) => h.lines.length == 6), isTrue);
      expect(c.astro.transits.length, 6);
      expect(c.astro.rituals.keys.toSet(), {'new', 'full'});
      expect(x.karmicDebts.keys.toSet(), {13, 14, 16, 19});
      expect(x.karmicLessons.length, 9);
      expect(x.keywords.length, 9);
      expect(x.dayColors.length, 9);
      expect(
        c.astro.signs.every((s) => s.stone.isNotEmpty && s.planet.isNotEmpty),
        isTrue,
      );
      for (final i in [Indicator.personalMonth, Indicator.house]) {
        expect(c.numerology[i]!.keys.toSet(), {
          for (var k = 1; k <= 9; k++) k,
        }, reason: i.name);
      }
      expect(c.numerology[Indicator.maturity]!.keys.toSet(), {
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        11,
        22,
        33,
      });
    });
  });

  group('store', () {
    Future<AppStore> fresh([Map<String, Object> init = const {}]) async {
      SharedPreferences.setMockInitialValues(init);
      return AppStore(await SharedPreferences.getInstance(), random: Random(3));
    }

    test(
      'card of the day stable across restarts, new on a new local date',
      () async {
        final s1 = await fresh();
        final d = CalendarDate.tryCreate(2026, 11, 10)!;
        final a = s1.cardOfDay(d);
        // "restart": new store instance over the same prefs, different RNG
        final s2 = AppStore(
          await SharedPreferences.getInstance(),
          random: Random(999),
        );
        expect(s2.cardOfDay(d).toJson(), a.toJson());
        final next = s2.cardOfDay(CalendarDate.tryCreate(2026, 11, 11)!);
        expect(
          jsonDecode(
            (await SharedPreferences.getInstance()).getString('cardOfDay')!,
          )['date'],
          '2026-11-11',
        );
        expect(next, isA<DrawnCard>());
      },
    );

    test(
      'journal add / edit / export / delete; ref snapshot keeps versions',
      () async {
        final s = await fresh();
        final r = lifePath(CalendarDate.tryCreate(1990, 7, 15)!);
        await s.addEntry(
          'pierwszy',
          ref: {
            'type': 'numerology',
            'label': 'Droga życia: 5',
            'result': r.toJson(),
          },
        );
        await s.addEntry('drugi');
        expect(s.journal.length, 2);
        final first = s.journal.firstWhere((e) => e.text == 'pierwszy');
        expect(first.ref!['contentVersion'], contentVersion);
        expect(first.ref!['result']['version'], algorithmVersion);
        expect(first.ref!['result']['steps'], isNotEmpty);

        await s.updateEntry(first.id, 'zmieniony');
        expect(
          s.journal.map((e) => e.text),
          containsAll(['zmieniony', 'drugi']),
        );

        final exported = jsonDecode(s.exportJournal());
        expect(exported['entries'].length, 2);

        await s.deleteEntry(first.id);
        expect(s.journal.single.text, 'drugi');
      },
    );

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

    test('delete all keeps the Pro purchase', () async {
      final s = await fresh();
      s.isPro = true;
      await s.addEntry('x');
      await s.deleteAllData();
      expect(s.isPro, isTrue);
      expect(s.journal, isEmpty);
    });

    test('delete all stopped halfway keeps Pro and the widget-clear flag, then can finish', () async {
      for (final fail in [Object(), false]) {
        SharedPreferences.setMockInitialValues({});
        final prefs = _FlakyPrefs(await SharedPreferences.getInstance());
        final s = AppStore(prefs);
        s.isPro = true;
        s.saveProfile(CalendarDate.tryCreate(1990, 1, 1), 'Ala');
        await s.addEntry('x');
        prefs.failRemove = fail; // storage throws, or answers false
        expect(await s.deleteAllData(), DeleteAllResult.partial);
        expect(
          s.widgetClearPending,
          isTrue,
        ); // the next start empties the widgets
        expect(s.isPro, isTrue);

        prefs.failRemove = null; // a second try finishes the wipe
        expect(await s.deleteAllData(), DeleteAllResult.done);
        expect(s.journal, isEmpty);
        expect(s.birthDate, isNull);
        expect(s.isPro, isTrue);
        expect(s.widgetClearPending, isTrue);
      }
    });

    test('delete all refused before it starts removes nothing', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = _FlakyPrefs(await SharedPreferences.getInstance());
      final s = AppStore(prefs);
      await s.addEntry('x');
      prefs.failFlag = true;
      var cancelled = false;
      expect(
        await s.deleteAllData(cancelReminders: () async => cancelled = true),
        DeleteAllResult.notStarted,
      );
      expect(cancelled, isFalse); // nothing cancelled, nothing removed
      expect(s.journal, hasLength(1));
    });

    test('corrupt journal JSON is quarantined, exported, and does not block new entries', () async {
      final s = await fresh({
        'journal': '[{"id":"1","createdAt":"2026-01-01T10:00:00.000"',
      });
      expect(s.journal, isEmpty);
      await s.addEntry('nowy');
      expect(s.journal.single.text, 'nowy');
      final exported = jsonDecode(s.exportJournal());
      expect(exported['unreadable'], isNotEmpty);
    });

    test(
      'one bad entry is set aside, good ones stay readable and editable',
      () async {
        final good = {
          'id': 'a',
          'createdAt': '2026-01-01T10:00:00.000',
          'text': 'ok',
        };
        final s = await fresh({
          'journal': jsonEncode([
            good,
            {'id': 'b', 'text': null},
          ]),
        });
        expect(s.journal.single.text, 'ok');
        await s.updateEntry('a', 'zmienione');
        expect(s.journal.single.text, 'zmienione');
        expect(s.unreadableJournalData.single, contains('"b"'));
      },
    );

    test(
      'corrupt or unknown card of the day is redrawn instead of crashing',
      () async {
        final today = CalendarDate.tryCreate(2026, 11, 10)!;
        for (final bad in [
          '{oops',
          jsonEncode({
            'date': today.iso,
            'card': {'cardId': 'nope_99', 'position': 'x', 'reversed': false},
          }),
        ]) {
          final s = await fresh({'cardOfDay': bad});
          expect(deckIds, contains(s.cardOfDay(today).cardId));
        }
      },
    );

    test('entry ids are unique even when added in the same instant', () async {
      final s = await fresh();
      await Future.wait([s.addEntry('a'), s.addEntry('b')]);
      expect(s.journal.map((e) => e.id).toSet().length, s.journal.length);
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

/// Real preferences whose writes can be made to fail: [failRemove] (an exception to throw,
/// or false to answer) hits the second removal, [failFlag] refuses the reset flag.
class _FlakyPrefs implements SharedPreferences {
  _FlakyPrefs(this._p);
  final SharedPreferences _p;
  Object? failRemove;
  bool failFlag = false;
  var _removes = 0;

  @override
  Future<bool> remove(String key) async {
    if (failRemove != null && ++_removes == 2) {
      _removes = 0;
      if (failRemove == false) return false;
      throw failRemove!;
    }
    return _p.remove(key);
  }

  @override
  Future<bool> setBool(String key, bool value) async =>
      failFlag && key == 'widgetClearPending' ? false : _p.setBool(key, value);

  @override
  Set<String> getKeys() => _p.getKeys();
  @override
  Object? get(String key) => _p.get(key);
  @override
  bool? getBool(String key) => _p.getBool(key);
  @override
  int? getInt(String key) => _p.getInt(key);
  @override
  String? getString(String key) => _p.getString(key);
  @override
  List<String>? getStringList(String key) => _p.getStringList(key);
  @override
  Future<bool> setInt(String key, int value) => _p.setInt(key, value);
  @override
  Future<bool> setString(String key, String value) => _p.setString(key, value);
  @override
  Future<bool> setStringList(String key, List<String> value) =>
      _p.setStringList(key, value);
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}
