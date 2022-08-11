import 'package:flutter/material.dart';
import 'package:ho_gids/widgets/nav_drawer.dart';

class Programma extends StatelessWidget {
  const Programma({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programma'),
      ),
      drawer: const NavDrawer(),
      body: const Center(
        child: Text('Programma!'),
      ),
    );
  }
}
