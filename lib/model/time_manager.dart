import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hogids/model/calendar_data.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimeManager extends ChangeNotifier {
  static final defaultStart = DateTime(2023, 8, 25, 0, 0);
  static const days = ['VR', 'ZA', 'ZO'];
  DateTime? nowOverride;
  DateTime startDate = defaultStart;
  late Timer timer;

  TimeManager() {
    timeago.setLocaleMessages('nl', timeago.NlMessages());
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (nowOverride == null) notifyListeners();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  DateTime now() {
    return nowOverride ?? DateTime.now();
  }

  void setNowOverride(DateTime? override) {
    nowOverride = override;
    notifyListeners();
  }

  void setStartOverride(DateTime? override) {
    startDate = override == null
        ? defaultStart
        : override.copyWith(
            hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
    notifyListeners();
  }

  String timeAgo(String str) {
    final time = parseTime(str);
    return timeago.format(time!,
        locale: 'nl', clock: now(), allowFromNow: true);
  }

  bool hasHappened(DateTime time) {
    return now().isAfter(time);
  }

  List<CalendarItemData> getFeaturedEvents(List<CalendarItemData> items) {
    final events = items.sortedBy((item) => item.getStartTime(this));
    var nowEvent = events.indexWhere((item) => item.isHappening(this));
    if (nowEvent == -1) {
      // if no event is currently happening, find the next upcoming event
      nowEvent =
          events.indexWhere((item) => item.getStartTime(this).isAfter(now()));
    }
    if (nowEvent == -1) {
      // if no event is upcoming, show the first event
      nowEvent = 0;
    }
    return events.sublist(nowEvent, min(nowEvent + 3, events.length));
  }

  DateTime? parseTime(String str) {
    final parts = str.split(' ');
    if (parts.length != 2) return null;

    var date = startDate;
    final dayIndex = days.indexOf(parts[0]);
    if (dayIndex > -1) {
      date = date.add(Duration(days: dayIndex));
    } else {
      final dayParts = parts[0].split('/');
      if (dayParts.length != 2) return null;
      final day = int.tryParse(dayParts[0]);
      final month = int.tryParse(dayParts[1]);
      if (day == null || month == null) return null;
      date = date.copyWith(day: day, month: month);
    }
  
    final timeParts = parts[1].split(':');
    if (timeParts.length != 2) return null;
    final hour = int.tryParse(timeParts[0]);
    final minute = int.tryParse(timeParts[1]);
    if (hour == null || minute == null) return null;

    return date.copyWith(hour: hour, minute: minute);
  }

  static String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}.${time.minute.toString().padLeft(2, '0')}';
  }
}
