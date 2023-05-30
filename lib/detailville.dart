import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:meteo_app/directionvent.dart';
import 'descmeteo.dart';
import 'imagecode.dart';



//Petite erreur lors du chargement de la page par rapport au index qui semble tous bon

class DetailPage extends StatefulWidget {
  final String cityName;

  const DetailPage({required this.cityName});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<String> cities = [];
  List<WeatherData> weatherDataList = [];


  @override
  void initState() {
    super.initState();
    cities.add(widget.cityName);
    fetchWeatherData();
  }


  Future<void> fetchWeatherData() async {
    for (String cityName in cities) {
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

        String apiUrlS =
            'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true';
        http.Response responseS = await http.get(Uri.parse(apiUrlS));

        if (responseS.statusCode == 200) {
          Map<String, dynamic> dataS = json.decode(responseS.body);
          String dateS = dataS['current_weather']['time'];
          DateTime dateTime = DateTime.parse(dateS);
          DateTime dateOnly =
              DateTime(dateTime.year, dateTime.month, dateTime.day);
          DateTime newDate = dateOnly.add(Duration(days: 4));
          String endString = newDate.toString().split(' ')[0];
          String dateString = dateOnly.toString().split(' ')[0];

          String apiUrl =
              'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true&hourly=weathercode,temperature_2m,relativehumidity_2m,apparent_temperature,precipitation_probability,rain,windspeed_10m&daily=weathercode,temperature_2m_max,temperature_2m_min,precipitation_probability_max&start_date=$dateString&end_date=$endString&timezone=auto';
          http.Response response = await http.get(Uri.parse(apiUrl));

          if (response.statusCode == 200) {
            Map<String, dynamic> data = json.decode(response.body);
            double temp = data['current_weather']['temperature'];
            double speed = data['current_weather']['windspeed'];
            int code = data['current_weather']['weathercode'];
            String date = data['current_weather']['time'];
            double directionVent = data['current_weather']['windspeed'];
            int pluie = data['daily']['precipitation_probability_max'][0];
            int humidity = data['hourly']['relativehumidity_2m'][0];
            double tr = data['hourly']['apparent_temperature'][0];


            List<double> tempminList = [];
            List<double> tempmaxList = [];
            List<int> codeD = [];
            List<String> time = [];

            List<double> tempH = [];
            List<int> codeH = [];
            List<String> timeH = [];

            data['daily']['temperature_2m_min'].forEach((temp) {
              tempminList.add(temp);
            });

            data['daily']['temperature_2m_max'].forEach((temp) {
              tempmaxList.add(temp);
            });

            data['daily']['weathercode'].forEach((temp) {
              codeD.add(temp);
            });

            data['daily']['time'].forEach((temp) {
              time.add(temp);
            });

            data['hourly']['temperature_2m'].forEach((temp) {
              tempH.add(temp);
            });

            data['hourly']['weathercode'].forEach((temp) {
              codeH.add(temp);
            });

            data['hourly']['time'].forEach((temp) {
              timeH.add(temp);
            });

            WeatherData weatherData = WeatherData(
              dateS: dateS,
              cityName: ville,
              country: pays,
              temperature: temp.toStringAsFixed(1),
              windSpeed: speed.toStringAsFixed(0),
              weatherCode: code.toString(),
              chancepluie: pluie.toString(),
              humidite: humidity.toString(),
              tempressentie: tr.toStringAsFixed(1),
              date: date,
              temperaturemin: tempminList,
              temperaturemax: tempmaxList,
              codeD: codeD,
              time: time,
              tempH: tempH,
              timeH: timeH,
              codeH: codeH,
              directionVent: directionVent,
            );

            setState(() {
              weatherDataList.add(weatherData);
            });
          } else {
            print(
                'Erreur lors de la récupération des données météo de $cityName.');
          }
        } else {
          print(
              'Erreur lors de la récupération des coordonnées géographiques de $cityName.');
        }
      }
    }
  }

  int findIndex(List<String> list, String targetValue) {
    for (int i = 0; i < list.length; i++) {
      if (list[i] == targetValue) {
        return i;
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
      int targetIndex = findIndex(
          weatherDataList[0].timeH, weatherDataList[0].date);

      return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          '${weatherDataList[0].cityName}, ${weatherDataList[0].country}',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              WeatherDescription(code: int.parse(
                                  weatherDataList[0].weatherCode))
                                  .getWeatherDescription(),
                              style: TextStyle(fontSize: 18),
                            ),

                            Text(
                              '${weatherDataList[0].temperature}°',
                              style: TextStyle(fontSize: 28),
                            ),
                          ],
                        ),
                      ),
                      SvgPicture.asset(
                        WeatherIcon(code: int.parse(weatherDataList[0]
                            .weatherCode)).getWeatherIcon(),
                        color: Colors.deepPurpleAccent,
                        height: 80,
                        width: 80,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 20),
                      children: [
                        TextSpan(
                          text: 'Aujourd\'hui, le temps est ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: WeatherDescription(code: int.parse(
                              weatherDataList[0].weatherCode))
                              .getWeatherDescription(),
                          style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' Il y aura une minimale de ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: '${weatherDataList[0].temperaturemin[0]}°C',
                          style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' et un maximum de',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: ' ${weatherDataList[0].temperaturemax[0]}°C.',
                          style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, top: 20, bottom: 10),
                  child: Text(
                    DateFormat('EEEE', 'fr_FR').format(
                      DateTime.parse('${weatherDataList[0].time[0]}'),
                    ),
                    style: TextStyle(fontSize: 28),
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: 15, top: 20, bottom: 10),
                  child: Text(
                    '${weatherDataList[0]
                        .temperaturemin[0]}° ${weatherDataList[0]
                        .temperaturemax[0]}°',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
              ],
            ),
            Container(
              height: 114,
              margin: EdgeInsets.only(
                  left: 15, bottom: 15
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 24,
                itemBuilder: (context, index) {
                  final startIndex = targetIndex;

                  index += startIndex;
                  if (targetIndex == index) {
                    return Container(
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
                      margin: EdgeInsets.only(left: 15, bottom: 10),
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              DateFormat.H().format(DateTime.parse(
                                  '${weatherDataList[0].timeH[index]}')) +
                                  "H",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SvgPicture.asset(
                            WeatherIcon(
                                code: int.parse(weatherDataList[0].weatherCode))
                                .getWeatherIcon(),
                            width: 40,
                            height: 40,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${weatherDataList[0].tempH[index]}°',
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    if (DateFormat('yyyy-MM-dd').format(
                        DateTime.parse(weatherDataList[0].timeH[index])) ==
                        DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(weatherDataList[0].date))) {
                      return Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                DateFormat.H().format(DateTime.parse(
                                    '${weatherDataList[0].timeH[index]}')) +
                                    "H",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SvgPicture.asset(
                              WeatherIcon(code: int.parse(
                                  weatherDataList[0].weatherCode))
                                  .getWeatherIcon(),
                              width: 40,
                              height: 40,
                              color: Colors.black,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${weatherDataList[0].tempH[index]}°',
                                style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container(); // Retourne un conteneur vide si la condition n'est pas remplie
                    }
                  }
                },
              ),
            ),
            Column(
              children: List.generate(4, (index2) {
                final dataIndex = index2 + 1;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 15,),
                    Text(
                      DateFormat('EEEE', 'fr_FR').format(DateTime.parse(
                          '${weatherDataList[0].time[dataIndex]}')),
                      style: TextStyle(fontSize: 28),
                    ),
                    Spacer(),
                    SvgPicture.asset(
                      WeatherIcon(code: int.parse(
                          weatherDataList[0].weatherCode)).getWeatherIcon(),
                      color: Colors.black,
                    ),
                    Text(
                      ' ${weatherDataList[0]
                          .temperaturemin[dataIndex]}° ${weatherDataList[0]
                          .temperaturemax[dataIndex]}°',
                      style: TextStyle(fontSize: 28),
                    ),
                    SizedBox(width: 15,),
                  ],
                );
              }),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 15),
              child: Text(
                'Plus d\'infos',
                style: TextStyle(fontSize: 24),
              ),
            ),

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildItem('Chance de pluies', 'assets/rain-drops-3.svg',
                        '${weatherDataList[0].chancepluie}%'),
                    _buildItem('Taux d\'humidité', 'assets/rain.svg',
                        '${weatherDataList[0].humidite}%'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildItem(
                      'Vent',
                      'assets/windy-1.svg',
                      '${WindDirection(
                          degrees: weatherDataList[0].directionVent)
                          .getDirection()} ${weatherDataList[0]
                          .windSpeed} km/h',
                    ),
                    _buildItem(
                      'Température ressentie',
                      'assets/direction-1.svg',
                      '${weatherDataList[0].tempressentie}°C',
                    ),
                  ],
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String text1, String imagePath, String text2) {
    return Container(
      height: 120,
      width: 80,
      margin: EdgeInsets.all(30.0),
      child: Column(
        children: [
          Text(text1, softWrap: true, textAlign: TextAlign.center),
          SizedBox(height: 8.0),
          SvgPicture.asset(
            imagePath,
            width: 50.0,
            height: 50.0,
            color: Colors.black,
          ),
          Text(
            text2,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.deepPurpleAccent,
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherData {
  final String dateS;
  final String cityName;
  final String country;
  final String temperature;
  final String windSpeed;
  final String weatherCode;
  final String chancepluie;
  final String humidite;
  final String tempressentie;
  final String date;
  final double directionVent;
  final List<double> temperaturemin;
  final List<double> temperaturemax;
  final List<int> codeD;
  final List<String> time;
  final List<double> tempH;
  final List<int> codeH;
  final List<String> timeH;

  WeatherData({
    required this.dateS,
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.temperaturemin,
    required this.temperaturemax,
    required this.windSpeed,
    required this.weatherCode,
    required this.chancepluie,
    required this.humidite,
    required this.tempressentie,
    required this.date,
    required this.codeD,
    required this.time,
    required this.tempH,
    required this.codeH,
    required this.timeH,
    required this.directionVent,
  });
}
