import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../engine/lang.dart';
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
  const JournalEntry({
    required this.id,
    required this.createdAt,
    required this.text,
    this.promptText,
    this.ref,
  });

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
enum DeleteAllResult { done, notStarted, partial }

class AppStore extends ChangeNotifier {
  final SharedPreferences _p;
  final Random _random;
  AppStore(this._p, {Random? random}) : _random = random ?? Random.secure();

  static Future<AppStore> open() async =>
      AppStore(await SharedPreferences.getInstance());

  // ---- settings ----
  bool get onboarded => _p.getBool('onboarded') ?? false;
  set onboarded(bool v) => _set(() => _p.setBool('onboarded', v));

  // Test builds for the owner (--dart-define=DEMO_PRO=true) behave as Pro: no ads, no consent form.
  bool get isPro =>
      const bool.fromEnvironment('DEMO_PRO') || (_p.getBool('isPro') ?? false);
  set isPro(bool v) => _set(() => _p.setBool('isPro', v));

  /// A reset wiped the data but the home-screen widgets may still show it; retried at every start.
  bool get widgetClearPending => _p.getBool('widgetClearPending') ?? false;
  Future<void> setWidgetClearDone() => _p.remove('widgetClearPending');

  /// Daily reminder time in minutes after midnight; null = off (default).
  bool get moonReminders => _p.getBool('moonReminders') ?? false;
  set moonReminders(bool v) => _set(() => _p.setBool('moonReminders', v));

  int? get reminderMinutes => _p.getInt('reminderMinutes');
  set reminderMinutes(int? v) => _set(
    () => v == null
        ? _p.remove('reminderMinutes')
        : _p.setInt('reminderMinutes', v),
  );

  /// The one-time offer of a morning reminder was answered (either way).
  bool get reminderAsked => _p.getBool('reminderAsked') ?? false;
  set reminderAsked(bool v) => _set(() => _p.setBool('reminderAsked', v));

  bool get tarotWelcome => _p.getBool('tarotWelcome') ?? true;
  set tarotWelcome(bool v) => _set(() => _p.setBool('tarotWelcome', v));
  bool get allowReversed => _p.getBool('allowReversed') ?? false;
  set allowReversed(bool v) => _set(() => _p.setBool('allowReversed', v));

  /// 'system' (follow the phone) or a language code from [appLangs].
  String get language => _p.getString('language') ?? 'system';
  set language(String v) => _set(() => _p.setString('language', v));

  String get themeMode => _p.getString('themeMode') ?? 'system';
  set themeMode(String v) => _set(() => _p.setString('themeMode', v));

  /// Optional saved profile; one-off calculations don't touch it.
  CalendarDate? get birthDate =>
      CalendarDate.tryParse(_p.getString('birthDate') ?? '');
  String? get fullName => _p.getString('fullName');
  void saveProfile(CalendarDate? d, String? name) => _set(() async {
    d == null
        ? await _p.remove('birthDate')
        : await _p.setString('birthDate', d.iso);
    (name == null || name.isEmpty)
        ? await _p.remove('fullName')
        : await _p.setString('fullName', name);
    if (d == null) {
      // Time and place only make sense with a birth date.
      await _p.remove('birthMinutes');
      await _p.remove('birthPlace');
    }
  });

  /// Optional birth time (minutes after local midnight) and place (city name), for the Moon and ascendant.
  int? get birthMinutes => _p.getInt('birthMinutes');
  String? get birthPlace => _p.getString('birthPlace');
  void saveBirthDetails(int? minutes, String? place) => _set(() async {
    minutes == null
        ? await _p.remove('birthMinutes')
        : await _p.setInt('birthMinutes', minutes);
    place == null
        ? await _p.remove('birthPlace')
        : await _p.setString('birthPlace', place);
  });

  // ---- card of the day ----
  /// Keyed by the device's local calendar date at the moment of asking. Same day → same card
  /// across restarts. A new local date (midnight or travel to another zone) → a new card.
  DrawnCard cardOfDay(CalendarDate today) {
    final raw = _p.getString('cardOfDay');
    if (raw != null) {
      try {
        final j = jsonDecode(raw);
        final c = DrawnCard.fromJson(j['card']);
        if (j['date'] == today.iso && deckIds.contains(c.cardId)) return c;
      } catch (_) {
        // Corrupt or outdated value: draw a fresh card instead of breaking the Today screen.
      }
    }
    final card = draw(
      spreads[0],
      random: _random,
      allowReversed: allowReversed,
    ).single;
    _p.setString(
      'cardOfDay',
      jsonEncode({'date': today.iso, 'card': card.toJson()}),
    );
    return card;
  }

  /// Whether today's card was already turned face up (the daily tap-to-reveal).
  bool cardRevealed(CalendarDate today) =>
      _p.getString('cardRevealed') == today.iso;
  void revealCard(CalendarDate today) => _set(() async {
    await _p.setString('cardRevealed', today.iso);
    final log = {
      for (final e in cardLog.entries) e.key: e.value.toJson(),
      today.iso: cardOfDay(today).toJson(),
    };
    // shortcut: keeps about a year of days; raise when a longer look-back is wanted.
    if (log.length > 400) log.remove(log.keys.first);
    await _p.setString('cardLog', jsonEncode(log));
  });

  /// The cards of the day that were turned, by ISO date, oldest first ("Your days").
  Map<String, DrawnCard> get cardLog {
    try {
      return {
        for (final e
            in (jsonDecode(_p.getString('cardLog') ?? '{}') as Map).entries)
          if (DrawnCard.fromJson(e.value) case final c
              when deckIds.contains(c.cardId))
            e.key as String: c,
      };
    } catch (_) {
      return {}; // a corrupt value must not break Today
    }
  }

  // ---- mood check-in ----
  /// Mood per day, 1 (bad) … 5 (great), keyed by ISO date. Stays on the device.
  Map<String, int> get moods {
    try {
      return (jsonDecode(_p.getString('moods') ?? '{}') as Map)
          .cast<String, int>();
    } catch (_) {
      return {}; // a corrupt value must not break Today
    }
  }

  void setMood(CalendarDate day, int? mood) {
    final m = moods;
    mood == null ? m.remove(day.iso) : m[day.iso] = mood;
    _set(() => _p.setString('moods', jsonEncode(m)));
  }

  List<DrawnCard> drawSpread(Spread s) =>
      draw(s, random: _random, allowReversed: allowReversed);

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
    final List<dynamic> list;
    try {
      list = jsonDecode(raw) as List;
    } catch (_) {
      _quarantine(raw);
      _p.remove('journal');
      return [];
    }
    final ok = <JournalEntry>[];
    final bad = <Object?>[];
    for (final e in list) {
      try {
        ok.add(JournalEntry.fromJson(e));
      } catch (_) {
        bad.add(e);
      }
    }
    if (bad.isNotEmpty) {
      // Unreadable entries are kept aside (and exported), never silently dropped or allowed to block the journal.
      _quarantine(jsonEncode(bad));
      _p.setString('journal', jsonEncode([for (final e in ok) e.toJson()]));
    }
    return ok..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<String> get unreadableJournalData =>
      _p.getStringList('journalQuarantine') ?? [];

  void _quarantine(String raw) =>
      _p.setStringList('journalQuarantine', [...unreadableJournalData, raw]);

  Future<void> _saveJournal(List<JournalEntry> l) async {
    final ok = await _p.setString(
      'journal',
      jsonEncode([for (final e in l) e.toJson()]),
    );
    if (!ok) {
      throw StateError(
        tr(
          pl: 'Nie udało się zapisać dziennika',
          en: 'The journal could not be saved',
          de: 'Das Tagebuch konnte nicht gespeichert werden',
          fr: 'Le journal n’a pas pu être enregistré',
          es: 'No se ha podido guardar el diario',
          uk: 'Не вдалося зберегти щоденник',
          it: 'Impossibile salvare il diario',
          pt: 'Não foi possível salvar o diário',
          nl: 'Het dagboek kon niet worden opgeslagen',
        ),
      );
    }
    notifyListeners();
  }

  Future<void> addEntry(
    String text, {
    String? promptText,
    Map<String, dynamic>? ref,
  }) => _saveJournal([
    JournalEntry(
      // Random suffix: web clocks have ms resolution, so timestamps alone can collide.
      id: '${DateTime.now().microsecondsSinceEpoch}-${_random.nextInt(1 << 32)}',
      createdAt: DateTime.now(),
      text: text,
      promptText: promptText,
      ref: ref == null ? null : {...ref, 'contentVersion': contentVersion},
    ),
    ...journal,
  ]);

  Future<void> updateEntry(String id, String text) => _saveJournal([
    for (final e in journal)
      e.id == id
          ? JournalEntry(
              id: e.id,
              createdAt: e.createdAt,
              text: text,
              promptText: e.promptText,
              ref: e.ref,
            )
          : e,
  ]);

  Future<void> deleteEntry(String id) =>
      _saveJournal(journal.where((e) => e.id != id).toList());

  String exportJournal() => const JsonEncoder.withIndent('  ').convert({
    'app': 'digi_witch',
    'exportedAt': DateTime.now().toIso8601String(),
    'entries': [for (final e in journal) e.toJson()],
    if (moods.isNotEmpty) 'moods': moods,
    if (cardLog.isNotEmpty)
      'cards': {for (final e in cardLog.entries) e.key: e.value.toJson()},
    if (unreadableJournalData.isNotEmpty) 'unreadable': unreadableJournalData,
  });

  /// Removes every locally stored item (journal, profile, card of the day, settings).
  /// The Pro entitlement is kept — it is a purchase, not personal content (restorable anyway).
  /// The widget-clear flag is written first: [DeleteAllResult.notStarted] means it was refused and
  /// nothing was touched. Then the reminder settings go, [cancelReminders] runs (so settings never
  /// say "on" for cancelled notifications), then the rest. A failure after that point is
  /// [DeleteAllResult.partial]: what was removed stays removed, the flag makes every start retry
  /// emptying the widgets, and a second call finishes the job.
  Future<DeleteAllResult> deleteAllData({
    Future<void> Function()? cancelReminders,
  }) async {
    var started = false;
    try {
      if (!await _p.setBool('widgetClearPending', true)) {
        return DeleteAllResult.notStarted;
      }
      started = true;
      for (final k in ['reminderMinutes', 'moonReminders']) {
        if (!await _p.remove(k)) return DeleteAllResult.partial;
      }
      await cancelReminders?.call();
      for (final k in _p.getKeys().toList()) {
        // isPro: the stored purchase (not the DEMO_PRO build flag) is kept as it is
        if (k == 'isPro' || k == 'widgetClearPending') continue;
        if (!await _p.remove(k)) return DeleteAllResult.partial;
      }
      return DeleteAllResult.done;
    } catch (_) {
      return started ? DeleteAllResult.partial : DeleteAllResult.notStarted;
    } finally {
      notifyListeners();
    }
  }

  Future<void> _set(Future<void> Function() f) async {
    await f();
    notifyListeners();
  }
}
