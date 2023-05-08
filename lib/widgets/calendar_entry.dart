import 'dart:math';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hogids/model/calendar_data.dart';
import 'package:hogids/model/dynamic_data.dart';
import 'package:hogids/model/time_manager.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class CalendarEntry extends StatelessWidget {
  const CalendarEntry(this.item, {super.key});

  final CalendarItemData item;

  @override
  Widget build(BuildContext context) {
    final clock = context.watch<TimeManager>().now();
    final hasPassed = item.hasPassed(clock);
    final isHappening = item.isHappening(clock);

    return ListTile(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              final feature = item.location == null
                  ? null
                  : context.watch<DynamicData>().annotations?.firstWhereOrNull(
                      (f) => f.properties.name == item.location);
              return AlertDialog(
                title: Text(item.title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        child: Text(item.subtitle!),
                      ),
                    Row(children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(Icons.schedule),
                      ),
                      Text('${item.tab} ${item.formatTimeRange()}'),
                    ]),
                    if (feature != null)
                      Row(children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(Icons.location_pin),
                        ),
                        Text(feature.properties.displayName ??
                            feature.properties.name ??
                            ''),
                      ])
                  ],
                ),
                contentPadding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: item.subtitle == null ? 20 : 0,
                  bottom: item.location == null ? 20 : 0,
                ),
                actions: [
                  if (item.location != null)
                    TextButton(
                        onPressed: () {
                          final random = Random().nextInt(1000000);
                          Beamer.of(context, root: true).beamToNamed(
                              '/kaart?id=${item.location}&refresh=$random');
                        },
                        child: const Text('Toon op kaart')),
                ],
              );
            });
      },
      shape: isHappening
          ? Border(
              left: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 6))
          : null,
      contentPadding: EdgeInsets.only(left: isHappening ? 10 : 16, right: 16),
      leading: SizedBox(
        width: 120,
        child: Text(item.formatTimeRange(),
            style: TextStyle(
                color: hasPassed ? Colors.grey : null,
                fontSize: 16,
                fontWeight: isHappening ? FontWeight.bold : null)),
      ),
      title: Text(item.title,
          style: TextStyle(
              color: hasPassed ? Colors.grey : null,
              fontWeight: isHappening ? FontWeight.bold : null)),
    );
  }
}
