import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:ho_gids/model/news_data.dart';
import 'package:ho_gids/model/time_manager.dart';
import 'package:provider/provider.dart';

class NewsCard extends StatelessWidget {
  final NewsItemData item;

  const NewsCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final timeManager = context.watch<TimeManager>();
    final clock = timeManager.now();

    return InkWell(
      onTap: () {
        if (item.body == null) return;
        context.beamToNamed('/nieuws/${item.body}');
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(TextSpan(children: [
                    if (item.isPinned(clock))
                      const WidgetSpan(child: Icon(Icons.push_pin, size: 16)),
                    TextSpan(
                        text: item.title, style: const TextStyle(fontSize: 18)),
                  ])),
                  if (item.subtitle != null)
                    Text(item.subtitle!, style: const TextStyle(fontSize: 14)),
                  if (item.publishTime != null)
                    Text(timeManager.timeAgo(item.publishTime!),
                        style: Theme.of(context).textTheme.bodySmall)
                ],
              ),
            ),
            if (item.image != null)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/${item.image!}',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
