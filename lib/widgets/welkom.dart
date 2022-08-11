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
      body: const Center(
        child: Text('Welkom!'),
      ),
    );
  }
}
