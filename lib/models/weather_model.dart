import 'package:weather_app/models/current_weather.dart';

class WeatherModel {
  CurrentWeather currentWeather;
  List<CurrentWeather> hourlyWeatherData;

  WeatherModel({
    required this.currentWeather,
    required this.hourlyWeatherData,
  });
}
