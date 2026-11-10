import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../engine/numerology.dart';
import '../engine/tarot.dart';
import 'content.dart';

/// Optional link from a journal entry to a result. [snapshot] freezes the result as shown
/// (incl. algorithm/content versions) so later updates never silently rewrite old entries.
class JournalEntry {
  final String id;
  final DateTime createdAt;
  final String text;
  final String? promptText;
  final Map<String, dynamic>? ref;
  const JournalEntry({required this.id, required this.createdAt, required this.text, this.promptText, this.ref});

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'text': text,
        'promptText': promptText,
        'ref': ref,
      };
  factory JournalEntry.fromJson(Map<String, dynamic> j) => JournalEntry(
        id: j['id'],
        createdAt: DateTime.parse(j['createdAt']),
        text: j['text'],
        promptText: j['promptText'],
        ref: (j['ref'] as Map?)?.cast<String, dynamic>(),
      );
}

/// Local-only persistence. Nothing here leaves the device except via user-initiated export.
class AppStore extends ChangeNotifier {
  final SharedPreferences _p;
  final Random _random;
  AppStore(this._p, {Random? random}) : _random = random ?? Random.secure();

  static Future<AppStore> open() async => AppStore(await SharedPreferences.getInstance());

  // ---- settings ----
  bool get onboarded => _p.getBool('onboarded') ?? false;
  set onboarded(bool v) => _set(() => _p.setBool('onboarded', v));

  bool get allowReversed => _p.getBool('allowReversed') ?? false;
  set allowReversed(bool v) => _set(() => _p.setBool('allowReversed', v));

  String get themeMode => _p.getString('themeMode') ?? 'system';
  set themeMode(String v) => _set(() => _p.setString('themeMode', v));

  /// Optional saved profile; one-off calculations don't touch it.
  CalendarDate? get birthDate => CalendarDate.tryParse(_p.getString('birthDate') ?? '');
  String? get fullName => _p.getString('fullName');
  void saveProfile(CalendarDate? d, String? name) => _set(() async {
        d == null ? await _p.remove('birthDate') : await _p.setString('birthDate', d.iso);
        (name == null || name.isEmpty) ? await _p.remove('fullName') : await _p.setString('fullName', name);
      });

  // ---- card of the day ----
  /// Keyed by the device's local calendar date at the moment of asking. Same day → same card
  /// across restarts. A new local date (midnight or travel to another zone) → a new card.
  DrawnCard cardOfDay(CalendarDate today) {
    final raw = _p.getString('cardOfDay');
    if (raw != null) {
      final j = jsonDecode(raw);
      if (j['date'] == today.iso) return DrawnCard.fromJson(j['card']);
    }
    final card = draw(spreads[0], random: _random, allowReversed: allowReversed).single;
    _p.setString('cardOfDay', jsonEncode({'date': today.iso, 'card': card.toJson()}));
    return card;
  }

  List<DrawnCard> drawSpread(Spread s) => draw(s, random: _random, allowReversed: allowReversed);

  // ---- bookmarks ----
  Set<String> get bookmarks => (_p.getStringList('bookmarks') ?? []).toSet();
  void toggleBookmark(String id) {
    final b = bookmarks;
    b.contains(id) ? b.remove(id) : b.add(id);
    _set(() => _p.setStringList('bookmarks', b.toList()));
  }

  // ---- journal ----
  // shortcut: whole journal is one JSON string in prefs; fine for hundreds of entries, move to a file/DB beyond that.
  List<JournalEntry> get journal {
    final raw = _p.getString('journal');
    if (raw == null) return [];
    return [for (final e in jsonDecode(raw)) JournalEntry.fromJson(e)]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> _saveJournal(List<JournalEntry> l) async {
    final ok = await _p.setString('journal', jsonEncode([for (final e in l) e.toJson()]));
    if (!ok) throw StateError('Nie udało się zapisać dziennika');
    notifyListeners();
  }

  Future<void> addEntry(String text, {String? promptText, Map<String, dynamic>? ref}) => _saveJournal([
        JournalEntry(
          id: '${DateTime.now().microsecondsSinceEpoch}',
          createdAt: DateTime.now(),
          text: text,
          promptText: promptText,
          ref: ref == null ? null : {...ref, 'contentVersion': contentVersion},
        ),
        ...journal,
      ]);

  Future<void> updateEntry(String id, String text) => _saveJournal([
        for (final e in journal)
          e.id == id ? JournalEntry(id: e.id, createdAt: e.createdAt, text: text, promptText: e.promptText, ref: e.ref) : e,
      ]);

  Future<void> deleteEntry(String id) => _saveJournal(journal.where((e) => e.id != id).toList());

  String exportJournal() => const JsonEncoder.withIndent('  ').convert({
        'app': 'digi_witch',
        'exportedAt': DateTime.now().toIso8601String(),
        'entries': [for (final e in journal) e.toJson()],
      });

  /// Removes every locally stored item (journal, profile, card of the day, settings).
  Future<void> deleteAllData() async {
    await _p.clear();
    notifyListeners();
  }

  Future<void> _set(Future<void> Function() f) async {
    await f();
    notifyListeners();
  }
}
