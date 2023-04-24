import 'package:flutter/material.dart';
import 'package:ho_gids/util.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimeManager extends ChangeNotifier {
  DateTime? nowOverride;

  TimeManager() {
    timeago.setLocaleMessages('nl', timeago.NlMessages());
  }

  DateTime now() {
    return nowOverride ?? DateTime.now();
  }

  void setOverride(DateTime? override) {
    nowOverride = override;
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
}
