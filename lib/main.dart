import 'package:flutter/material.dart';
import 'package:ho_gids/model/dynamic_data.dart';
import 'package:ho_gids/pages/nieuws.dart';
import 'package:ho_gids/pages/kaart.dart';
import 'package:ho_gids/pages/programma.dart';
import 'package:ho_gids/pages/static.dart';
import 'package:provider/provider.dart';
import 'package:beamer/beamer.dart';

final List<TabInfo> tabs = [
  TabInfo(
    title: 'Nieuws',
    icon: (_) => const Icon(Icons.home),
    path: '/',
    locationBuilder: (info, params) {
      return NieuwsLocation(info);
    },
  ),
  TabInfo(
    title: 'Programma',
    icon: (_) => const Icon(Icons.calendar_today),
    path: '/programma',
    locationBuilder: (info, params) {
      return ProgrammaLocation(info);
    },
  ),
  TabInfo(
    title: 'Kaart',
    icon: (_) => const Icon(Icons.map),
    path: '/kaart',
    locationBuilder: (info, params) {
      return KaartLocation(info);
    },
  ),
];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final routerDelegate = BeamerDelegate(
      initialPath: '/',
      locationBuilder: RoutesLocationBuilder(routes: {
        '*': (context, state, data) => const ScaffoldWithNavBar(),
      }));

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => DynamicData(),
        child: MaterialApp.router(
          title: 'HO-gids',
          theme: ThemeData(
              colorScheme: const ColorScheme.light(
                  primary: Color.fromRGBO(72, 130, 127, 1),
                  secondary: Color.fromRGBO(197, 227, 232, 1),
                  tertiary: Color.fromRGBO(227, 47, 43, 1))),
          routerDelegate: routerDelegate,
          routeInformationParser: BeamerParser(),
          backButtonDispatcher: BeamerBackButtonDispatcher(
              delegate: routerDelegate, fallbackToBeamBack: false),
        ));
  }
}

class ScaffoldWithNavBar extends StatefulWidget {
  const ScaffoldWithNavBar({super.key});

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  late int _currentIndex;

  final _routerDelegates = tabs
      .map((t) => BeamerDelegate(
          initialPath: t.path,
          locationBuilder: (info, params) {
            if (info.location!.contains(t.path)) {
              return t.locationBuilder(info, params);
            }
            return NotFound(path: info.location!);
          }))
      .toList();

  BeamerDelegate get currentDelegate => _routerDelegates[_currentIndex];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final location = Beamer.of(context).configuration.location!;
    final index = tabs.lastIndexWhere((tab) => location.startsWith(tab.path));
    _currentIndex = index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var popped = await currentDelegate.popRoute();
        if (popped) return false;
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          currentDelegate.update(rebuild: false);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: _currentIndex,
            children: _routerDelegates
                .map((delegate) => Beamer(routerDelegate: delegate))
                .toList(),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: tabs
              .map((t) => BottomNavigationBarItem(
                  icon: t.icon(context), label: t.title))
              .toList(),
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index != _currentIndex) {
              setState(() => _currentIndex = index);
              currentDelegate.update(rebuild: false);
            } else {
              currentDelegate.popToNamed(tabs[_currentIndex].path);
            }
          },
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class TabInfo {
  const TabInfo({
    required this.title,
    required this.icon,
    required this.path,
    required this.locationBuilder,
  });

  final String title;
  final Widget Function(BuildContext context) icon;
  final String path;
  final BeamLocation<RouteInformationSerializable<dynamic>> Function(
      RouteInformation info, BeamParameters? params) locationBuilder;
}

class NieuwsLocation extends BeamLocation<BeamState> {
  NieuwsLocation(super.info);
  @override
  List<String> get pathPatterns => ['/'];
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('nieuws'),
          child: Nieuws(),
        ),
        if (state.uri.path.startsWith('/jaarlied'))
          const BeamPage(
            key: ValueKey('jaarlied'),
            child: Static(path: 'jaarlied', title: 'Jaarlied'),
          ),
        if (state.uri.path.startsWith('/praktisch'))
          const BeamPage(
            key: ValueKey('praktisch'),
            child: Static(path: 'praktisch', title: 'Praktisch'),
          ),
        if (state.uri.path.startsWith('/leefregels'))
          const BeamPage(
            key: ValueKey('leefregels'),
            child: Static(path: 'leefregels', title: 'Leefregels'),
          ),
      ];
}

class ProgrammaLocation extends BeamLocation<BeamState> {
  ProgrammaLocation(super.info);
  @override
  List<String> get pathPatterns => ['/programma'];
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('programma'),
          child: Programma(),
        ),
      ];
}

class KaartLocation extends BeamLocation<BeamState> {
  KaartLocation(super.info);
  @override
  List<String> get pathPatterns => ['/kaart'];
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('kaart'),
          child: Kaart(),
        ),
      ];
}
