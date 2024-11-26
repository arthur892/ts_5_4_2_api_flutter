import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ts_5_4_2_api_flutter/auth/api_keys.dart';
import 'package:ts_5_4_2_api_flutter/weatherdata_model.dart';
import 'package:ts_5_4_2_api_flutter/weatherdata_widget.dart';

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
      'key': api_weather
    };
    final Uri uri =
        Uri.https('api.weatherapi.com', 'v1/current.json', queryParameters);
    print(uri);
    final http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      final String data = response.body;
      final Map<String, dynamic> decodedJson = jsonDecode(data);

      print(decodedJson);

      final Map<String, dynamic> weatherDataLocation = decodedJson['location'];
      final Map<String, dynamic> weatherDataCurrent = decodedJson['current'];

      print(weatherDataLocation);
      return WeatherData(
          name: weatherDataLocation["name"],
          region: weatherDataLocation["region"],
          country: weatherDataLocation["country"],
          lat: weatherDataLocation["lat"],
          lon: weatherDataLocation["lon"],
          tz_id: weatherDataLocation["tz_id"],
          localtime: weatherDataLocation["localtime"],
          temp_c: weatherDataCurrent["temp_c"],
          temp_f: weatherDataCurrent["temp_f"],
          icon: "https:" + weatherDataCurrent["condition"]["icon"]);

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
                onFieldSubmitted: (value) {
                  setState(() {
                    showWeatherData = true;
                  });
                },
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
                        return WeatherdataWidget(weatherData: snapshot.data!);
                      })
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
