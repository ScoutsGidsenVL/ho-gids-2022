import 'package:hogids/model/time_manager.dart';
import 'package:json_annotation/json_annotation.dart';

part 'news_data.g.dart';

@JsonSerializable(createToJson: false)
class NewsData {
  NewsData(this.news);

  List<NewsItemData> news;

  factory NewsData.fromJson(Map<String, dynamic> json) =>
      _$NewsDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class NewsItemData {
  NewsItemData(
    this.title,
    this.subtitle,
    this.image,
    this.body,
    this.publishTime,
    this.archiveTime,
    this.pin,
    this.notify,
  );

  String title;
  String? subtitle;
  String? image;
  String? body;
  String? publishTime;
  String? archiveTime;
  bool? pin;
  bool? notify;

  DateTime? getPublishedTime(TimeManager manager) {
    return publishTime == null ? null : manager.parseTime(publishTime!);
  }

  DateTime? getArchivedTime(TimeManager manager) {
    return archiveTime == null ? null : manager.parseTime(archiveTime!);
  }

  bool isPublished(TimeManager manager) {
    return getPublishedTime(manager)?.isBefore(manager.now()) ?? false;
  }

  bool isArchived(TimeManager manager) {
    return getArchivedTime(manager)?.isBefore(manager.now()) ?? false;
  }

  bool isPinned(TimeManager manager) {
    return pin == true && !isArchived(manager);
  }

  factory NewsItemData.fromJson(Map<String, dynamic> json) =>
      _$NewsItemDataFromJson(json);
}
