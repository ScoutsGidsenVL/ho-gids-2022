// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsData _$NewsDataFromJson(Map<String, dynamic> json) => NewsData(
      (json['news'] as List<dynamic>)
          .map((e) => NewsItemData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

NewsItemData _$NewsItemDataFromJson(Map<String, dynamic> json) => NewsItemData(
      json['title'] as String,
      json['subtitle'] as String?,
      json['image'] as String?,
      json['body'] as String?,
      json['publishTime'] as String?,
      json['archiveTime'] as String?,
      json['pin'] as bool?,
    );
