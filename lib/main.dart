import 'package:flutter/material.dart';
import 'package:hogids/model/dynamic_data.dart';
import 'package:hogids/model/notification_manager.dart';
import 'package:hogids/model/time_manager.dart';
import 'package:hogids/pages/developer.dart';
import 'package:hogids/pages/nieuws.dart';
import 'package:hogids/pages/kaart.dart';
import 'package:hogids/pages/programma.dart';
import 'package:hogids/pages/artikel.dart';
import 'package:provider/provider.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';

final List<TabInfo> tabs = [
  TabInfo(
    title: 'Nieuws',
    icon: const Icon(Icons.home),
    path: '/nieuws',
    locationBuilder: (info, params) {
      return NieuwsLocation(info);
    },
  ),
  TabInfo(
    title: 'Programma',
    icon: const Icon(Icons.calendar_today),
    path: '/programma',
    locationBuilder: (info, params) {
      return ProgrammaLocation(info);
    },
  ),
  TabInfo(
    title: 'Kaart',
    icon: const Icon(Icons.map),
    path: '/kaart',
    locationBuilder: (info, params) {
      return KaartLocation(info);
    },
  ),
];

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Future.delayed(const Duration(milliseconds: 600)).then((_) {
    FlutterNativeSplash.remove();
  });
  await FlutterMapTileCaching.initialise();
  FMTC.instance('mapStore').manage.create();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final routerDelegate = BeamerDelegate(
      initialPath: '/nieuws',
      locationBuilder: RoutesLocationBuilder(routes: {
        '*': (context, state, data) => const ScaffoldWithNavBar(),
      }));

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DynamicData()),
        ChangeNotifierProvider(create: (_) => TimeManager()),
        ChangeNotifierProxyProvider2<DynamicData, TimeManager,
            NotificationManager>(
          lazy: false,
          create: (_) => NotificationManager(),
          update: (_, dynamicData, timeManager, prev) =>
              prev!..update(dynamicData, timeManager),
        )
      ],
      child: MaterialApp.router(
        title: 'HO-gids',
        theme: ThemeData(
            colorScheme: const ColorScheme.light(
                primary: Color.fromRGBO(72, 130, 127, 1),
                secondary: Color.fromRGBO(197, 227, 232, 1),
                tertiary: Color.fromRGBO(227, 47, 43, 1))),
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [Locale('nl')],
        routerDelegate: routerDelegate,
        routeInformationParser: BeamerParser(),
        backButtonDispatcher: BeamerBackButtonDispatcher(
            delegate: routerDelegate, fallbackToBeamBack: false),
      ),
    );
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
              .map((t) => BottomNavigationBarItem(icon: t.icon, label: t.title))
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
  final Widget icon;
  final String path;
  final BeamLocation<RouteInformationSerializable<dynamic>> Function(
      RouteInformation info, BeamParameters? params) locationBuilder;
}

class NieuwsLocation extends BeamLocation<BeamState> {
  NieuwsLocation(super.info);
  @override
  List<String> get pathPatterns => ['/nieuws/*'];
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        BeamPage(
          key: ValueKey(
              'nieuws${state.uri.queryParameters['archive'] == 'true' ? '-archive' : ''}'),
          child: Nieuws(
              includeArchive: state.uri.queryParameters['archive'] == 'true'),
        ),
        if (state.uri.pathSegments.length == 2 &&
            state.uri.pathSegments[1] == 'developer')
          const BeamPage(key: ValueKey('nieuws/developer'), child: Developer())
        else if (state.uri.pathSegments.length == 2)
          BeamPage(
            key: ValueKey('nieuws/${state.uri.pathSegments[1]}'),
            type: BeamPageType.noTransition,
            child: Artikel(
                path: state.uri.pathSegments[1],
                title: (context.read<DynamicData>().news ?? [])
                    .firstWhere((n) => n.body == state.uri.pathSegments[1])
                    .title),
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
        BeamPage(
          key: const ValueKey('kaart'),
          child: Kaart(id: state.uri.queryParameters['id']),
        ),
      ];
}
