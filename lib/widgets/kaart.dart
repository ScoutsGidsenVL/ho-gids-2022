import 'package:flutter/material.dart';
import 'package:ho_gids/widgets/nav_drawer.dart';

class Kaart extends StatefulWidget {
  const Kaart({Key? key}) : super(key: key);

  @override
  KaartState createState() => KaartState();
}

class KaartState extends State<Kaart> {
  final viewTransformationController = TransformationController();

  @override
  void initState() {
    const zoomFactor = 0.2;
    const xTranslate = 350.0;
    const yTranslate = 50.0;
    viewTransformationController.value.setEntry(0, 0, zoomFactor);
    viewTransformationController.value.setEntry(1, 1, zoomFactor);
    viewTransformationController.value.setEntry(2, 2, zoomFactor);
    viewTransformationController.value.setEntry(0, 3, -xTranslate);
    viewTransformationController.value.setEntry(1, 3, -yTranslate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Kaart'),
        ),
        drawer: const NavDrawer(),
        backgroundColor: Colors.white,
        body: InteractiveViewer(
          transformationController: viewTransformationController,
          boundaryMargin: const EdgeInsets.symmetric(vertical: 700),
          maxScale: 1,
          minScale: 0.05,
          constrained: false,
          child: const Image(
            image: AssetImage('assets/images/kaart.png'),
          ),
        ));
  }
}
