import 'package:flutter_map/flutter_map.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'map_data.g.dart';

@JsonSerializable(createToJson: false)
class MapAnnotations {
  MapAnnotations(this.regions, this.markers);

  List<MapRegion> regions;
  List<MapMarker> markers;

  factory MapAnnotations.fromJson(Map<String, dynamic> json) =>
      _$MapAnnotationsFromJson(json);
}

@JsonSerializable(createToJson: false)
class MapRegion {
  MapRegion(this.name, this.style, this.alias, this.points);

  String? name;
  String? style;
  String? alias;
  List<List<double>> points;

  factory MapRegion.fromJson(Map<String, dynamic> json) =>
      _$MapRegionFromJson(json);

  bool contains(LatLng loc) {
    return LatLngBounds.fromPoints(
            points.map((p) => LatLng(p[1], p[0])).toList())
        .contains(loc);
  }
}

@JsonSerializable(createToJson: false)
class MapMarker {
  MapMarker(this.name, this.style, this.alias, this.point);

  String? name;
  String? style;
  String? alias;
  List<double> point;

  factory MapMarker.fromJson(Map<String, dynamic> json) =>
      _$MapMarkerFromJson(json);
}
