import 'package:flutter/material.dart';
import 'package:ho_gids/widgets/nav_drawer.dart';

class Welkom extends StatelessWidget {
  const Welkom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('HO-gids'),
        ),
        drawer: const NavDrawer(),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/jo-deman-avatar.png'),
                  minRadius: 24,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Welkom op HO!', style: TextStyle(fontSize: 20)),
                    Text('van de verbondscommissaris'),
                  ],
                )
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              child: const Text(
                  'Beste Scoutsend en Gidsend Vlaanderen,\n\nWe mogen weer! Twee jaar lang was het verdacht stil op de Hoge Rielen, maar nu gaan we weer voor een volwaardige HO. Eentje met alles erop en eraan: een stevige dosis inspiratie, een overvloed aan vorming en (ont)spannende ontmoetingen.\n\nHerfstontmoeting is een unieke opportuniteit om te ontdekken hoe groot, divers en tegelijk verbonden onze beweging kan zijn. Samen bewijzen we dat het meest besmettelijke in de wereld niet een virus is, maar wel ons gedeeld aanstekelijk enthousiasme voor Scouting.\n\nHerfstontmoeting is het startschot voor een nieuw scoutsjaar, hét moment om energie en inspiratie op te doen om opnieuw een jaar lang het beste van jezelf te geven als leiding. Een boostershot aan Zin in Scouting.\n\nLaat deze gids je goesting geven om HO te ontdekken, laat HO je brandend vuur voor Scouting aanwakkeren en laat je een weekend lang onderdompelen in het nieuwe jaarthema, DAS Goesting\n\nIk hoop dat jullie ontdekken, leren, connecteren en genieten van Herfstontmoeting en er net zoveel ZIN in hebben als wij!\n\nSteevast met een stevige linker,\n\nJo Deman,\nJullie Verbondscommissaris'),
            ),
            const Image(
              image: AssetImage('assets/images/dasgoesting.jpg'),
              height: 300,
            ),
          ],
        ));
  }
}
