import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:ho_gids/model/calendar_data.dart';
import 'package:ho_gids/model/time_manager.dart';
import 'package:provider/provider.dart';

class CalendarEntry extends StatelessWidget {
  const CalendarEntry(this.item, {super.key});

  final CalendarItemData item;

  @override
  Widget build(BuildContext context) {
    final clock = context.watch<TimeManager>().now();
    final hasPassed = item.hasPassed(clock);
    final isHappening = item.isHappening(clock);

    return ListTile(
      onTap: () {
        if (item.location != null) {
          Beamer.of(context, root: true)
              .beamToNamed('/kaart?id=${item.location}', beamBackOnPop: true);
        }
      },
      shape: isHappening
          ? Border(
              left: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 6))
          : null,
      contentPadding: EdgeInsets.only(left: isHappening ? 10 : 16, right: 16),
      leading: SizedBox(
        width: 120,
        child: Text(item.formatTimeRange(),
            style: TextStyle(
                color: hasPassed ? Colors.grey : null,
                fontSize: 16,
                fontWeight: isHappening ? FontWeight.bold : null)),
      ),
      title: Text(item.title,
          style: TextStyle(
              color: hasPassed ? Colors.grey : null,
              fontWeight: isHappening ? FontWeight.bold : null)),
    );
  }
}
