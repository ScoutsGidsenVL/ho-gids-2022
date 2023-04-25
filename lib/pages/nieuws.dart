import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ho_gids/model/dynamic_data.dart';
import 'package:ho_gids/model/time_manager.dart';
import 'package:ho_gids/widgets/news_list.dart';
import 'package:provider/provider.dart';

class Nieuws extends StatelessWidget {
  const Nieuws({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final news = context.watch<DynamicData>().news ?? [];
    final timeManager = context.watch<TimeManager>();

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
      body: NewsList(news),
    );
  }
}


/*


ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text('Jaarlied'),
              onTap: () {
                context.beamToNamed('/nieuws/jaarlied');
              }),
          ListTile(
              leading: const Icon(Icons.near_me),
              title: const Text('Praktisch'),
              onTap: () {
                context.beamToNamed('/nieuws/praktisch');
              }),
          ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Leefregels'),
              onTap: () {
                context.beamToNamed('/nieuws/leefregels');
              }),
              */
