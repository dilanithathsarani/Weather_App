import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/current_weather.dart';
import 'package:weather_app/models/hourly_weather.dart';
import 'package:weather_app/models/prediction_model.dart';
import 'package:weather_app/screens/place_view.dart';
import 'package:weather_app/services/weather_services.dart';

class HomePage extends StatefulWidget {
  final CurrentWeather currentWeather;
  const HomePage({super.key, required this.currentWeather});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Future<List<HourlyWeather>> hourlyWeatherList;
  TextEditingController queryController = TextEditingController();
  List<PredictionModel> predictions = [];

  @override
  void initState() {
    super.initState();
    hourlyWeatherList = WeatherServices().getHourlyWeather(widget.currentWeather.name);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 380,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 350,
                    decoration: BoxDecoration(color: Colors.black),
                    child: Stack(
                      children: [
                        ClipRect(
                          child: Lottie.asset(
                            'assets/lotties/rainy_night.json',
                            width: double.infinity,
                            fit: BoxFit.fill,
                            height: 350,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.currentWeather.name,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      widget.currentWeather.condition.text,
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey.shade300,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 6,
                                        right: 2,
                                      ),
                                      child: Text(
                                        '${widget.currentWeather.temp}°C',
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey.shade300,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Image.network(
                                      widget.currentWeather.condition.icon,
                                      height: 25,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.black45,
                                  child: Icon(
                                    Icons.menu_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Weather App',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    WeatherServices().getCurrentWeather(
                                      'Colombo',
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      'https://www.perfocal.com/blog/content/images/size/w960/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),

                            child: Card(
                              color: Colors.white,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.65,
                                      child: TextField(
                                        controller: queryController,
                                        decoration: InputDecoration(
                                          hintText: 'Search Here....',
                                          border: InputBorder.none,
                                        ),
                                        cursorColor: Colors.grey.shade800,
                                        onChanged: (value) async {
                                          if (value.isNotEmpty) {
                                            predictions =
                                                await WeatherServices()
                                                    .getAutoComplete(value);
                                          } else {
                                            predictions.clear();
                                          }
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    Icon(
                                      Icons.search,
                                      color: Colors.grey.shade800,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (predictions.isNotEmpty && queryController.text.isNotEmpty)
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlaceView(prediction: predictions[index]),
                          ),
                        );
                        setState(() {
                          queryController.clear();
                        });
                      },
                      title: Text(predictions[index].name),
                      subtitle: Text(predictions[index].country),
                    );
                  },
                ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 8.0),

                    child: Text(
                      'Hourly Weather Forecast',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: hourlyWeatherList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } if (snapshot.hasError || snapshot.data == null) {
                        return Center(
                          child: Text('Something went wrong!'),
                        );
                      } if (snapshot.data!.isEmpty) {
                        return Center(
                          child: Text('No hourly weather data available.'),
                        );
                      }
                      List<HourlyWeather> hourlyWeather = snapshot.data!;
                      return SizedBox(
                        height: 136,
                        child: ListView.builder(
                          itemCount: hourlyWeather.length ,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: GestureDetector(
                                  onTap: () {
                                    WeatherServices().getHourlyWeather(
                                      widget.currentWeather.name,
                                    );
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${hourlyWeather[index].time.hour}:00',
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey.shade800,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Image.network(
                                          hourlyWeather[index].condition.icon,
                                          height: 40,
                                        ),
                                        Text(
                                          '${hourlyWeather[index].temp}°C',
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey.shade800,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
