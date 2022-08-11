import 'package:flutter/material.dart';
import 'package:ho_gids/widgets/nav_drawer.dart';

class Programma extends StatelessWidget {
  const Programma({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Programma'),
              bottom: const TabBar(tabs: [
                Tab(text: 'Vrijdag'),
                Tab(text: 'Zaterdag'),
                Tab(text: 'Zondag'),
              ]),
            ),
            drawer: const NavDrawer(),
            body: TabBarView(
              children: [
                ListView(children: [
                  Table(columnWidths: const <int, TableColumnWidth>{
                    0: FixedColumnWidth(130),
                    1: FlexColumnWidth(),
                  }, children: <TableRow>[
                    item(time: '19.00', name: 'Aankomst'),
                    item(time: '22.00-22.30', name: 'Installeren & onthaal'),
                    item(
                        time: '23.00',
                        name: 'Start! Openingsshow & scouteske avond'),
                    item(time: '23.00-23.15', name: 'Opwarmer'),
                    item(time: '23.15-0.00', name: 'Openingsshow'),
                    item(time: '0.00-1.45', name: 'Scouteske karaoke'),
                    item(time: '0.00-1.45', name: 'Pijl en boog'),
                    item(time: '0.10-0.50', name: 'Jaarliedband'),
                    item(time: '1.00-2.00', name: 'DJ Battle'),
                    item(time: '2.00-2.30', name: 'Slaapwel'),
                  ])
                ]),
                ListView(children: [
                  Table(columnWidths: const <int, TableColumnWidth>{
                    0: FixedColumnWidth(130),
                    1: FlexColumnWidth(),
                  }, children: <TableRow>[
                    item(time: '8.30-9.30', name: 'Opstaan & ontbijten'),
                    item(
                        time: '10.00-13.00',
                        name: 'Goesting in inspiratie & goesting in actie'),
                    item(
                        time: '13.00-15.00',
                        name: 'Eten & show op de grote grond'),
                    item(
                        time: '15.00-18.00', name: 'Marktje op de grote grond'),
                    item(
                        time: '18.00-22.00',
                        name: 'District/gouwmoment & eten op de gouwgrond'),
                    item(time: '23.00-23.40', name: 'Winnaar DJ Battle'),
                    item(time: '23.15-1.45', name: 'Scouteske karaoke'),
                    item(time: '23.15-0.15', name: 'The Attic'),
                    item(time: '23.50-0.50', name: 'Simon Collective'),
                    item(time: '00.45-1.45', name: 'Nancy\'s Neighbours'),
                    item(time: '1.00-2.00', name: 'DJ Alles Kapot'),
                    item(time: '2.00-2.30', name: 'Slaapwel'),
                  ])
                ]),
                ListView(children: [
                  Table(columnWidths: const <int, TableColumnWidth>{
                    0: FixedColumnWidth(130),
                    1: FlexColumnWidth(),
                  }, children: <TableRow>[
                    item(time: '8.30-9.30', name: 'Opstaan & ontbijten'),
                    item(time: '9.30-11.00', name: 'Opruimen & afbraak'),
                    item(
                        time: '11.30-12.30',
                        name: 'Verrassingsact vol goesting'),
                    item(time: '12.30-13.00', name: 'Lunch op de grote grond'),
                    item(time: '13.00', name: 'Einde HO'),
                  ]),
                ]),
              ],
            )));
  }
}

TableRow item({required String time, required String name}) {
  return TableRow(children: [
    Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Text(time, style: const TextStyle(fontSize: 16)),
    ),
    Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Text(name,
          style: const TextStyle(
              fontSize: 16, color: Color.fromARGB(255, 118, 118, 118))),
    ),
  ]);
}
