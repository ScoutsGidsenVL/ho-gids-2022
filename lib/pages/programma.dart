import 'package:flutter/material.dart';
import 'package:ho_gids/model/calendar_data.dart';
import 'package:ho_gids/model/dynamic_data.dart';
import 'package:ho_gids/widgets/nav_drawer.dart';
import 'package:provider/provider.dart';

class Programma extends StatelessWidget {
  const Programma({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var calendar = context.watch<DynamicData>().calendar ?? [];

    return DefaultTabController(
        length: calendar.length,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Programma'),
              bottom: TabBar(
                  tabs: calendar.map((e) => Tab(text: e.label)).toList(),
                  indicatorColor: Theme.of(context).colorScheme.secondary),
            ),
            drawer: const NavDrawer(),
            body: TabBarView(
              children: calendar
                  .map((tab) => ListView(children: [ProgrammaTab(tab: tab)]))
                  .toList(),
            )));
  }
}

class ProgrammaTab extends StatelessWidget {
  const ProgrammaTab({Key? key, required this.tab}) : super(key: key);

  final CalendarTab tab;

  @override
  Widget build(BuildContext context) {
    const cellPadding = EdgeInsets.symmetric(vertical: 12, horizontal: 20);
    var rows = <TableRow>[];
    String? lastGroup;
    for (var item in tab.items) {
      if (item.group != lastGroup && item.group != null) {
        rows.add(TableRow(children: [
          Padding(
            padding: cellPadding,
            child: Text(item.group!.toUpperCase(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Container(),
        ]));
        lastGroup = item.group;
      }
      rows.add(TableRow(children: [
        Padding(
          padding: cellPadding,
          child: Text(item.formatTime(), style: const TextStyle(fontSize: 16)),
        ),
        Padding(
          padding: cellPadding,
          child: Text(item.title,
              style: const TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 118, 118, 118))),
        ),
      ]));
    }
    return Table(columnWidths: const <int, TableColumnWidth>{
      0: FixedColumnWidth(160),
      1: FlexColumnWidth(),
    }, children: rows);
  }
}
