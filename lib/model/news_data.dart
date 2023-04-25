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
  );

  String title;
  String? subtitle;
  String? image;
  String? body;
  String? publishTime;
  String? archiveTime;
  bool? pin;

  factory NewsItemData.fromJson(Map<String, dynamic> json) =>
      _$NewsItemDataFromJson(json);
}
