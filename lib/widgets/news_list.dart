import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ho_gids/model/news_data.dart';
import 'package:ho_gids/model/time_manager.dart';
import 'package:ho_gids/util.dart';
import 'package:ho_gids/widgets/news_card.dart';
import 'package:provider/provider.dart';

class NewsList extends StatelessWidget {
  final List<NewsItemData> news;

  const NewsList(this.news, {super.key});

  @override
  Widget build(BuildContext context) {
    final timeManager = context.watch<TimeManager>();
    final feed = news.where((n) => n.publishTime != null).sorted((a, b) {
      if ((a.pin ?? false) != (b.pin ?? false)) {
        return a.pin == true ? -1 : 1;
      }
      return parseTime(b.publishTime!)!.compareTo(parseTime(a.publishTime!)!);
    }).where((n) {
      return timeManager.hasHappened(parseTime(n.publishTime!)!) &&
          (n.archiveTime == null ||
              !timeManager.hasHappened(parseTime(n.archiveTime!)!));
    }).toList();

    return ListView.builder(
      itemCount: feed.length,
      itemBuilder: (context, index) {
        return NewsCard(feed[index]);
      },
    );
  }
}
