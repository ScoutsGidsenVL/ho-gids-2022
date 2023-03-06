import 'package:flutter/material.dart';
import 'package:ho_gids/model/dynamic_data.dart';
import 'package:ho_gids/pages/static.dart';
import 'package:ho_gids/pages/welkom.dart';
import 'package:ho_gids/pages/kaart.dart';
import 'package:ho_gids/pages/programma.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => DynamicData(),
        child: MaterialApp(
            title: 'HO-gids',
            theme: ThemeData(
                colorScheme: const ColorScheme.light(
              primary: Color.fromRGBO(72, 130, 127, 1),
              secondary: Color.fromRGBO(197, 227, 232, 1),
              tertiary: Color.fromRGBO(227, 47, 43, 1),
            )),
            initialRoute: '/',
            routes: <String, WidgetBuilder>{
              '/': (context) => const Welkom(),
              '/programma': (context) => const Programma(),
              '/kaart': (context) => const Kaart(),
              '/jaarlied': (context) =>
                  const Static(path: 'jaarlied', title: 'Jaarlied'),
              '/praktisch': (context) =>
                  const Static(path: 'praktisch', title: 'Praktisch'),
              '/leefregels': (context) =>
                  const Static(path: 'leefregels', title: 'Leefregels'),
            }));
  }
}
