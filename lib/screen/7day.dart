import 'dart:ui';

import 'package:flutter/material.dart';
import '../components/weather_item.dart';
import '../constant.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final dailyForecastWeather;

  const DetailPage({Key? key, this.dailyForecastWeather}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final Constants _constants = Constants();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var weatherData = widget.dailyForecastWeather;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/bg_cloud.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          //backgroundColor: Color.fromARGB(255, 161, 196, 203),
          backgroundColor: Colors.transparent,
          title: const Text(
            'Next days',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30
            ),
          ),

          // automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Container(
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("assets/bg_cloud.png"),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          padding: const EdgeInsets.only(
            //top: 40,
            left: 10,
            right: 10,
          ),
          child: Container(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(
                //   height: 10,
                // ),
                Container(
                  padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  height: size.height * .45,
                  width: size.width,

                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(0.8, 1),
                      colors: <Color>[
                        Color.fromARGB(255, 179, 211, 238),
                        Color.fromARGB(255, 135, 190, 235),
                        Color.fromARGB(255, 50, 150, 233),
                        Color.fromARGB(255, 7, 124, 219),

                      ],
                    ),
                    // image: DecorationImage(
                    //   image: image_bg,
                    //   fit: BoxFit.cover,
                    // ),

                    // boxShadow: [
                    //   BoxShadow(color: Colors.black, blurRadius: 20.0)
                    // ],
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(5, 10),
                        blurRadius: 10,
                      ),
                    ],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(50),
                    color: Color.fromARGB(255, 54, 54, 54),
                  ),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              height: 120,
                              child: Image.asset('assets/' + weatherData[1]["day"]["condition"]["text"]
                                  .replaceAll(' ', '')
                                  .toLowerCase() +
                                  ".png"),
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Tomorrow',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(
                                        weatherData[1]["day"]["avgtemp_c"].round().toString(),
                                        style: const TextStyle(
                                          fontSize: 65,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 30.0),
                                      child: Text(
                                        'o',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  weatherData[1]["day"]["condition"]["text"],
                                  style: TextStyle(color: Colors.white70, fontSize: 18),
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          child: const Divider(
                            color: Colors.white70,
                            height: 2,
                            thickness: 1,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          // decoration: BoxDecoration(
                          //   shape: BoxShape.rectangle,
                          //   borderRadius: BorderRadius.circular(20),
                          //   color: Color.fromARGB(255, 6, 89, 180),
                          // ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WeatherItem(
                                value: weatherData[1]["day"]["maxwind_kph"].toInt(),
                                unit: 'km/h',
                                imageUrl: 'assets/wind3.png',
                                type: 'wind',
                              ),
                              WeatherItem(
                                value: weatherData[1]["day"]["avghumidity"].toInt(),
                                unit: '%',
                                imageUrl: 'assets/humidity.png',
                                type: 'humidity',
                              ),
                              WeatherItem(
                                value: weatherData[1]["day"]["daily_chance_of_rain"].toInt(),
                                unit: '%',
                                imageUrl: 'assets/umbrella.png',

                                type: 'change of rain',
                              ),
                              // WeatherItem(
                              //   value: uv.toInt(),
                              //   unit: '',
                              //   imageUrl: 'assets/uv1.png',
                              // ),
                            ],
                          ),
                        ),
                      ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: size.height * .415,
                  //child: Container(
                    // decoration: const BoxDecoration(
                    //   image: DecorationImage(
                    //     image: AssetImage("assets/bg_cloud.png"),
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    child: ListView.builder(
                      itemCount: weatherData.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 60,
                          //padding: const EdgeInsets.only(top: 10),

                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          // color: Colors.amber,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(5, 10),
                                blurRadius: 10,
                              ),
                            ],
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(30),
                            //color: Color.fromARGB(255, 50, 150, 233),
                            color: Color.fromARGB(255, 134, 175, 217),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                //DateFormat('EEEE, d MMMM')
                                DateFormat('EEE')
                                    .format(
                                    DateTime.parse(weatherData[index]["date"]))
                                    .toString(),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),

                              Container(
                                width: 140,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage('assets/' +
                                          weatherData[index]["day"]["condition"]["text"]
                                              .replaceAll(' ', '')
                                              .toLowerCase() +
                                          ".png"),
                                      width: 50,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    // Text(
                                    //   weatherData[index]["day"]["condition"]["text"].substring(0, 5),
                                    //   style: TextStyle(color: Colors.white, fontSize: 18),
                                    // )
                                  ],
                                ),
                              ),
                              Container(
                                width: 140,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            weatherData[index]["day"]["mintemp_c"]
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          'o',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            '-' +
                                                weatherData[index]["day"]["maxtemp_c"]
                                                    .toString(),
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'o',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                //),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
