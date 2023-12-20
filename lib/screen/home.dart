import 'dart:convert';
import 'dart:ui';
import 'package:app_model/components/weather_details.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import '../components/weather_item.dart';
import '../constant.dart';
import '../screen/7day.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  // final String city;
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _cityController = TextEditingController();
  final Constants _constants = Constants();

  List<String> CityList = [];

  static String API_KEY = '0a02e6811f8f404f83275200230410'; //Paste Your API Here

  String location = 'Hanoi'; //Default location
  String weatherIcon = 'heavycloudy.png';
  String homeIcon = '';
  int temperature = 0;
  int windSpeed = 0;
  int humidity = 0;
  int cloud = 0;
  int uv = 0;
  String currentDate = '';
  int maxtemp = 0;
  int mintemp = 0;
  String IconWeatherAPI = '';
  // String IconAPI = '';

  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];

  String currentWeatherStatus = '';
  //var image_bg =  AssetImage("bg_weather.jpg");
  //API Call
  String searchWeatherAPI = "http://api.weatherapi.com/v1/forecast.json?key=" +
      API_KEY +
      "&days=7&q=";

  // darkmode
  bool isDarkMode = false;
  static const AssetImage bg1 = AssetImage("assets/background_weather.png");
  static const AssetImage bg2 = AssetImage("assets/bg_sun.png");

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      CityList = prefs.getStringList('myList') ?? [];
    });
  }

  void _saveData(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CityList.add(text);
    await prefs.setStringList('myList', CityList);
  }

  void _removeData(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      CityList.remove(text);
    });
    await prefs.setStringList('myList', CityList);
    Navigator.of(context).pop();
    _showList();
  }

  void _showList() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
              child: Column(
                children: [
                  Text(
                      'History',
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Colors.black,
                    height: 0.2,
                  ),
                ],
              )
          ),
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: Column(
              children: CityList.map(
                (text) => ListTile(
                  title: Text(text),
                  onTap: () {
                    Navigator.of(context).pop();
                    fetchWeatherData(text);
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete item?'),
                            content: Text('Do you want to delete this item?'),
                            actions: [
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Delete'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _removeData(text);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ).toList(),
            ),
          ),
        );
      },
    );
  }

  void fetchWeatherData(String searchText) async {
    try {
      var searchResult =
          await http.get(Uri.parse(searchWeatherAPI + searchText));

      final weatherData = Map<String, dynamic>.from(
          json.decode(searchResult.body) ?? 'No data');

      var locationData = weatherData["location"];

      var currentWeather = weatherData["current"];

      setState(() {
        location = getShortLocationName(locationData["name"]);

        var parsedDate =
            DateTime.parse(locationData["localtime"].substring(0, 10));
        var newDate = DateFormat('MMMMEEEEd').format(parsedDate);
        currentDate = newDate;

        //updateWeather
        currentWeatherStatus = currentWeather["condition"]["text"];
        // IconWeatherAPI = 'http:' + currentWeather["condition"]["icon"];
        IconWeatherAPI = "http://cdn.weatherapi.com/weather/64x64/day/113.png";
        weatherIcon =
            currentWeatherStatus.replaceAll(' ', '').toLowerCase() + ".png";
        temperature = currentWeather["temp_c"].toInt();
        windSpeed = currentWeather["wind_kph"].toInt();
        humidity = currentWeather["humidity"].toInt();
        cloud = currentWeather["cloud"].toInt();
        uv = currentWeather["uv"].toInt();

        //Forecast data
        dailyWeatherForecast = weatherData["forecast"]["forecastday"];
        hourlyWeatherForecast = dailyWeatherForecast[0]["hour"];
        var currentWeatherForcast = dailyWeatherForecast[0]["day"];
        maxtemp = currentWeatherForcast["maxtemp_c"].toInt();
        mintemp = currentWeatherForcast["mintemp_c"].toInt();
        print(dailyWeatherForecast);
      });
      await HomeWidget.saveWidgetData<String>('text', temperature.toString());
      await HomeWidget.saveWidgetData<String>('location', location.toString());
      await HomeWidget.saveWidgetData<String>(
          'des', currentWeatherStatus.toString());
      await HomeWidget.saveWidgetData<String>(
          'imageUrl', "https://cdn-icons-png.flaticon.com/512/263/263883.png");
    } catch (e) {
      //debugPrint(e);
    }
  }

  //function to return the first two names of the string location
  static String getShortLocationName(String s) {
    List<String> wordList = s.split(" ");

    if (wordList.isNotEmpty) {
      if (wordList.length > 1) {
        return wordList[0] + " " + wordList[1];
      } else {
        return wordList[0];
      }
    } else {
      return " ";
    }
  }

  @override
  void initState() {
    fetchWeatherData(location);
    _loadData();
    super.initState();
  }


  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    Size size = MediaQuery.of(context).size;
    //precacheImage(image_bg, context);
    return Scaffold(
      key: _scaffoldKey,
      //backgroundColor: Color.fromARGB(255, 40, 40, 40),
      drawer: Drawer(
        elevation: 20.0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[

            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue
              ),
                child: Center(
                  child: Text(
                    'Weather App',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
            ),
            ListTile(
              title: new Text(
                  "History",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              leading: new Icon(Icons.history),
              onTap: () {
                Navigator.pop(context);
                _showList();
              },
            ),
            Divider( height: 0.1,),

            // ListTile(
            //   title: new Text(
            //       "Notification"
            //   ),
            // )
            // ListTile(
            //   title: new Text("Primary"),
            //   leading: new Icon(Icons.inbox),
            // ),
            // ListTile(
            //   title: new Text("Social"),
            //   leading: new Icon(Icons.people),
            // ),
            // ListTile(
            //   title: new Text("Promotions"),
            //   leading: new Icon(Icons.local_offer),
            // )
          ],
        ),
      ),

      body: Container(
        // width: size.width,
        // height: size.height,
        // padding: const EdgeInsets.only(
        //   top: 40,
        //   left: 10,
        //   right: 10,
        // ),
        decoration: BoxDecoration(
          image: DecorationImage(
            //image: AssetImage("assets/background_weather.png"),
            image: isDarkMode ? bg1 : bg2,
            fit: BoxFit.cover,
          ),
        ),


        child: SingleChildScrollView(
          child: Container(
            height: 1450,
            //height: 900,
            // decoration: BoxDecoration(
            //   color: Colors.transparent,
            // ),
            padding: const EdgeInsets.only(
              top: 40,
              left: 10,
              right: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  height: size.height * .73,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(0.8, 1),
                      colors: <Color>[
                        // Color.fromARGB(255, 7, 124, 219),
                        // Color.fromARGB(255, 50, 150, 233),
                        // Color.fromARGB(255, 135, 190, 235),
                        // Color.fromARGB(255, 179, 211, 238),

                        //Color.fromARGB(255, 179, 211, 238),
                        Color.fromARGB(255, 135, 190, 235),
                        Color.fromARGB(255, 50, 150, 233),
                        Color.fromARGB(255, 7, 124, 219),

                      ],
                    ),
                    // image: DecorationImage(
                    //   image: image_bg,
                    //   fit: BoxFit.cover,
                    // ),
                    boxShadow: [
                      BoxShadow(color: Colors.black, blurRadius: 20.0)
                    ],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(30),
                    color: Color.fromARGB(255, 54, 54, 54),
                    //color: Colors.transparent,
                  ),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              // showMaterialModalBottomSheet(
                              //   context: context,
                              //   builder: (context) => Container(
                              //     height: size.width * 0.5,
                              //     width: size.width * 0.5,
                              //     color: Colors.white,
                              //     child: Column(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         ListView.builder(itemBuilder: itemBuilder)
                              //       ],
                              //     ),
                              //   ),
                              // );
                              //_showList();
                              _scaffoldKey.currentState?.openDrawer(); // Mở drawer khi nhấn button
                            },

                            icon: Icon(
                              Icons.menu,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/pin.png",
                                width: 20,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                location,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _cityController.clear();
                                  showMaterialModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          SingleChildScrollView(
                                            controller:
                                                ModalScrollController.of(
                                                    context),
                                            child: Container(
                                              height: size.height * .6,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 10,
                                              ),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    width: 70,
                                                    child: Divider(
                                                      thickness: 3.5,
                                                      color: _constants
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextField(
                                                    onChanged: (searchText) {
                                                      fetchWeatherData(
                                                          searchText);
                                                    },
                                                    onSubmitted: (searchText) {
                                                      setState(() {
                                                        _saveData(location);
                                                      });
                                                    },
                                                    controller: _cityController,
                                                    autofocus: true,
                                                    decoration: InputDecoration(
                                                        prefixIcon: Icon(
                                                          Icons.search,
                                                          color: _constants
                                                              .primaryColor,
                                                        ),
                                                        suffixIcon:
                                                            GestureDetector(
                                                          onTap: () =>
                                                              _cityController
                                                                  .clear(),
                                                          child: Icon(
                                                            Icons.close,
                                                            color: _constants
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                        hintText:
                                                            'Search city e.g. Hanoi',
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: _constants
                                                                .primaryColor,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ));
                                },
                                icon: const Icon(
                                  //Icons.keyboard_arrow_down,
                                  Icons.search,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          // IconButton(
                          //   onPressed: () {
                          //     // _saveData(location);
                          //   },
                          //   icon: const Icon(
                          //     Icons.add,
                          //     size: 25,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          Switch(
                            value: isDarkMode,
                            onChanged: (value) {
                              setState(() {
                                isDarkMode = value;
                              });
                            },
                            activeColor: Colors.blue,
                            activeTrackColor: Colors.lightBlueAccent,
                          ),
                        ],
                      ),
                      Text(
                        currentDate,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 20
                        ),
                      ),
                      SizedBox(
                        height: 160,
                        // child: Image.network(
                        //   IconWeatherAPI,
                        //   width: 160,
                        //   height: 160,
                        //   fit: BoxFit.cover,
                        // ),
                        child: Image.asset('assets/' + weatherIcon),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              temperature.toString(),
                              style: TextStyle(
                                fontSize: 80,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            'o',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              //color: Colors.white,
                              color: Colors.white.withOpacity(1),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'C',
                              style: TextStyle(
                                fontSize: 50,
                                //color: Colors.white.withOpacity(0.7),
                                color: Colors.white.withOpacity(1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        currentWeatherStatus,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      // Text(
                      //   currentDate,
                      //   style: const TextStyle(
                      //     color: Colors.white70,
                      //   ),
                      // ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Divider(
                          color: Colors.white70,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(255, 6, 89, 180),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WeatherItem(
                              value: windSpeed.toInt(),
                              unit: 'km/h',
                              imageUrl: 'assets/wind3.png',
                              type: 'wind',
                            ),
                            WeatherItem(
                              value: humidity.toInt(),
                              unit: '%',
                              imageUrl: 'assets/humidity.png',
                              type: 'humidity',
                            ),
                            WeatherItem(
                              value: cloud.toInt(),
                              unit: '%',
                              imageUrl: 'assets/cloud.png',
                              type: 'cloud',
                            ),
                            WeatherItem(
                              value: uv.toInt(),
                              unit: '',
                              imageUrl: 'assets/uv1.png',
                              type: "uv",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  height: size.height * .27,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Today',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23.0,
                                  color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                // MaterialPageRoute(
                                //     builder: (_) => DetailPage(
                                //           dailyForecastWeather:
                                //               dailyWeatherForecast,
                                //         ))
                                SlidePageRoute(
                                    page: DetailPage(
                                  dailyForecastWeather: dailyWeatherForecast,
                                )),
                              ), //this will open forecast screen
                              child: Text(
                                'Next days >',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 19,
                                    color: Colors.white.withOpacity(0.7)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Opacity(
                          opacity: 0.8,
                          child: SizedBox(
                            height: 130,
                            child: ListView.builder(
                              itemCount: hourlyWeatherForecast.length,
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                String currentTime =
                                    DateFormat('HH:mm:ss').format(DateTime.now());
                                String currentHour = currentTime.substring(0, 2);

                                String forecastTime = hourlyWeatherForecast[index]
                                        ["time"]
                                    .substring(11, 16);
                                String forecastHour = hourlyWeatherForecast[index]
                                        ["time"]
                                    .substring(11, 13);

                                String forecastWeatherName =
                                    hourlyWeatherForecast[index]["condition"]
                                        ["text"];
                                String forecastWeatherIcon = forecastWeatherName
                                        .replaceAll(' ', '')
                                        .toLowerCase() +
                                    ".png";

                                String forecastTemperature =
                                    hourlyWeatherForecast[index]["temp_c"]
                                        .round()
                                        .toString();
                                String forecastChancerain =
                                    hourlyWeatherForecast[index]["chance_of_rain"]
                                    .toString();
                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  margin: const EdgeInsets.only(right: 7),
                                  width: 70,
                                  //width: 80,
                                  decoration: BoxDecoration(
                                      //color: currentHour == forecastHour
                                          // ? Color.fromARGB(255, 94, 180, 250)
                                          // : Color.fromARGB(255, 88, 88, 88),
                                      color: Color.fromARGB(255, 49, 50, 51),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, 1),

                                          blurRadius: 5,
                                          color: _constants.primaryColor
                                              .withOpacity(.2),
                                        ),
                                      ]),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        forecastTime,
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: _constants.greyColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/' + forecastWeatherIcon,
                                        width: 30,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/umbrella.png',
                                            width: 15,
                                          ),

                                          Text(
                                            forecastChancerain + '%',
                                            style: TextStyle(
                                              //color: _constants.primaryColor,
                                              color: Colors.yellow[100],
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            forecastTemperature,
                                            style: TextStyle(
                                              color: _constants.greyColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            '°',
                                            style: TextStyle(
                                              color: _constants.greyColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 25,
                                              fontFeatures: const [
                                                FontFeature.enable('sups'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Opacity(
                  opacity: 0.8,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Details",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Details(
                          DayDetails: dailyWeatherForecast,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SlidePageRoute extends PageRouteBuilder {
  final Widget page;

  SlidePageRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
