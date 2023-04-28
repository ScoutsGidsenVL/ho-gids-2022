import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ho_gids/model/calendar_data.dart';
import 'package:ho_gids/model/dynamic_data.dart';
import 'package:ho_gids/model/time_manager.dart';
import 'package:ho_gids/widgets/calendar_tab.dart';
import 'package:provider/provider.dart';

const tabs = ['Vrijdag', 'Zaterdag', 'Zondag'];

class Programma extends StatefulWidget {
  const Programma({Key? key}) : super(key: key);

  @override
  State<Programma> createState() => _ProgrammaState();
}

class _ProgrammaState extends State<Programma>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int activeTab = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final calendar = context.watch<DynamicData>().calendar;
    final clock = context.watch<TimeManager>().now();

    final newActiveTab = calendar?.indexWhere((tab) {
          return tab.items.any((item) => item.isHappening(clock));
        }) ??
        -1;
    if (newActiveTab != -1 && newActiveTab != activeTab) {
      tabController.animateTo(newActiveTab);
      activeTab = newActiveTab;
    }

    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
            appBar: AppBar(
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TabBar(
                      controller: tabController,
                      tabs: tabs.map((label) => Tab(text: label)).toList(),
                      indicatorColor: Theme.of(context).colorScheme.secondary)
                ],
              ),
            ),
            body: TabBarView(
              controller: tabController,
              children: tabs
                  .mapIndexed((i, label) => CalendarTab(
                      tab: calendar == null
                          ? CalendarTabData(label, [])
                          : calendar[i]))
                  .toList(),
            )));
  }
}
