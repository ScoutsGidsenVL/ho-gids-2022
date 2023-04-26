import 'package:beamer/beamer.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ho_gids/model/news_data.dart';
import 'package:ho_gids/model/time_manager.dart';
import 'package:ho_gids/widgets/news_card.dart';
import 'package:provider/provider.dart';

class NewsList extends StatelessWidget {
  final List<NewsItemData> news;
  final bool? includeArchive;

  const NewsList(this.news, {super.key, this.includeArchive});

  @override
  Widget build(BuildContext context) {
    final timeManager = context.watch<TimeManager>();
    final clock = timeManager.now();
    final feed = news.where((n) => n.publishTime != null).sorted((a, b) {
      // pinned articles above non-pinned
      if (a.isPinned(clock) != b.isPinned(clock)) {
        return a.isPinned(clock) ? -1 : 1;
      }
      // non-archived articles above archived
      if (a.isArchived(clock) != b.isArchived(clock)) {
        return a.isArchived(clock) ? 1 : -1;
      }
      // otherwise order by publish date
      return b.published!.compareTo(a.published!);
    }).where((n) {
      return n.isPublished(clock) &&
          (includeArchive == true || !n.isArchived(clock));
    }).toList();
    final allPublished = news.where((n) => n.isPublished(clock));

    return ListView.builder(
      itemCount: feed.length +
          (includeArchive == true || allPublished.length == feed.length
              ? 0
              : 1),
      itemBuilder: (context, index) {
        if (index == feed.length) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: OutlinedButton(
                onPressed: () {
                  context.beamToNamed('/nieuws?archive=true',
                      transitionDelegate:
                          const NoAnimationTransitionDelegate());
                },
                child: const Text('Meer...')),
          );
        }
        return NewsCard(feed[index]);
      },
    );
  }
}
