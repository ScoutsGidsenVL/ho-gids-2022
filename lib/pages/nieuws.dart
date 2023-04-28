import 'dart:math';

import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ho_gids/model/dynamic_data.dart';
import 'package:ho_gids/model/time_manager.dart';
import 'package:ho_gids/widgets/calendar_entry.dart';
import 'package:ho_gids/widgets/news_list.dart';
import 'package:provider/provider.dart';

class Nieuws extends StatelessWidget {
  final bool? includeArchive;

  const Nieuws({Key? key, this.includeArchive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final news = context.watch<DynamicData>().news ?? [];
    final timeManager = context.watch<TimeManager>();
    final clock = timeManager.now();
    final allPublished = news.where((n) => n.isPublished(timeManager.now()));

    final calendar = context.watch<DynamicData>().calendar ?? [];
    final allEvents = calendar.expand((tab) => tab.items).toList();
    var nowEvent = allEvents.indexWhere((item) => item.isHappening(clock));
    if (nowEvent == -1) {
      nowEvent = 0;
    }
    final featuredEvents =
        allEvents.sublist(nowEvent, min(nowEvent + 3, allEvents.length));

    return Scaffold(
      appBar: AppBar(
        title: const Text('HO-Gids'),
        actions: [
          if (kDebugMode)
            IconButton(
                onPressed: () async {
                  final date = await showDatePicker(
                      context: context,
                      initialDate: clock,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2024),
                      locale: const Locale('nl', 'BE'));
                  if (date == null) return;
                  // ignore: use_build_context_synchronously
                  final time = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  if (time == null) return;
                  timeManager.setOverride(DateTime(
                      date.year, date.month, date.day, time.hour, time.minute));
                },
                icon: const Icon(Icons.today))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            allPublished.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 64, horizontal: 16),
                    child: Center(child: Text('Nog geen nieuws...')),
                  )
                : NewsList(news, includeArchive: includeArchive),
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
                          Beamer.of(context, root: true)
                              .beamToReplacementNamed('/programma');
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
              )
          ],
        ),
      ),
    );
  }
}
