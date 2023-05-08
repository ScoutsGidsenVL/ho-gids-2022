import 'package:flutter/material.dart';
import 'package:hogids/model/notification_manager.dart';
import 'package:hogids/model/time_manager.dart';
import 'package:provider/provider.dart';

// Disable when publishing
const canChangeClock = true;

class Developer extends StatelessWidget {
  final bool? includeArchive;

  const Developer({Key? key, this.includeArchive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeManager = context.watch<TimeManager>();
    final notificationManager = context.watch<NotificationManager>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Developer instellingen'),
        ),
        body: ListView(
          children: [
            ListTile(
                onTap: () async {
                  final date = await showDatePicker(
                      context: context,
                      initialDate: timeManager.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2024),
                      locale: const Locale('nl', 'BE'));
                  if (date == null) return;
                  // ignore: use_build_context_synchronously
                  final time = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  if (time == null) return;
                  timeManager.setNowOverride(DateTime(
                      date.year, date.month, date.day, time.hour, time.minute));
                },
                leading: const Icon(Icons.today),
                title: const Text('Klok overschrijven'),
                subtitle: Text(timeManager.now().toString()),
                trailing: timeManager.nowOverride == null
                    ? null
                    : IconButton(
                        onPressed: () {
                          timeManager.setNowOverride(null);
                        },
                        icon: const Icon(Icons.undo))),
            ListTile(
                onTap: () async {
                  final date = await showDatePicker(
                      context: context,
                      initialDate: timeManager.startDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2024),
                      locale: const Locale('nl', 'BE'));
                  if (date == null) return;
                  timeManager.setStartOverride(
                      DateTime(date.year, date.month, date.day));
                },
                leading: const Icon(Icons.today),
                title: const Text('Start HO (vrijdag)'),
                subtitle: Text(timeManager.startDate.toString()),
                trailing: timeManager.startDate == TimeManager.defaultStart
                    ? null
                    : IconButton(
                        onPressed: () {
                          timeManager.setStartOverride(null);
                        },
                        icon: const Icon(Icons.undo))),
            ListTile(
              onTap: () async {
                notificationManager.scheduleNotifications();
              },
              leading: const Icon(Icons.notifications),
              title: const Text('Meldingen opnieuw inplannen'),
            )
          ],
        ));
  }
}
