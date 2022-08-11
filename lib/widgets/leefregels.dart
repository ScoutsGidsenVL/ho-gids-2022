import 'package:flutter/material.dart';
import 'package:ho_gids/widgets/nav_drawer.dart';

class Leefregels extends StatelessWidget {
  const Leefregels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leefregels'),
      ),
      drawer: const NavDrawer(),
      body: const Center(
        child: Text('Leefregels!'),
      ),
    );
  }
}
