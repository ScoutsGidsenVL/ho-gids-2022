import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ho_gids/model/dynamic_data.dart';
import 'package:ho_gids/util.dart';
import 'package:ho_gids/widgets/nav_drawer.dart';
import 'package:provider/provider.dart';

class Welkom extends StatelessWidget {
  const Welkom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var body = context.watch<DynamicData>().text['welkom'] ?? '';

    return Scaffold(
        appBar: AppBar(
          title: const Text('HO-gids'),
        ),
        drawer: const NavDrawer(),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      const AssetImage('assets/images/jo-deman-avatar.png'),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  minRadius: 24,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Welkom op HO!', style: TextStyle(fontSize: 20)),
                    Text('van de verbondscommissaris'),
                  ],
                )
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              child: MarkdownBody(
                  data: body,
                  styleSheet: markdownStyle(context),
                  onTapLink: linkHandler(context)),
            ),
            const Image(
              image: AssetImage('assets/images/dasgoesting.jpg'),
              height: 300,
            ),
          ],
        ));
  }
}
