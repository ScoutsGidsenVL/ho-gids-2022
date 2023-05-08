import 'dart:math';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hogids/model/dynamic_data.dart';
import 'package:hogids/model/time_manager.dart';
import 'package:hogids/widgets/calendar_entry.dart';
import 'package:hogids/widgets/news_list.dart';
import 'package:hogids/widgets/tap_detector.dart';
import 'package:provider/provider.dart';

// Disable when publishing
const canChangeClock = true;

class Nieuws extends StatelessWidget {
  final bool? includeArchive;

  const Nieuws({Key? key, this.includeArchive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dynamicData = context.watch<DynamicData>();
    final timeManager = context.watch<TimeManager>();
    final news = dynamicData.news ?? [];
    final allPublished = news.where((n) => n.isPublished(timeManager));

    final calendar = dynamicData.calendar ?? [];
    final allEvents = calendar.expand((tab) => tab.items).toList();
    final featuredEvents = timeManager.getFeaturedEvents(allEvents);

    return Scaffold(
      appBar: AppBar(
        title: TapDetector(
            count: 4,
            onTapped: () {
              context.beamToNamed('/nieuws/developer');
            },
            child: const Text('HO-Gids')),
      ),
      body: allPublished.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 64, horizontal: 16),
              child: Center(child: Text('Nog geen nieuws...')),
            )
          : NewsList(
              news: news,
              includeArchive: includeArchive,
              children: [
                if (featuredEvents.isNotEmpty)
                  Material(
                    color: Theme.of(context).colorScheme.secondary,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            dense: true,
                            onTap: () {
                              final random = Random().nextInt(1000000);
                              Beamer.of(context, root: true)
                                  .beamToReplacementNamed(
                                      '/programma?refresh=$random');
                            },
                            leading: const Icon(Icons.calendar_today),
                            horizontalTitleGap: 0,
                            title: const Text('PROGRAMMA',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          ...featuredEvents.map((item) => CalendarEntry(item)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
