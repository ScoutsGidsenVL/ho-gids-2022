import 'package:flutter/material.dart';
import 'package:ho_gids/widgets/nav_drawer.dart';

class Praktisch extends StatelessWidget {
  const Praktisch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktisch'),
      ),
      drawer: const NavDrawer(),
      body: const Center(
        child: Text('Praktisch!'),
      ),
    );
  }
}
