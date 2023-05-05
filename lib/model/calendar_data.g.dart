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
      json['subtitle'] as String?,
      json['start'] as String,
      json['end'] as String?,
      json['location'] as String?,
      json['group'] as String?,
      json['notify'] as bool?,
    );
