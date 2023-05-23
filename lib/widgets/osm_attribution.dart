import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OsmAttribution extends StatelessWidget {
  const OsmAttribution({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
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
    );
  }
}
