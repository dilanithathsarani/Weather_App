import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:weather_app/models/current_weather.dart';

class WeatherServices {
  Future<CurrentWeather?> getCurrentWeather(String query) async {
    final endpoint =
        'http://api.weatherapi.com/v1/current.json?key=1f46f3c0acbf46c2bb2150301262502&q=$query';

    final response = await http.get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      CurrentWeather currentWeather = CurrentWeather.fromJson(body);
      Logger().e(currentWeather.name );
      return currentWeather;
    } else {
      Logger().e('Failed to fetch weather data');
      return null;
    }
  }
}
