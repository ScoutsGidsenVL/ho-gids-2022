import 'package:hogids/util.dart';
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

  DateTime getStartTime() {
    return parseTime(start)!;
  }

  DateTime? getEndTime() {
    return end == null ? null : parseTime(end!)!;
  }

  String formatTimeRange() {
    var time = formatTime(getStartTime());
    if (end != null) {
      time += '-${formatTime(getEndTime()!)}';
    }
    return time;
  }

  bool hasPassed(DateTime clock) {
    return getEndTime()?.isBefore(clock) ?? false;
  }

  bool isHappening(DateTime clock) {
    return getStartTime().isBefore(clock) &&
        (getEndTime()?.isAfter(clock) ?? true);
  }

  factory CalendarItemData.fromJson(Map<String, dynamic> json) =>
      _$CalendarItemDataFromJson(json);
}
