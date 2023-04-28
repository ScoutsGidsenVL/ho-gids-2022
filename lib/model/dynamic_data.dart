import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ho_gids/model/calendar_data.dart';
import 'package:ho_gids/model/map_data.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ho_gids/model/news_data.dart';

const dataRepo =
    'https://raw.githubusercontent.com/ScoutsGidsenVL/ho-gids-2022/main';

class DynamicData extends ChangeNotifier {
  late Timer timer;
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

  Future refreshData() async {
    await refreshNewsData();
    await Future.wait([
      refreshMapData(),
      refreshCalendarData(),
      ...news?.where((n) => n.body != null).map((n) => refreshText(n.body!)) ??
          [],
    ]);
    notifyListeners();
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
      var url = '$dataRepo/assets/$path';
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
