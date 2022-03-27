// only for animation
import 'package:flutter/material.dart';

Offset getPositions(GlobalKey key) {
  if (key.currentContext != null) {
    final RenderBox renderBoxRed =
    key.currentContext!.findRenderObject() as RenderBox;
    final positionRed = renderBoxRed.localToGlobal(Offset.zero);
    // print("POSITION of bell: $positionRed ");
    return positionRed;
  } else {
    return const Offset(0, 0);
  }
}