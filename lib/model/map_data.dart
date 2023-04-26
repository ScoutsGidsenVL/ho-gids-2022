import 'package:flutter_map/flutter_map.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'map_data.g.dart';

@JsonSerializable(createToJson: false)
class MapAnnotations {
  MapAnnotations(this.features);

  List<MapFeature> features;

  factory MapAnnotations.fromJson(Map<String, dynamic> json) =>
      _$MapAnnotationsFromJson(json);
}

@JsonSerializable(createToJson: false)
class MapFeature {
  MapFeature(this.properties, this.geometry);

  MapProperties properties;
  MapGeometry geometry;

  List<LatLng> getPoints() {
    switch (geometry.type) {
      case 'Polygon':
        return ((geometry.coordinates as List)[0] as List)
            .map((p) => (p as List).map((e) => e as double).toList())
            .map((e) => LatLng(e[1], e[0]))
            .toList();
      case 'Point':
        var p = (geometry.coordinates as List).map((e) => e as double).toList();
        return [LatLng(p[1], p[0])];
      default:
        throw UnsupportedError(
            'Cannot get points for geometry ${geometry.type}');
    }
  }

  bool contains(LatLng loc) {
    return LatLngBounds.fromPoints(getPoints()).contains(loc);
  }

  factory MapFeature.fromJson(Map<String, dynamic> json) =>
      _$MapFeatureFromJson(json);
}

@JsonSerializable(createToJson: false)
class MapProperties {
  MapProperties(this.name, this.displayName, this.style);

  String? name;
  String? displayName;
  String? style;

  factory MapProperties.fromJson(Map<String, dynamic> json) =>
      _$MapPropertiesFromJson(json);
}

@JsonSerializable(createToJson: false)
class MapGeometry {
  MapGeometry(this.type, this.coordinates);

  String type;
  dynamic coordinates;

  factory MapGeometry.fromJson(Map<String, dynamic> json) =>
      _$MapGeometryFromJson(json);
}
