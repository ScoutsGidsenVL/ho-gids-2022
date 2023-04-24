import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ho_gids/model/dynamic_data.dart';
import 'package:ho_gids/model/map_data.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:collection/collection.dart';

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

  final mapController = MapController();
  MapFeature? _selectedFeature;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        final features = context.read<DynamicData>().annotations ?? [];
        final focusedFeature =
            features.firstWhereOrNull((f) => f.properties.name == widget.id);
        if (focusedFeature == null) return;
        final focusedPoint = focusedFeature.getPoints()[0];
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
    super.dispose();
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
            center: LatLng(51.2387, 4.9389),
            zoom: 14,
            maxZoom: 17.49,
            onTap: (tapPosition, point) {
              var region = polygons
                  .where((r) =>
                      r.contains(point) && r.properties.style != 'border')
                  .lastOrNull;
              setState(() {
                _selectedFeature = region;
              });
            },
          ),
          nonRotatedChildren: [
            const OsmAttribution(),
            _selectedFeature == null
                ? Container()
                : SelectedFeature(_selectedFeature!),
          ],
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'be.scoutsengidsenvlaanderen.hogids',
              retinaMode: MediaQuery.of(context).devicePixelRatio > 1.0,
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
                      label: f.properties.name,
                      rotateLabel: true,
                      points: f.getPoints());
                } catch (e) {
                  return Polygon(points: []);
                }
              }).toList(),
            ),
            MarkerLayer(
              markers: markers.map((f) {
                var image = AssetImage(
                    'assets/images/kaart/${f.properties.name?.toLowerCase() ?? ''}.png');
                return Marker(
                    point: f.getPoints()[0],
                    rotate: true,
                    width: 24,
                    height: 24,
                    builder: (context) => Image(image: image));
              }).toList(),
            ),
            CurrentLocationLayer(),
          ],
        ));
  }
}

class PolygonStyle {
  final Color? border;
  final Color? fill;

  const PolygonStyle({this.border, this.fill});
}

class SelectedFeature extends StatelessWidget {
  final MapFeature feature;

  const SelectedFeature(this.feature, {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Card(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text(feature.properties.name ?? '',
                    style: Theme.of(context).textTheme.headlineSmall))));
  }
}

class OsmAttribution extends StatelessWidget {
  const OsmAttribution({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AttributionWidget(
      attributionBuilder: (context) => Align(
        alignment: Alignment.bottomRight,
        child: ColoredBox(
          color: const Color(0xCCFFFFFF),
          child: GestureDetector(
            onTap: () {
              launchUrl(Uri.parse('https://www.openstreetmap.org/copyright'),
                  mode: LaunchMode.externalApplication);
            },
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Text(
                      '© OpenStreetMap',
                      style: TextStyle(color: Color(0xFF0078a8)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
