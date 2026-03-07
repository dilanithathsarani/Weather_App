import 'package:weather_app/models/current_weather.dart';

class WeatherModel {
  CurrentWeather currentWeather;
  List<CurrentWeather> hourlyWeatherData;

  WeatherModel({required this.currentWeather, required this.hourlyWeatherData});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      currentWeather: CurrentWeather.fromJson(json['current']),
      hourlyWeatherData: [], // You can implement this based on your API response
    );
  }
}
