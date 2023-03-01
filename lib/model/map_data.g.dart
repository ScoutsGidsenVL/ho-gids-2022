// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapAnnotations _$MapAnnotationsFromJson(Map<String, dynamic> json) =>
    MapAnnotations(
      (json['regions'] as List<dynamic>)
          .map((e) => MapRegion.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['markers'] as List<dynamic>)
          .map((e) => MapMarker.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

MapRegion _$MapRegionFromJson(Map<String, dynamic> json) => MapRegion(
      json['name'] as String?,
      json['style'] as String?,
      json['alias'] as String?,
      (json['points'] as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toDouble()).toList())
          .toList(),
    );

MapMarker _$MapMarkerFromJson(Map<String, dynamic> json) => MapMarker(
      json['name'] as String?,
      json['style'] as String?,
      json['alias'] as String?,
      (json['point'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );
