// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapAnnotations _$MapAnnotationsFromJson(Map<String, dynamic> json) =>
    MapAnnotations(
      (json['features'] as List<dynamic>)
          .map((e) => MapFeature.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

MapFeature _$MapFeatureFromJson(Map<String, dynamic> json) => MapFeature(
      MapProperties.fromJson(json['properties'] as Map<String, dynamic>),
      MapGeometry.fromJson(json['geometry'] as Map<String, dynamic>),
    );

MapProperties _$MapPropertiesFromJson(Map<String, dynamic> json) =>
    MapProperties(
      json['name'] as String?,
      json['displayName'] as String?,
      json['style'] as String?,
      json['comment'] as String?,
      json['alias'] as String?,
    );

MapGeometry _$MapGeometryFromJson(Map<String, dynamic> json) => MapGeometry(
      json['type'] as String,
      json['coordinates'],
    );
