import 'package:flutter/material.dart';
import 'package:ho_gids/widgets/nav_drawer.dart';

class Jaarlied extends StatelessWidget {
  const Jaarlied({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Jaarlied: DAS Goesting'),
        ),
        drawer: const NavDrawer(),
        body: ListView(
          children: [
            Container(
                padding: const EdgeInsets.all(20),
                child: const Text(
                    'Ogen open, een knotsgekke dag voor de boeg.\nDe tent uit haasten want starten doen we voor mij\nnooit te vroeg. Hier kan ik echt gewoon mezelf zijn\nJa bij de scouts, daar is het toch zo fijn.\n\nEn zeg jij eens, wat geeft jou energie?\nVan alles leren en spelen met veel fantasie.\nEn wat met buiten zijn, vrienden om je heen\nDa’s wat ik wil doen en nu meteen.\n\nAh dan is de scouts de optie! Waar ik mezelf mag zijn!\nSamen spelen, altijd actie. Scouting mijn terrein.\n\nVan kapoen tot bij de leiding, je volgt je eigen reis\nIeder weekend weer een reden om jezelf te zijn.\nEen spel met eigen regels, leren van elkaar.\nElk talent is hier inzetbaar. Ja, kies je eigen ding\nDAS Goesting.\n\nMet onze das aan vertrekken we op avontuur.\nEn ’s avonds in een kring staren we in het vuur.\nWat een topmoment, + vrienden om ons heen.\nDit is de mooiste tijd voor iedereen!\n\nJa de scouts, dat is de plaats waar je uniek kan zijn.\nDromen sjorren, wees paraat ja. Scouting ons terrein.\n\nVan kapoen tot bij de leiding, we volgen onze reis\nIeder weekend weer een reden om onszelf te zijn.\nEen spel met eigen regels, leren van elkaar.\nElk talent is hier inzetbaar. We kiezen ons eigen ding.\n\nDAS Goesting, DAS Goesting, DAS Goesting, Ja DAS Goesting. DAS Goesting, DAS Goesting, DAS Goesting, Ja DAS Goesting\n\nVan kapoen tot bij de leiding, we volgen onze reis\nIeder weekend weer een reden om onszelf te zijn.\nEen spel met eigen regels, leren van elkaar\nElk talent is hier inzetbaar. We kiezen ons eigen ding\nDAS Goesting\n\nKampen bouwen (DAS goesting)\nScoutshemd aan (DAS goesting)\nLeiding geven (DAS goesting)\nWhoa Oh Oh Oh\n\nBij de scouts (DAS goesting)\nNiet voor even (DAS goesting)\n’t Is gewoon (DAS goesting)\nVoor het leven. DAS Goesting!',
                    style: TextStyle(fontSize: 15))),
            Container(
              padding: const EdgeInsets.all(20),
              child: const Text(
                  'TEKST - Jarno Noblesse, Anton Maes\nMUZIEK - Jarno Noblesse, Anton Maes, Tom Laisnez, Toon Janssens, Jasper Beekens, Kiran Van Duck, Matthew Dops en Wout Gielen\nZANG - Jarno Noblesse, Anneleen Torfs, Bjoke Gijsen, Babs Gijsen, Fien Delwiche en Machteld van Pottelbergh',
                  style: TextStyle(color: Color.fromARGB(255, 118, 118, 118))),
            )
          ],
        ));
  }
}
