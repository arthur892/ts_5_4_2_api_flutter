import 'package:flutter/material.dart';
import 'package:ts_5_4_2_api_flutter/weatherdata_model.dart';

class WeatherdataWidget extends StatelessWidget {
  final WeatherData weatherData;
  const WeatherdataWidget({super.key, required this.weatherData});

  Row formatText({required String label, required String data}) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Text(data)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        formatText(label: "Stadtname:", data: weatherData.name),
        formatText(label: "Region:", data: weatherData.region),
        formatText(label: "Land:", data: weatherData.country),
        formatText(
            label: "Position:",
            data:
                "${weatherData.lat.toStringAsFixed(2)} lat   ${weatherData.lon.toStringAsFixed(2)} lon"),
        formatText(label: "Zeitzone:", data: weatherData.tz_id),
        formatText(label: "Abfrage Uhrzeit:", data: weatherData.localtime),
        formatText(
            label: "Temperatur:",
            data: "${weatherData.temp_c}°C ${weatherData.temp_f}F"),
        Row(
          children: [
            formatText(label: "Icon:", data: ""),
            Image.network(weatherData.icon)
          ],
        ),
      ],
    );
  }
}
