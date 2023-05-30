import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  final int code;

  WeatherIcon({required this.code});

  String getWeatherIcon() {
    switch (code) {
      case 0:
        return 'assets/sunlight.svg';
      case 1:
        return 'assets/sun-cloud.svg';
      case 2:
        return 'assets/cloudy-2.svg';
      case 3:
        return 'assets/cloudy-1.svg';
      case 45:
        return 'assets/haze.svg';
      case 48:
        return 'assets/haze.svg';
      case 51:
        return 'assets/snow.svg';
      case 53:
        return 'assets/snow.svg';
      case 55:
        return 'assets/snow.svg';
      case 56:
        return 'assets/snow-2.svg';
      case 57:
        return 'assets/snow-2.svg';
      case 61:
        return 'assets/rain.svg';
      case 63:
        return 'assets/rain.svg';
      case 65:
        return 'assets/rain.svg';
      case 66:
        return 'assets/rain.svg';
      case 67:
        return 'assets/rain.svg';
      case 71:
        return 'assets/snow-2.svg';
      case 73:
        return 'assets/snow-2.svg';
      case 75:
        return 'assets/snow-2.svg';
      case 77:
        return 'assets/snow-2.svg';
      case 80:
        return 'assets/rain-drops-1.svg';
      case 81:
        return 'assets/rain-drops-1.svg';
      case 82:
        return 'assets/rain-drops-1.svg';
      case 85:
        return 'assets/snow.svg';
      case 86:
        return 'assets/snow.svg';
      case 95:
        return 'assets/thunderstorm.svg';
      case 96:
        return 'assets/thunderstorm.svg';
      case 99:
        return 'assets/thunderstorm.svg';
      default:
        return 'assets/default.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      getWeatherIcon(),

    );
  }
}