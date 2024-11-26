import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ts_5_4_2_api_flutter/auth/api_keys.dart';
import 'package:ts_5_4_2_api_flutter/weather_data.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

const spaceBetween = SizedBox(
  width: 20,
);

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    //getWeatherData('Stuttgart');
  }

  final TextEditingController controllerSearchCity = TextEditingController();
  bool showWeatherData = false;

  Future<WeatherData> getWeatherData(String city) async {
    // https://api.weatherapi.com/v1/current.json

    final Map<String, dynamic> queryParameters = {
      'q': city,
      'key': weatherAPIKey
    };
    final Uri uri =
        Uri.https('api.weatherapi.com', 'v1/current.json', queryParameters);
    print(uri);
    final http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      final String data = response.body;
      final Map<String, dynamic> decodedJson = jsonDecode(data);

      print(decodedJson);
      final location = decodedJson['location'];

      final Map<String, dynamic> weatherData = decodedJson['location'];
      print(weatherData);
      return WeatherData(
          name: weatherData["name"],
          region: weatherData["region"],
          country: weatherData["country"],
          lat: weatherData["lat"]);
      //return decodedJson;
    } else {
      return Future.error("Stadt nicht gefunden");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: controllerSearchCity,
                decoration:
                    const InputDecoration(label: Text("Stadtname oder PLZ")),
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showWeatherData = true;
                      //getWeatherData(controllerSearchCity.text);
                    });
                  },
                  child: const Text("Suche")),
              showWeatherData
                  ? FutureBuilder(
                      future: getWeatherData(controllerSearchCity.text),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData) {
                          return const Center(child: Text('NoData'));
                        }
                        return Weatherdata(weatherData: snapshot.data!);
                      })
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class Weatherdata extends StatelessWidget {
  final WeatherData weatherData;
  const Weatherdata({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [const Text("Name"), spaceBetween, Text(weatherData.name)],
        ),
        Row(
          children: [
            const Text("Region"),
            spaceBetween,
            Text(weatherData.region)
          ],
        ),
        Row(
          children: [
            const Text("Land"),
            spaceBetween,
            Text(weatherData.country)
          ],
        ),
        Row(
          children: [
            const Text("lat"),
            spaceBetween,
            Text(weatherData.lat.toString())
          ],
        )
      ],
    );
  }
}
