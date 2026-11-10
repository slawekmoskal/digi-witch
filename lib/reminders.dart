import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

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

  /// Returns false if the user declined the system permission.
  static Future<bool> enable(
    int hour,
    int minute, {
    required String title,
    required String body,
  }) async {
    await _init();
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
    if (granted != true) return false;
    await _schedule(hour, minute, title: title, body: body);
    return true;
  }

  /// Re-plans an already enabled reminder at app start (zone change, restored backup). No permission prompt.
  static Future<void> reschedule(
    int minutes, {
    required String title,
    required String body,
  }) async {
    if (!supported) return;
    try {
      await _init();
      await _schedule(minutes ~/ 60, minutes % 60, title: title, body: body);
    } catch (_) {
      // Never block app start because of a reminder.
    }
  }

  static Future<void> _schedule(
    int hour,
    int minute, {
    required String title,
    required String body,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var at = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (!at.isAfter(now)) at = at.add(const Duration(days: 1));
    await _plugin.cancelAll();
    await _plugin.zonedSchedule(
      id: 1,
      scheduledDate: at,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reflection',
          'Przypomnienie o refleksji',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode
          .inexactAllowWhileIdle, // no exact-alarm permission needed
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> disable() async {
    if (!supported) return;
    await _init();
    await _plugin.cancelAll();
  }
}
