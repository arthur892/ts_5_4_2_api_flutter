class WeatherData {
  String name;
  String region;
  String country;
  double lat;
  double lon;
  String tz_id;
  String localtime;
  double temp_c;
  double temp_f;
  String icon;

  WeatherData(
      {required this.name,
      required this.region,
      required this.country,
      required this.lat,
      required this.lon,
      required this.tz_id,
      required this.localtime,
      required this.temp_c,
      required this.temp_f,
      required this.icon});
}
