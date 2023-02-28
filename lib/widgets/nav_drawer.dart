
import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/cover.jpg'))),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'HO-gids',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                )),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Welkom'),
            onTap: () => {Navigator.of(context).popUntil((r) => r.isFirst)},
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Programma'),
            onTap: () => {Navigator.of(context).popAndPushNamed('/programma')},
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Kaart'),
            onTap: () => {Navigator.of(context).popAndPushNamed('/kaart')},
          ),
          ListTile(
            leading: const Icon(Icons.music_note),
            title: const Text('Jaarlied'),
            onTap: () => {Navigator.of(context).popAndPushNamed('/jaarlied')},
          ),
          ListTile(
            leading: const Icon(Icons.near_me),
            title: const Text('Praktisch'),
            onTap: () => {Navigator.of(context).popAndPushNamed('/praktisch')},
          ),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Leefregels'),
            onTap: () => {Navigator.of(context).popAndPushNamed('/leefregels')},
          ),
        ],
      ),
    );
  }
}
