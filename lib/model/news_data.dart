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
  NewsItemData(this.title, this.description, this.image, this.publishTime,
      this.archiveTime);

  String title;
  String? description;
  String? image;
  String publishTime;
  String? archiveTime;

  factory NewsItemData.fromJson(Map<String, dynamic> json) =>
      _$NewsItemDataFromJson(json);
}
