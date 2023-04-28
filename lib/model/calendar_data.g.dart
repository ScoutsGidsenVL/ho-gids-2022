// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarData _$CalendarDataFromJson(Map<String, dynamic> json) => CalendarData(
      (json['tabs'] as List<dynamic>)
          .map((e) => CalendarTabData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

CalendarTabData _$CalendarTabDataFromJson(Map<String, dynamic> json) =>
    CalendarTabData(
      json['label'] as String,
      (json['items'] as List<dynamic>)
          .map((e) => CalendarItemData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

CalendarItemData _$CalendarItemDataFromJson(Map<String, dynamic> json) =>
    CalendarItemData(
      json['title'] as String,
      json['start'] as String,
    )
      ..end = json['end'] as String?
      ..location = json['location'] as String?
      ..group = json['group'] as String?;
