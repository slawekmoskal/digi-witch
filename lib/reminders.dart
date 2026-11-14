import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'engine/lang.dart';
import 'monetization/monetization.dart' show monetizationSupported;

/// Optional daily reminder. Off by default; neutral wording (also on the lock screen); no guilt for skipped days.
class Reminders {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _ready = false;

  static bool get supported => monetizationSupported; // Android/iOS only

  static Future<void> _init() async {
    // Refresh the zone every time: the user may have travelled since the last schedule.
    if (!_ready) tzdata.initializeTimeZones();
    try {
      tz.setLocalLocation(
        tz.getLocation((await FlutterTimezone.getLocalTimezone()).identifier),
      );
    } catch (_) {
      tz.setLocalLocation(
        tz.getLocation('Europe/Warsaw'),
      ); // unknown id; first market is Poland
    }
    if (_ready) return;
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        // Permission is requested explicitly when the user turns reminders on, not at startup.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    _ready = true;
  }

  /// Daily reminders with that day's content. Returns false if the user declined the system permission.
  static Future<bool> enable(List<(DateTime, String, String)> days) async {
    await _init();
    if (!await _request()) return false;
    await _schedule(days);
    return true;
  }

  static Future<bool> _request() async {
    final granted = defaultTargetPlatform == TargetPlatform.iOS
        ? await _plugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, sound: true)
        : await _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestNotificationsPermission();
    return granted == true;
  }

  static const _moonIds = [10, 11, 12, 13];

  /// One-off notifications for the next new and full moons. Returns false if permission was declined.
  static Future<bool> enableMoon(
    List<(DateTime, String, String)> events,
  ) async {
    if (!supported) return false;
    await _init();
    if (!await _request()) return false;
    await _scheduleMoon(events);
    return true;
  }

  /// Re-plans moon reminders at app start (the next phases move on). No permission prompt.
  static Future<void> rescheduleMoon(
    List<(DateTime, String, String)> events,
  ) async {
    if (!supported) return;
    try {
      await _init();
      await _scheduleMoon(events);
    } catch (_) {}
  }

  static Future<void> _scheduleMoon(
    List<(DateTime, String, String)> events,
  ) async {
    for (final id in _moonIds) {
      await _plugin.cancel(id: id);
    }
    final now = DateTime.now();
    var i = 0;
    for (final (at, title, body) in events) {
      if (!at.isAfter(now) || i >= _moonIds.length) continue;
      await _plugin.zonedSchedule(
        id: _moonIds[i++],
        scheduledDate: tz.TZDateTime.from(at, tz.local),
        title: title,
        body: body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'moon_rituals',
            tr(
              pl: 'Nów i pełnia',
              en: 'New and full moon',
              de: 'Neumond und Vollmond',
              fr: 'Nouvelle et pleine lune',
              es: 'Luna nueva y llena',
              uk: 'Молодик і повня',
              it: 'Luna nuova e piena',
              pt: 'Lua nova e cheia',
              nl: 'Nieuwe en volle maan',
            ),
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  static Future<void> disableMoon() async {
    if (!supported) return;
    await _init();
    for (final id in _moonIds) {
      await _plugin.cancel(id: id);
    }
  }

  /// Re-plans an already enabled reminder at app start (new content, zone change). No permission prompt.
  static Future<void> reschedule(List<(DateTime, String, String)> days) async {
    if (!supported) return;
    try {
      await _init();
      await _schedule(days);
    } catch (_) {
      // Never block app start because of a reminder.
    }
  }

  // id 1 was the old repeating reminder; cancelled for users upgrading.
  static final _dailyIds = [1, for (var i = 20; i < 50; i++) i];

  // shortcut: one-off notifications for the next 30 days, refreshed at every app start;
  // after 30 days without opening the app they stop (gentle by design). Revisit if users ask otherwise.
  static Future<void> _schedule(List<(DateTime, String, String)> days) async {
    for (final id in _dailyIds) {
      await _plugin.cancel(id: id);
    }
    final now = DateTime.now();
    var i = 1;
    for (final (at, title, body) in days) {
      if (!at.isAfter(now) || i >= _dailyIds.length) continue;
      await _plugin.zonedSchedule(
        id: _dailyIds[i++],
        scheduledDate: tz.TZDateTime.from(at, tz.local),
        title: title,
        body: body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_reflection',
            tr(
              pl: 'Przypomnienie o refleksji',
              en: 'Reflection reminder',
              de: 'Erinnerung zum Innehalten',
              fr: 'Rappel de réflexion',
              es: 'Recordatorio para reflexionar',
              uk: 'Нагадування про роздуми',
              it: 'Promemoria per riflettere',
              pt: 'Lembrete para refletir',
              nl: 'Herinnering om te reflecteren',
            ),
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode
            .inexactAllowWhileIdle, // no exact-alarm permission needed
      );
    }
  }

  static Future<void> disable() async {
    if (!supported) return;
    await _init();
    for (final id in _dailyIds) {
      await _plugin.cancel(id: id);
    }
  }
}
