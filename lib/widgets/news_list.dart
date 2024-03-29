import 'package:beamer/beamer.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hogids/model/news_data.dart';
import 'package:hogids/model/time_manager.dart';
import 'package:hogids/widgets/news_card.dart';
import 'package:provider/provider.dart';

class NewsList extends StatelessWidget {
  final List<NewsItemData> news;
  final bool? includeArchive;
  final List<Widget> children;

  const NewsList({
    super.key,
    required this.news,
    this.includeArchive,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    final timeManager = context.watch<TimeManager>();
    final newsToAdd = news.where((n) => n.publishTime != null).sorted((a, b) {
      // pinned articles above non-pinned
      if (a.isPinned(timeManager) != b.isPinned(timeManager)) {
        return a.isPinned(timeManager) ? -1 : 1;
      }
      // non-archived articles above archived
      if (a.isArchived(timeManager) != b.isArchived(timeManager)) {
        return a.isArchived(timeManager) ? 1 : -1;
      }
      // otherwise order by publish date
      return b
          .getPublishedTime(timeManager)!
          .compareTo(a.getPublishedTime(timeManager)!);
    }).where((n) {
      return n.isPublished(timeManager) &&
          (includeArchive == true || !n.isArchived(timeManager));
    }).toList();
    final archivedCount =
        news.where((n) => n.isPublished(timeManager)).length - newsToAdd.length;

    final entries = <Widget>[];
    final childrenToAdd = List.from(children);
    var newsCount = 0;

    while (newsToAdd.isNotEmpty || childrenToAdd.isNotEmpty) {
      if ((newsCount >= 3 || newsToAdd.isEmpty) && childrenToAdd.isNotEmpty) {
        entries.add(childrenToAdd.removeAt(0));
        newsCount = 0;
      } else if (newsToAdd.isNotEmpty) {
        entries.add(NewsCard(newsToAdd.removeAt(0)));
        newsCount += 1;
        if (newsToAdd.isEmpty && archivedCount > 0) {
          entries.add(Padding(
            padding: const EdgeInsets.all(10),
            child: OutlinedButton(
                onPressed: () {
                  context.beamToNamed('/nieuws?archive=true',
                      transitionDelegate:
                          const NoAnimationTransitionDelegate());
                },
                child: const Text('Meer nieuws...')),
          ));
        }
      }
    }

    return ListView(
      children: entries,
    );
  }
}
