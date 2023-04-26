import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ho_gids/model/dynamic_data.dart';
import 'package:ho_gids/model/time_manager.dart';
import 'package:ho_gids/widgets/news_list.dart';
import 'package:provider/provider.dart';

class Nieuws extends StatelessWidget {
  final bool? includeArchive;

  const Nieuws({Key? key, this.includeArchive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final news = context.watch<DynamicData>().news ?? [];
    final timeManager = context.watch<TimeManager>();
    final allPublished = news.where((n) => n.isPublished(timeManager.now()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('HO-Gids'),
        actions: [
          if (kDebugMode)
            IconButton(
                onPressed: () async {
                  final date = await showDatePicker(
                      context: context,
                      initialDate: timeManager.nowOverride ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2024),
                      locale: const Locale('nl', 'BE'));
                  if (date == null) return;
                  // ignore: use_build_context_synchronously
                  final time = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  if (time == null) return;
                  timeManager.setOverride(DateTime(
                      date.year, date.month, date.day, time.hour, time.minute));
                },
                icon: const Icon(Icons.today))
        ],
      ),
      body: allPublished.isEmpty
          ? const Center(child: Text('Nog geen nieuws...'))
          : NewsList(news, includeArchive: includeArchive),
    );
  }
}
