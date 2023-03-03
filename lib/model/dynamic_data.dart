import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ho_gids/model/map_data.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

const dataRepo =
    'https://raw.githubusercontent.com/ScoutsGidsenVL/ho-gids-2022/main';

class DynamicData extends ChangeNotifier {
  List<MapFeature>? annotations;

  DynamicData() {
    refreshData();
  }

  Future refreshData() async {
    await Future.wait([
      refreshMapData(),
    ]);
    notifyListeners();
  }

  Future refreshMapData() async {
    var source = await fetchAsset('content/kaart.json');
    var data = await json.decode(source);
    annotations = MapAnnotations.fromJson(data).features;
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
