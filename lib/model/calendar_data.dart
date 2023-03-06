import 'package:json_annotation/json_annotation.dart';

part 'calendar_data.g.dart';

@JsonSerializable(createToJson: false)
class CalendarData {
  CalendarData(this.tabs);

  List<CalendarTab> tabs;

  factory CalendarData.fromJson(Map<String, dynamic> json) =>
      _$CalendarDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class CalendarTab {
  CalendarTab(this.label, this.items);

  String label;
  List<CalendarItem> items;

  factory CalendarTab.fromJson(Map<String, dynamic> json) =>
      _$CalendarTabFromJson(json);
}

@JsonSerializable(createToJson: false)
class CalendarItem {
  CalendarItem(this.title, this.start);

  String title;
  String start;
  String? end;
  String? location;
  String? group;

  String formatTime() {
    var time = start.substring(3);
    if (time.startsWith("0")) {
      time = time.substring(1);
    }
    if (end != null) {
      var endPart = end!.substring(3);
      if (endPart.startsWith("0")) {
        endPart = endPart.substring(1);
      }
      time += '-$endPart';
    }
    time.replaceAll(':', '.');
    return time;
  }

  factory CalendarItem.fromJson(Map<String, dynamic> json) =>
      _$CalendarItemFromJson(json);
}
