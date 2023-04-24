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
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: const TextStyle(fontSize: 18)),
                  if (item.description != null)
                    Text(item.description!,
                        style: const TextStyle(fontSize: 14)),
                  Text(timeManager.timeAgo(item.publishTime),
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
                    item.image!,
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
