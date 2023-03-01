import 'package:flutter/material.dart';
import 'package:ho_gids/model/dynamic_data.dart';
import 'package:ho_gids/model/map_data.dart';
import 'package:ho_gids/widgets/nav_drawer.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

class Kaart extends StatefulWidget {
  const Kaart({Key? key}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var annotations =
        context.watch<DynamicData>().annotations ?? MapAnnotations([], []);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Kaart'),
        ),
        drawer: const NavDrawer(),
        backgroundColor: Colors.white,
        body: FlutterMap(
          options: MapOptions(
            center: LatLng(51.2387, 4.9390),
            zoom: 14,
            maxZoom: 17.49,
          ),
          nonRotatedChildren: const [
            OsmAttribution(),
          ],
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'be.scoutsengidsenvlaanderen.hogids',
              retinaMode: MediaQuery.of(context).devicePixelRatio > 1.0,
            ),
            PolygonLayer(
              polygons: annotations.regions.map((f) {
                var style = styles[f.style] ?? const PolygonStyle();
                try {
                  return Polygon(
                      borderColor: style.border ?? Colors.transparent,
                      borderStrokeWidth: style.border != null ? 5 : 0,
                      isDotted: style.border != null,
                      color: style.fill ?? Colors.transparent,
                      isFilled: style.fill != null,
                      points: f.points.map((p) => LatLng(p[1], p[0])).toList());
                } catch (e) {
                  return Polygon(points: []);
                }
              }).toList(),
            ),
            MarkerLayer(
              markers: annotations.markers.map((f) {
                var image = AssetImage(
                    'assets/images/kaart/${f.name?.toLowerCase() ?? ''}.png');
                return Marker(
                    point: LatLng(f.point[1], f.point[0]),
                    width: 30,
                    height: 30,
                    builder: (context) => Image(image: image));
              }).toList(),
            ),
            CurrentLocationLayer(),
          ],
        ));
  }
}

class PolygonStyle {
  const PolygonStyle({this.border, this.fill});

  final Color? border;
  final Color? fill;
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
