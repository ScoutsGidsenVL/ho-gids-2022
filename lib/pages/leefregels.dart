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
        body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 10),
            children: [
              Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(children: const [
                    Text(
                        'We rekenen erop dat jullie de wijsheid hebben om volgende acht vuistregels op te volgen.\n'),
                    Image(image: AssetImage('assets/images/leefregels.png')),
                    Text(
                        '\nDoor je in te schrijven voor Herfstontmoeting, ga je akkoord met de leefregels. Overtreed je de leefregels, dan zal er een sanctie en natraject volgen.')
                  ]))
            ]));
  }
}
