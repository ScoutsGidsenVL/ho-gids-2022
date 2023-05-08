import 'package:flutter/material.dart';
import 'package:hogids/model/dynamic_data.dart';
import 'package:hogids/model/map_data.dart';
import 'package:hogids/model/time_manager.dart';
import 'package:hogids/widgets/calendar_entry.dart';
import 'package:provider/provider.dart';

class FeatureCard extends StatelessWidget {
  final MapFeature feature;

  const FeatureCard(this.feature, {super.key});

  @override
  Widget build(BuildContext context) {
    final calendar = context.watch<DynamicData>().calendar ?? [];
    final timeManager = context.watch<TimeManager>();

    final hereEvents = calendar
        .expand((tab) => tab.items)
        .where((item) => item.location == feature.properties.name)
        .where((item) => item
            .getStartTime(timeManager)
            .isBefore(timeManager.now().add(const Duration(days: 1))))
        .toList();
    final featuredEvents = timeManager.getFeaturedEvents(hereEvents);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text(
              feature.properties.displayName ?? feature.properties.name ?? '',
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            )),
        ...featuredEvents.map((e) => CalendarEntry(e)),
      ],
    );
  }
}
