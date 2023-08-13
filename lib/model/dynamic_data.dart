import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hogids/model/calendar_data.dart';
import 'package:hogids/model/map_data.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hogids/model/news_data.dart';
import 'package:package_info_plus/package_info_plus.dart';

const dataRepo = 'https://raw.githubusercontent.com/ScoutsGidsenVL/ho-gids-2022';

class DynamicData extends ChangeNotifier {
  late Timer timer;
  bool experimentalContent = false;
  PackageInfo? packageInfo;
  List<MapFeature>? annotations;
  List<CalendarTabData>? calendar;
  List<NewsItemData>? news;
  Map<String, String> text = {};

  DynamicData() {
    refreshData();
    timer = Timer.periodic(const Duration(minutes: 30), (timer) {
      refreshData();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void setExperimentalContent(bool value) {
    experimentalContent = value;
    notifyListeners();
    refreshData();
  }

  Future refreshData() async {
    await refreshNewsData();
    await Future.wait([
      getPackageInfo(),
      refreshMapData(),
      refreshCalendarData(),
      ...news?.where((n) => n.body != null).map((n) => refreshText(n.body!)) ??
          [],
    ]);
    notifyListeners();
  }

  Future getPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  Future refreshMapData() async {
    var source = await fetchAsset('content/kaart.json');
    var data = await json.decode(source);
    annotations = MapAnnotations.fromJson(data).features;
  }

  Future refreshCalendarData() async {
    var source = await fetchAsset('content/programma.json');
    var data = await json.decode(source);
    calendar = CalendarData.fromJson(data).tabs;
  }

  Future refreshNewsData() async {
    var source = await fetchAsset('content/nieuws.json');
    var data = await json.decode(source);
    news = NewsData.fromJson(data).news;
  }

  Future refreshText(String key) async {
    text[key] = await fetchAsset('content/nieuws/$key.md');
  }

  Future<String> fetchAsset(String path) async {
    try {
      if (kDebugMode) {
        throw Exception("Always read from the local bundle in debug mode");
      }
      var manager = DefaultCacheManager();
      final ref = experimentalContent ? 'dev' : 'main';
      var url = '$dataRepo/$ref/assets/$path';
      try {
        // First try to fetch the most recent version
        var fileInfo = await manager.downloadFile(url);
        return await fileInfo.file.readAsString();
      } catch (e) {
        // If that fails get the cached version
        var file = await manager.getSingleFile(url);
        return await file.readAsString();
      }
    } catch (e) {
      // If that fails read from the app bundle
      return await rootBundle.loadString('assets/$path');
    }
  }
}
