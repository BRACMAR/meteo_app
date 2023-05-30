import 'package:flutter/material.dart';

class WindDirection extends StatelessWidget {
  final double degrees;

  WindDirection({required this.degrees});

  String getDirection() {
    if (degrees >= 0 && degrees < 22.5) {
      return 'N';
    } else if (degrees >= 22.5 && degrees < 67.5) {
      return 'NE';
    } else if (degrees >= 67.5 && degrees < 112.5) {
      return 'E';
    } else if (degrees >= 112.5 && degrees < 157.5) {
      return 'SE';
    } else if (degrees >= 157.5 && degrees < 202.5) {
      return 'S';
    } else if (degrees >= 202.5 && degrees < 247.5) {
      return 'SO';
    } else if (degrees >= 247.5 && degrees < 292.5) {
      return 'O';
    } else if (degrees >= 292.5 && degrees < 337.5) {
      return 'NO';
    } else if (degrees >= 337.5 && degrees <= 360) {
      return 'N';
    } else {
      return 'Problème d\'orientation du vent';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      getDirection(),

    );
  }
}
