import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:weather_app/models/current_weather.dart';
import 'package:weather_app/models/hourly_weather.dart';
import 'package:weather_app/models/prediction_model.dart';

class WeatherServices {
  String apiKey = '1f46f3c0acbf46c2bb2150301262502';

  Future<CurrentWeather?> getCurrentWeather(String query) async {
    final endpoint =
        'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$query';

    final response = await http.get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      CurrentWeather currentWeather = CurrentWeather.fromJson(body);
      //Logger().e(currentWeather.name );
      return currentWeather;
    } else {
      Logger().e('Failed to fetch weather data');
      return null;
    }
  }

  Future<List<PredictionModel>> getAutoComplete(String text) async {
    final endpoint =
        'http://api.weatherapi.com/v1/search.json?key=$apiKey&q=$text';

    final response = await http.get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(response.body);
      List<PredictionModel> predictions = result
          .map((data) => PredictionModel.fromJson(data))
          .toList();
      return predictions;
    } else {
      Logger().e(response.statusCode);
      return [];
    }
  }

  Future<List<HourlyWeather>> getHourlyWeather(String query) async {
    final endpoint =
        'http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$query&days=1&aqi=no&alerts=no';

        try {
          final response = await http.get(Uri.parse(endpoint));
          if (response.statusCode == 200) {
            Map<String, dynamic> body = jsonDecode(response.body);
            List<dynamic> hourlyData = body['forecast']['forecastday'][0]['hour'];
            List<HourlyWeather> hourlyWeatherList = hourlyData
                .map((e) => HourlyWeather.fromJson(e))
                .toList();
            Logger().e(hourlyWeatherList.length);
            return hourlyWeatherList;
          } else {
            Logger().e('Failed to fetch weather data');
            return [];
          }
        } catch (e) {
          Logger().e('Error: $e');
          return [];
        }
  }
}
