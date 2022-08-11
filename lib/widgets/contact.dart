import 'package:flutter/material.dart';
import 'package:ho_gids/widgets/nav_drawer.dart';

class Contact extends StatelessWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact'),
      ),
      drawer: const NavDrawer(),
      body: const Center(
        child: Text('Contact!'),
      ),
    );
  }
}
