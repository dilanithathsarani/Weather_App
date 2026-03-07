import 'package:flutter/material.dart';
import 'package:weather_app/models/current_weather.dart';
import 'package:weather_app/models/prediction_model.dart';
import 'package:weather_app/services/weather_services.dart';

class PlaceView extends StatefulWidget {
  final PredictionModel prediction;
  const PlaceView({super.key, required this.prediction});

  @override
  State<PlaceView> createState() => _PlaceViewState();
}

class _PlaceViewState extends State<PlaceView> {
  late Future<WeatherStatus?> getCurrentWeather;

  @override
  void initState() {
    super.initState();
    getCurrentWeather = WeatherServices().getCurrentWeather(
      widget.prediction.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(alignment: Alignment.topLeft, child: BackButton()),

            FutureBuilder(
              future: getCurrentWeather,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError || snapshot.data == null) {
                  return SizedBox(
                    height: 200,
                    child: Center(child: Text('Something went wrong')),
                  );
                }

                WeatherStatus? currentWeather = snapshot.data!;
                return SizedBox(
                  height: 200,

                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${currentWeather.temp}°C',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Image.network(
                              currentWeather.condition.icon,
                              height: 40,
                              width: 40,
                            ),
                          ],
                        ),
                        Text(
                          currentWeather.condition.text,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        Text(
                          widget.prediction.name,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            Text(widget.prediction.country, style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
