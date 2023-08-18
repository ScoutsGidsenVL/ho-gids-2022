import 'package:hogids/model/time_manager.dart';
import 'package:json_annotation/json_annotation.dart';

part 'calendar_data.g.dart';

@JsonSerializable(createToJson: false)
class CalendarData {
  CalendarData(this.tabs);

  List<CalendarTabData> tabs;

  factory CalendarData.fromJson(Map<String, dynamic> json) =>
      _$CalendarDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class CalendarTabData {
  CalendarTabData(this.label, this.items);

  String label;
  List<CalendarItemData> items;

  factory CalendarTabData.fromJson(Map<String, dynamic> json) {
    final res = _$CalendarTabDataFromJson(json);
    for (final item in res.items) {
      item.tab = res.label;
    }
    return res;
  }
}

@JsonSerializable(createToJson: false)
class CalendarItemData {
  CalendarItemData(this.title, this.subtitle, this.start, this.end,
      this.location, this.group, this.notify);

  String title;
  String? subtitle;
  String start;
  String? end;
  String? location;
  String? group;
  bool? notify;

  @JsonKey(includeFromJson: false)
  String tab = '';

  DateTime getStartTime(TimeManager manager) {
    return manager.parseTime(start)!;
  }

  DateTime? getEndTime(TimeManager manager) {
    return end == null ? null : manager.parseTime(end!)!;
  }

  String formatTimeRange(TimeManager manager) {
    var time = TimeManager.formatTime(getStartTime(manager));
    if (end != null) {
      time += '-${TimeManager.formatTime(getEndTime(manager)!)}';
    }
    return time;
  }

  bool hasPassed(TimeManager manager) {
    return getEndTime(manager)?.isBefore(manager.now()) ?? false;
  }

  bool isHappening(TimeManager manager) {
    return getStartTime(manager).isBefore(manager.now()) &&
        (getEndTime(manager)?.isAfter(manager.now()) ?? false);
  }

  factory CalendarItemData.fromJson(Map<String, dynamic> json) =>
      _$CalendarItemDataFromJson(json);
}
