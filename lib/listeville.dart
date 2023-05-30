import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'descmeteo.dart';
import 'detailville.dart';
import 'imagecode.dart';

class WeatherPage extends StatefulWidget {
  final List<String> cities;

  const WeatherPage(this.cities, {super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  List<WeatherData> weatherDataList = [];
  bool isLoading = true; // Variable d'état pour le chargement

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    for (String cityName in widget.cities) {
      String geocodingApiUrl =
          'https://geocoding-api.open-meteo.com/v1/search?name=${Uri.encodeComponent(cityName)}&count=1&language=fr';
      http.Response geocodingResponse =
      await http.get(Uri.parse(geocodingApiUrl));
      if (geocodingResponse.statusCode == 200) {
        Map<String, dynamic> geocodingData =
        json.decode(geocodingResponse.body);
        double latitude = geocodingData['results'][0]['latitude'];
        double longitude = geocodingData['results'][0]['longitude'];
        String pays = geocodingData['results'][0]['country'];
        String ville = geocodingData['results'][0]['name'];

        String apiUrl =
            'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true';
        http.Response response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          Map<String, dynamic> data = json.decode(response.body);
          double temp = data['current_weather']['temperature'];
          int code = data['current_weather']['weathercode'];

          WeatherData weatherData = WeatherData(
            cityName: ville,
            country: pays,
            temperature: temp.toStringAsFixed(1),
            weatherCode: code.toString(),
          );
          setState(() {
            weatherDataList.add(weatherData);
          });
        } else {
          print('Erreur lors de la récupération des données météo de $cityName.');
        }
      } else {
        print(
            'Erreur lors de la récupération des coordonnées géographiques de $cityName.');
      }
    }

    // Désactiver l'état de chargement après la récupération des données
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, // Couleur de la flèche
        ),
        title: Text('Mes villes',style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      body: Stack(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: weatherDataList.length,
            itemBuilder: (context, index) {
              WeatherData weatherData = weatherDataList[index];
              return InkWell(
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailPage(cityName: weatherData.cityName)),
                  ).then((value) {
                    setState(() {
                      isLoading = false;
                    });
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${weatherData.cityName}, ${weatherData.country}',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
                            ),
                            Text(
                              '${weatherData.temperature}°',
                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,),
                            ),
                            Text(
                              WeatherDescription(code: int.parse(weatherDataList[0].weatherCode)).getWeatherDescription(),
                              style: TextStyle(fontSize: 22),
                            ),
                          ],
                        ),
                      ),
                      SvgPicture.asset(
                        WeatherIcon(code: int.parse(weatherDataList[0].weatherCode)).getWeatherIcon(),
                        color: Colors.deepPurpleAccent,
                        height: 80,
                        width: 80,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Indicateur de chargement
          if (isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

class WeatherData {
  final String cityName;
  final String country;
  final String temperature;
  final String weatherCode;

  WeatherData({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.weatherCode,
  });
}
