import 'package:flutter/material.dart';

class TapDetector extends StatefulWidget {
  const TapDetector({
    super.key,
    required this.count,
    required this.onTapped,
    this.child,
  });

  final int count;
  final void Function() onTapped;
  final Widget? child;

  @override
  State<TapDetector> createState() => _TapDetectorState();
}

class _TapDetectorState extends State<TapDetector> {
  int tapCount = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        tapCount += 1;
        if (tapCount >= widget.count) {
          widget.onTapped();
          tapCount = 0;
        }
      },
      child: widget.child,
    );
  }
}
