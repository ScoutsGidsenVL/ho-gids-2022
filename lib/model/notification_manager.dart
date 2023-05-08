import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hogids/model/dynamic_data.dart';
import 'package:hogids/model/time_manager.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationManager extends ChangeNotifier {
  FlutterLocalNotificationsPlugin? notificationsPlugin;
  DynamicData? dynamicData;
  TimeManager? timeManager;

  void update(DynamicData dynamicData, TimeManager timeManager) {
    this.dynamicData = dynamicData;
    this.timeManager = timeManager;
    scheduleNotifications();
  }

  Future<int> scheduleNotifications() async {
    if (dynamicData == null || timeManager == null) {
      return 0;
    }

    if (notificationsPlugin == null) {
      final plugin = FlutterLocalNotificationsPlugin();
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Europe/Brussels'));
      const notificationSettings = InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
        iOS: DarwinInitializationSettings(),
      );
      await plugin.initialize(notificationSettings);
      notificationsPlugin = plugin;
    }

    final scheduled = await notificationsPlugin!.pendingNotificationRequests();
    await Future.wait(scheduled.map((n) {
      return notificationsPlugin!.cancel(n.id);
    }));
    final random = Random();
    final results = await Future.wait([
      ...(dynamicData!.news ?? [])
          .where((item) =>
              (item.notify ?? false) &&
              item.publishTime != null &&
              item.getPublishedTime(timeManager!)!.isAfter(DateTime.now()))
          .map((item) {
        return notificationsPlugin!.zonedSchedule(
          random.nextInt(1000000000),
          item.title,
          item.subtitle,
          tz.TZDateTime.from(item.getPublishedTime(timeManager!)!, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails('hogids_news', 'Nieuws'),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }),
      ...dynamicData!.calendar!.expand((tab) => tab.items
              .where((item) =>
                  (item.notify ?? false) &&
                  item.getStartTime(timeManager!).isAfter(DateTime.now()))
              .map((item) {
            return notificationsPlugin!.zonedSchedule(
              random.nextInt(1000000000),
              item.title,
              item.subtitle,
              tz.TZDateTime.from(item.getStartTime(timeManager!), tz.local),
              const NotificationDetails(
                android:
                    AndroidNotificationDetails('hogids_programma', 'Programma'),
                iOS: DarwinNotificationDetails(),
              ),
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
            );
          })),
    ]);
    return results.length;
  }
}
