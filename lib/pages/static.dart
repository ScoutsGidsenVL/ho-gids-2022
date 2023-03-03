import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/material.dart';
import 'package:ho_gids/model/dynamic_data.dart';
import 'package:ho_gids/util.dart';
import 'package:ho_gids/widgets/nav_drawer.dart';
import 'package:provider/provider.dart';

class Static extends StatelessWidget {
  const Static({super.key, required this.path, required this.title});

  final String path;
  final String title;

  @override
  Widget build(BuildContext context) {
    var body = context.watch<DynamicData>().text[path];
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        drawer: const NavDrawer(),
        body: Markdown(
            data: body ?? '',
            styleSheet: markdownStyle(context),
            onTapLink: linkHandler(context)));
  }
}
