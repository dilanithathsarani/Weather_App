import 'package:weather_app/models/current_weather.dart';

class WeatherModel {
  WeatherStatus currentWeather;
  List<WeatherStatus> hourlyWeatherData;

  WeatherModel({required this.currentWeather, required this.hourlyWeatherData});
}
