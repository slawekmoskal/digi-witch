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
    if (_ready) return;
    tzdata.initializeTimeZones();
    tz.setLocalLocation(
      tz.getLocation((await FlutterTimezone.getLocalTimezone()).identifier),
    );
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
    return true;
  }

  static Future<void> disable() async {
    if (!supported) return;
    await _init();
    await _plugin.cancelAll();
  }
}
