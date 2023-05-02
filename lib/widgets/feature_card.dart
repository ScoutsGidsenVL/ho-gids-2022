import 'package:flutter/material.dart';
import 'package:ho_gids/model/map_data.dart';

class FeatureCard extends StatelessWidget {
  final MapFeature feature;

  const FeatureCard(this.feature, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Text(
        feature.properties.displayName ?? feature.properties.name ?? '',
        style: const TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
  }
}
