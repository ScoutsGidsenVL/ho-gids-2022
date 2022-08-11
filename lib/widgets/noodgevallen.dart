import 'package:flutter/material.dart';

class Noodgevallen extends StatelessWidget {
  const Noodgevallen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(fontSize: 20);

    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Noodgevallen', style: headerStyle),
              Text('Verwittig de hulpdiensten niet zelf!',
                  style: TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 118, 118, 118))),
              Text(
                  '\nZit je met iets? Voel je je onveilig? Wil je een bezorgdheid delen? Bel dan het noodnummer: 0474 26 14 01\n\n \u2022 Kleine ongelukjes: Rode kruis in gebouw 39\n \u2022 Nood en ramp: 0474 26 14 01',
                  style: TextStyle(height: 1.2)),
            ]));
  }
}
