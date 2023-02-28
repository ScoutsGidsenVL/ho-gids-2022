import 'package:flutter/material.dart';
import 'package:ho_gids/model/dynamic_data.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var features = context.watch<DynamicData>().annotations ?? [];
    var markers = features.where((f) => f.geometry.type == 'Point');

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
            maxZoom: 17,
            rotation: 0,
            interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
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
            MarkerLayer(
              markers: [
                ...markers.map((f) => Marker(
                    point: LatLng(
                        f.geometry.coordinates[1], f.geometry.coordinates[0]),
                    width: 60,
                    height: 60,
                    builder: (context) => const Image(
                        image: AssetImage('assets/images/kaart/tent.png')))),
              ],
            ),
            CurrentLocationLayer(),
          ],
        ));
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
