import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hogids/model/dynamic_data.dart';
import 'package:hogids/model/map_data.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:hogids/widgets/feature_card.dart';
import 'package:hogids/widgets/osm_attribution.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:collection/collection.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';

class Kaart extends StatefulWidget {
  const Kaart({Key? key, this.id}) : super(key: key);

  final String? id;

  @override
  KaartState createState() => KaartState();
}

class KaartState extends State<Kaart> {
  static final Map<String, PolygonStyle> styles = {
    'podium': const PolygonStyle(fill: Color(0x77F07D00)),
    'podiumgrond': const PolygonStyle(fill: Color(0x77006F93)),
    'pavilioen': const PolygonStyle(fill: Color(0x77E2AFC4)),
    'loods': const PolygonStyle(fill: Color(0x77DAE283)),
    'kampeergrond': const PolygonStyle(fill: Color(0x7751AF31)),
    'kampeergrond-ongebruikt': const PolygonStyle(fill: Color(0x77FDF7F4)),
    'aanbod': const PolygonStyle(fill: Color(0x77DA0C25)),
    'vijver': const PolygonStyle(fill: Color(0x88009FE3)),
    'bos': const PolygonStyle(fill: Color(0x777E216E)),
    'faciliteit': const PolygonStyle(fill: Color(0x770E7594)),
    'border': const PolygonStyle(border: Color(0x77000000)),
  };
  static final center = LatLng(51.2421, 4.9335);

  final mapController = MapController();
  late StreamController<LocationMarkerPosition> positionStreamController;
  MapFeature? _selectedFeature;
  bool _locationEnabled = false;
  bool _locationFixed = false;
  bool _centerFixed = true;

  @override
  void initState() {
    super.initState();
    positionStreamController = StreamController();
    if (widget.id != null) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        final features = context.read<DynamicData>().annotations ?? [];
        final focusedFeature =
            features.firstWhereOrNull((f) => f.properties.name == widget.id);
        if (focusedFeature == null) return;
        final focusedPoint =
            LatLngBounds.fromPoints(focusedFeature.getPoints()).center;
        mapController.move(focusedPoint, 16.5);
        setState(() {
          _selectedFeature = focusedFeature;
        });
      });
    }
  }

  @override
  void dispose() {
    mapController.dispose();
    positionStreamController.close();
    super.dispose();
  }

  void _focusCenter() {
    mapController.moveAndRotate(center, 14, 0);
    setState(() {
      _selectedFeature = null;
      _locationFixed = false;
      _centerFixed = true;
    });
  }

  void _enableLocation() async {
    try {
      if (!_locationEnabled) {
        var permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied ||
              permission == LocationPermission.deniedForever) {
            return;
          }
        }
      }

      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _selectedFeature = null;
        _locationEnabled = true;
        _locationFixed = !_locationFixed;
        _centerFixed = false;
      });
      _newPosition(position);
    } catch (e) {
      if (_locationEnabled) {
        setState(() {
          _locationEnabled = false;
          _locationFixed = false;
        });
      }
      return;
    }
    Geolocator.getPositionStream().listen((position) {
      _newPosition(position);
    }, onError: (Object error) {
      if (_locationEnabled) {
        setState(() {
          _locationEnabled = false;
          _locationFixed = false;
        });
      }
    }, cancelOnError: true);
  }

  void _newPosition(Position position) {
    if (_locationFixed) {
      mapController.move(LatLng(position.latitude, position.longitude), 16.5);
    }
    if (!positionStreamController.isClosed) {
      positionStreamController.add(LocationMarkerPosition(
          latitude: position.latitude,
          longitude: position.longitude,
          accuracy: position.accuracy));
    }
  }

  @override
  Widget build(BuildContext context) {
    final features = context.watch<DynamicData>().annotations ?? [];
    final polygons = features.where((f) => f.geometry.type == 'Polygon');
    final markers = features.where((f) => f.geometry.type == 'Point');

    return Scaffold(
      backgroundColor: Colors.white,
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          onPositionChanged: (pos, hasGesture) {
            if (((hasGesture && _locationFixed) || _centerFixed)) {
              setState(() {
                _locationFixed = false;
                _centerFixed = false;
              });
            }
          },
          center: center,
          zoom: 14,
          maxZoom: 18.49,
          onTap: (tapPos, point) {
            final tPos = tapPos.relative;
            var feature = markers.lastWhereOrNull((m) {
              final mPos = mapController.latLngToScreenPoint(m.getPoints()[0]);
              if (tPos == null || mPos == null) return false;
              final d = (mPos.x - tPos.dx) * (mPos.x - tPos.dx) +
                  (mPos.y - tPos.dy) * (mPos.y - tPos.dy);
              return d <= 12 * 12;
            });
            feature ??= polygons.lastWhereOrNull(
                (r) => r.contains(point) && r.properties.style != 'border');
            if (_selectedFeature != feature) {
              setState(() {
                _selectedFeature = feature;
              });
            }
          },
        ),
        nonRotatedChildren: const [
          OsmAttribution(),
        ],
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'be.scoutsengidsenvlaanderen.hogids',
            tileProvider: FMTC.instance('mapStore').getTileProvider(),
            retinaMode: MediaQuery.of(context).devicePixelRatio > 1.0,
            maxZoom: 19,
          ),
          PolygonLayer(
            polygons: polygons.map((f) {
              var style = styles[f.properties.style] ?? const PolygonStyle();
              var selected = f == _selectedFeature;
              try {
                return Polygon(
                    borderColor: style.border ??
                        (selected ? Colors.black : Colors.transparent),
                    borderStrokeWidth:
                        style.border != null ? 5 : (selected ? 2 : 0),
                    isDotted: style.border != null,
                    color: style.fill ?? Colors.transparent,
                    isFilled: style.fill != null,
                    rotateLabel: true,
                    points: f.getPoints());
              } catch (e) {
                return Polygon(points: []);
              }
            }).toList(),
          ),
          MarkerLayer(
            markers: [
              ...polygons
                  .where((f) => f.properties.style == 'kampeergrond')
                  .map((f) {
                final center = LatLngBounds.fromPoints(f.getPoints()).center;
                return Marker(
                  point: center,
                  rotate: true,
                  width: 40,
                  height: 40,
                  builder: (context) => const Image(
                      image: AssetImage('assets/images/kaart/tent.png')),
                );
              }),
              ...markers.map((f) {
                var image = AssetImage(
                    'assets/images/kaart/${f.properties.name?.toLowerCase() ?? ''}.png');
                var selected = f == _selectedFeature;
                return Marker(
                    point: f.getPoints()[0],
                    rotate: true,
                    width: selected ? 28 : 24,
                    height: selected ? 28 : 24,
                    builder: (context) => Container(
                        decoration: !selected
                            ? null
                            : BoxDecoration(
                                border: Border.all(width: 2),
                                borderRadius: BorderRadius.circular(1000)),
                        child: Image(image: image)));
              }),
            ],
          ),
          CurrentLocationLayer(
            positionStream: positionStreamController.stream,
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'centerButton',
            onPressed: _focusCenter,
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: Icon(Icons.home,
                color: _centerFixed
                    ? Theme.of(context).colorScheme.primary
                    : null),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
              heroTag: 'gpsButton',
              onPressed: _enableLocation,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: _locationEnabled
                  ? _locationFixed
                      ? Icon(Icons.gps_fixed,
                          color: Theme.of(context).colorScheme.primary)
                      : const Icon(Icons.gps_not_fixed)
                  : const Icon(Icons.gps_off)),
        ],
      ),
      bottomSheet: _selectedFeature == null
          ? null
          : BottomSheet(
              constraints: const BoxConstraints(minWidth: double.infinity),
              enableDrag: false,
              onClosing: () {},
              builder: (context) {
                return FeatureCard(_selectedFeature!);
              },
            ),
    );
  }
}

class PolygonStyle {
  final Color? border;
  final Color? fill;

  const PolygonStyle({this.border, this.fill});
}
