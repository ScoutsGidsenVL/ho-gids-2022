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
    return ((geometry.coordinates as List)[0] as List)
        .map((p) => (p as List).map((e) => e as double).toList())
        .map((e) => LatLng(e[1], e[0]))
        .toList();
  }

  bool contains(LatLng loc) {
    return LatLngBounds.fromPoints(getPoints()).contains(loc);
  }

  factory MapFeature.fromJson(Map<String, dynamic> json) =>
      _$MapFeatureFromJson(json);
}

@JsonSerializable(createToJson: false)
class MapProperties {
  MapProperties(this.name, this.style, this.comment, this.alias);

  String? name;
  String? style;
  String? comment;
  String? alias;

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
