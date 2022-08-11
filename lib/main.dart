import 'package:flutter/material.dart';
import 'package:ho_gids/widgets/contact.dart';
import 'package:ho_gids/widgets/welkom.dart';
import 'package:ho_gids/widgets/jaarlied.dart';
import 'package:ho_gids/widgets/kaart.dart';
import 'package:ho_gids/widgets/leefregels.dart';
import 'package:ho_gids/widgets/praktisch.dart';
import 'package:ho_gids/widgets/programma.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'HO-gids',
        theme: ThemeData(
            primaryColor: const Color.fromRGBO(72, 130, 127, 1),
            primarySwatch: const MaterialColor(0xff48827f, <int, Color>{
              50: Color.fromRGBO(72, 130, 127, 1),
              100: Color.fromRGBO(72, 130, 127, 1),
              200: Color.fromRGBO(72, 130, 127, 1),
              300: Color.fromRGBO(72, 130, 127, 1),
              400: Color.fromRGBO(72, 130, 127, 1),
              500: Color.fromRGBO(72, 130, 127, 1),
              600: Color.fromRGBO(72, 130, 127, 1),
              700: Color.fromRGBO(72, 130, 127, 1),
              800: Color.fromRGBO(72, 130, 127, 1),
              900: Color.fromRGBO(72, 130, 127, 1),
            })),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => const Welkom(),
          '/programma': (context) => const Programma(),
          '/kaart': (context) => const Kaart(),
          '/jaarlied': (context) => const Jaarlied(),
          '/praktisch': (context) => const Praktisch(),
          '/leefregels': (context) => const Leefregels(),
          '/contact': (context) => const Contact(),
        });
  }
}
