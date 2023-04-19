import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class Nieuws extends StatelessWidget {
  const Nieuws({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HO-Gids'),
      ),
      body: ListView(
        children: [
          ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text('Jaarlied'),
              onTap: () {
                context.beamToNamed('/jaarlied');
              }),
          ListTile(
              leading: const Icon(Icons.near_me),
              title: const Text('Praktisch'),
              onTap: () {
                context.beamToNamed('/praktisch');
              }),
          ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Leefregels'),
              onTap: () {
                context.beamToNamed('/leefregels');
              }),
        ],
      ),
    );
  }
}
