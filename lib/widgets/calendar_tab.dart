import 'package:flutter/material.dart';
import 'package:ho_gids/model/calendar_data.dart';
import 'package:ho_gids/widgets/calendar_entry.dart';

class CalendarTab extends StatelessWidget {
  const CalendarTab({Key? key, required this.tab}) : super(key: key);

  final CalendarTabData tab;

  @override
  Widget build(BuildContext context) {
    var rows = <Widget>[];
    String? lastGroup = "none";
    for (var item in tab.items) {
      if (item.group != lastGroup && item.group != null) {
        rows.add(ListTile(
          dense: true,
          title: Text(
            item.group!.toUpperCase(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ));
      }
      lastGroup = item.group;
      rows.add(CalendarEntry(item));
    }
    return ListView(
      children: rows,
    );
  }
}
