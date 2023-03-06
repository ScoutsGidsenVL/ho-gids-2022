// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarData _$CalendarDataFromJson(Map<String, dynamic> json) => CalendarData(
      (json['tabs'] as List<dynamic>)
          .map((e) => CalendarTab.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

CalendarTab _$CalendarTabFromJson(Map<String, dynamic> json) => CalendarTab(
      json['label'] as String,
      (json['items'] as List<dynamic>)
          .map((e) => CalendarItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

CalendarItem _$CalendarItemFromJson(Map<String, dynamic> json) => CalendarItem(
      json['title'] as String,
      json['start'] as String,
    )
      ..end = json['end'] as String?
      ..location = json['location'] as String?
      ..group = json['group'] as String?;
