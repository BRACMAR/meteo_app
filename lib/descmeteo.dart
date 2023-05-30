import 'package:flutter/material.dart';

class WeatherDescription extends StatelessWidget {
  final int code;

  WeatherDescription({required this.code});

  String getWeatherDescription() {
    switch (code) {
      case 0:
        return 'Dégagé';
      case 1:
        return 'Ensoleillé';
      case 2:
        return 'Partiellement nuageux';
      case 3:
        return 'Couvert';
      case 45:
        return 'Brumeux';
      case 48:
        return 'Très brumeux';
      case 51:
        return 'Bruine légère';
      case 53:
        return 'Bruine modérée';
      case 55:
        return 'Bruine forte';
      case 56:
        return 'Bruine verglaçante légère';
      case 57:
        return 'Bruine verglaçante forte';
      case 61:
        return 'Pluie légère';
      case 63:
        return 'Pluie modérée';
      case 65:
        return 'Pluie forte';
      case 66:
        return 'Pluie verglaçante légère';
      case 67:
        return 'Pluie verglaçante forte';
      case 71:
        return 'Chute de neige légère';
      case 73:
        return 'Chute de neige modérée';
      case 75:
        return 'Chute de neige forte';
      case 77:
        return 'Grains de neige';
      case 80:
        return 'Averses de pluie légères';
      case 81:
        return 'Averses de pluie modérées';
      case 82:
        return 'Averses de pluie violentes';
      case 85:
        return 'Averses de neige légères';
      case 86:
        return 'Averses de neige fortes';
      case 95:
        return 'Orage';
      case 96:
        return 'Orage avec grêle légère';
      case 99:
        return 'Orage avec grêle forte';
      default:
        return 'Non défini';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      getWeatherDescription(),

    );
  }
}