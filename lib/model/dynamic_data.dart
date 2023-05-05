import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hogids/model/calendar_data.dart';
import 'package:hogids/model/map_data.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hogids/model/news_data.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

const dataRepo =
    'https://raw.githubusercontent.com/ScoutsGidsenVL/ho-gids-2022/main';

class DynamicData extends ChangeNotifier {
  late Timer timer;
  List<MapFeature>? annotations;
  List<CalendarTabData>? calendar;
  List<NewsItemData>? news;
  Map<String, String> text = {};
  FlutterLocalNotificationsPlugin? notificationsPlugin;

  DynamicData() {
    refreshData();
    timer = Timer.periodic(const Duration(minutes: 30), (timer) {
      refreshData();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future refreshData() async {
    await refreshNewsData();
    await Future.wait([
      refreshMapData(),
      refreshCalendarData(),
      ...news?.where((n) => n.body != null).map((n) => refreshText(n.body!)) ??
          [],
    ]);
    notifyListeners();
    await scheduleNotifications();
  }

  Future refreshMapData() async {
    var source = await fetchAsset('content/kaart.json');
    var data = await json.decode(source);
    annotations = MapAnnotations.fromJson(data).features;
  }

  Future refreshCalendarData() async {
    var source = await fetchAsset('content/programma.json');
    var data = await json.decode(source);
    calendar = CalendarData.fromJson(data).tabs;
  }

  Future refreshNewsData() async {
    var source = await fetchAsset('content/nieuws.json');
    var data = await json.decode(source);
    news = NewsData.fromJson(data).news;
  }

  Future refreshText(String key) async {
    text[key] = await fetchAsset('content/nieuws/$key.md');
  }

  Future<String> fetchAsset(String path) async {
    try {
      if (kDebugMode) {
        throw Exception("Always read from the local bundle in debug mode");
      }
      var manager = DefaultCacheManager();
      var url = '$dataRepo/assets/$path';
      try {
        // First try to fetch the most recent version
        var fileInfo = await manager.downloadFile(url);
        return await fileInfo.file.readAsString();
      } catch (e) {
        // If that fails get the cached version
        var file = await manager.getSingleFile(url);
        return await file.readAsString();
      }
    } catch (e) {
      // If that fails read from the app bundle
      return await rootBundle.loadString('assets/$path');
    }
  }

  Future scheduleNotifications() async {
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
    await Future.wait([
      ...news!
          .where((item) =>
              (item.notify ?? false) &&
              item.publishTime != null &&
              item.published!.isAfter(DateTime.now()))
          .map((item) {
        return notificationsPlugin!.zonedSchedule(
          random.nextInt(1000000000),
          item.title,
          item.subtitle,
          tz.TZDateTime.from(item.published!, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails('hogids_news', 'Nieuws'),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }),
      ...calendar!.expand((tab) => tab.items
              .where((item) =>
                  (item.notify ?? false) &&
                  item.getStartTime().isAfter(DateTime.now()))
              .map((item) {
            return notificationsPlugin!.zonedSchedule(
              random.nextInt(1000000000),
              item.title,
              item.subtitle,
              tz.TZDateTime.from(item.getStartTime(), tz.local),
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
  }
}
