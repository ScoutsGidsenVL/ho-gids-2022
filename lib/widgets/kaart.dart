import 'package:flutter/material.dart';
import 'package:ho_gids/widgets/nav_drawer.dart';

class Kaart extends StatelessWidget {
  const Kaart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kaart'),
      ),
      drawer: const NavDrawer(),
      body: const Center(
        child: Text('Kaart!'),
      ),
    );
  }
}
