import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ts_5_4_2_api_flutter/auth/api_keys.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    getWeatherData('Berlin');
  }

  Future<List<dynamic>> getWeatherData(String city) async {
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
    } else if (response.statusCode == 401) {
      print(await Future.error(response.statusCode));
      //return Future.error(response.statusCode);
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
