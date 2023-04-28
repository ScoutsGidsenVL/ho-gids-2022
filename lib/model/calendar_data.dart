import 'package:ho_gids/util.dart';
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

  factory CalendarTabData.fromJson(Map<String, dynamic> json) =>
      _$CalendarTabDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class CalendarItemData {
  CalendarItemData(this.title, this.start);

  String title;
  String start;
  String? end;
  String? location;
  String? group;

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
