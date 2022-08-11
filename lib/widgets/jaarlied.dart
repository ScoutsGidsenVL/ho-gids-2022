import 'package:flutter/material.dart';
import 'package:ho_gids/widgets/nav_drawer.dart';

class Jaarlied extends StatelessWidget {
  const Jaarlied({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jaarlied'),
      ),
      drawer: const NavDrawer(),
      body: const Center(
        child: Text('Jaarlied!'),
      ),
    );
  }
}
