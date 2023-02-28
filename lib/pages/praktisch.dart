import 'package:flutter/material.dart';
import 'package:ho_gids/widgets/nav_drawer.dart';

class Praktisch extends StatelessWidget {
  const Praktisch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(fontSize: 20);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Praktisch'),
        ),
        drawer: const NavDrawer(),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10),
          children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Infopunt (Grote Grond)', style: headerStyle),
                    Text(
                        ' \u2022 voor al je vragen\n \u2022 verloren voorwerpen melden of brengen\n\nTelefonisch bereikbaar op +32 477 38 24 12',
                        style: TextStyle(height: 1.2)),
                  ],
                )),
            const Divider(thickness: 4),
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Noodgevallen', style: headerStyle),
                      Text('Verwittig de hulpdiensten niet zelf!',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 118, 118, 118))),
                      Text(
                          '\nZit je met iets? Voel je je onveilig? Wil je een bezorgdheid delen? Bel dan het noodnummer: 0474 26 14 01\n\n \u2022 Kleine ongelukjes: Rode kruis in gebouw 39\n \u2022 Nood en ramp: 0474 26 14 01',
                          style: TextStyle(height: 1.2)),
                    ])),
            const Divider(thickness: 4),
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Barinfo', style: headerStyle),
                      Text(
                          ' \u2022 De bar op de grote grond sluit om 02.00\n \u2022 De bar van het Zeescoutscafé sluit om 01.30\n \u2022 De bar van het Hoppercafé sluit om 01.30',
                          style: TextStyle(height: 1.2)),
                    ])),
            const Divider(thickness: 4),
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Gouw gronden', style: headerStyle),
                      Table(columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(),
                        1: FlexColumnWidth(),
                      }, children: <TableRow>[
                        item(name: 'Antwerpen', place: 'Kamp 8 Zuid'),
                        item(name: 'Heide', place: 'Kamp 42'),
                        item(name: 'Opsinjoor', place: 'Kamp 10'),
                        item(name: 'Kempen', place: 'Kamp 41'),
                        item(name: 'Webra', place: 'Kamp 8 Noord'),
                        item(name: 'Oost-Brabant', place: 'Kamp 48 Oost'),
                        item(name: 'Limburg', place: 'Kamp 9'),
                        item(name: 'Gent', place: 'Kamp 48 West'),
                        item(name: 'Land van Egmont', place: 'Kamp 49 Zuid'),
                        item(name: 'Waas', place: 'Kamp 7 Noord'),
                        item(name: 'Noordzee', place: 'Kamp 49 Noord'),
                        item(
                            name: 'Zuid-West-Vlaanderen', place: 'Kamp 7 Zuid'),
                      ]),
                    ])),
            const Divider(thickness: 4),
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Vormingsaanbod zaterdag', style: headerStyle),
                      Table(columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(),
                        1: FlexColumnWidth(),
                      }, children: <TableRow>[
                        item(name: 'Kapoenen', place: 'Kamp 30'),
                        item(name: 'Welpen - Kabouters', place: 'Kamp 33'),
                        item(
                            name: 'Jonggidsen - Jongverkenners',
                            place: 'Kamp 34'),
                        item(name: 'Jins', place: 'Rond vijver'),
                        item(
                            name:
                                'Groepsleiding (+ lokalen, financien en groepsadministratie)',
                            place: 'Grote grond + gebouw 11'),
                        item(name: 'Zeescouting', place: 'Vijver'),
                        item(
                            name: 'Akabe',
                            place: 'Kleine grond + loods kamp 30'),
                        item(
                            name: 'Safety First (Rode Kruis)',
                            place: 'Grote tent op grote grond'),
                        item(
                            name: 'Spel en actie',
                            place: 'Rond de kampvuurkring + grote grond'),
                        item(
                            name: 'Technieken',
                            place: 'Grote grond rond kampvuur'),
                        item(
                            name: 'Help ik stop als leiding',
                            place: 'Naast gebouw 9'),
                      ]),
                    ])),
          ],
        ));
  }
}

TableRow item({required String name, required String place}) {
  return TableRow(children: [
    Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(name,
          style: const TextStyle(
              fontSize: 16, color: Color.fromARGB(255, 118, 118, 118))),
    ),
    Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(place, style: const TextStyle(fontSize: 16)),
    ),
  ]);
}
