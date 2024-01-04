import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Details extends StatefulWidget {
  final DayDetails;
  const Details({Key? key, this.DayDetails}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  // var DetailsDayForcast =
  @override
  Widget build(BuildContext context) {
    var DetailsDayForcast = widget.DayDetails[0];
    int maxtemp = DetailsDayForcast["day"]["maxtemp_c"].toInt();
    int mintemp = DetailsDayForcast["day"]["mintemp_c"].toInt();
    String Sunrise = DetailsDayForcast["astro"]["sunrise"];
    String Sunset = DetailsDayForcast["astro"]["sunset"];
    String Moonrise = DetailsDayForcast["astro"]["moonrise"];
    String Moonset = DetailsDayForcast["astro"]["moonset"];
    int Chanceofrain = DetailsDayForcast["day"]["daily_chance_of_rain"].toInt();
    int Vision = DetailsDayForcast["day"]["avgvis_km"].toInt();
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 180,
                width: 180,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 20.0)],
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30),
                  color: Color.fromARGB(255, 54, 54, 54),
                  //color: Colors.transparent,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Sun Rise:",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffABCFF2),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          Sunrise,
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w900,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 180,
                width: 180,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 20.0)],
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30),
                  color: Color.fromARGB(255, 54, 54, 54),
                ),
                child: Column(

                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Sun Set:",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                          color: Color(0xffABCFF2),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          Sunset,
                          style: TextStyle(
                            //fontSize: 45,
                            fontSize: 35,
                            fontWeight: FontWeight.w900,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 180,
                width: 180,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 20.0)],
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30),
                  color: Color.fromARGB(255, 54, 54, 54),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Chance of rain:",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffABCFF2),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          Chanceofrain.toString() + ' %',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w900,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 180,
                width: 180,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 20.0)],
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30),
                  color: Color.fromARGB(255, 54, 54, 54),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Vision:",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                          color: Color(0xffABCFF2),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          Vision.toString() + ' km',
                          style: TextStyle(
                            fontSize:50,
                            fontWeight: FontWeight.w900,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 180,
                width: 180,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 20.0)],
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30),
                  color: Color.fromARGB(255, 54, 54, 54),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Max Temp:",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffABCFF2),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          maxtemp.toString() + '°',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w900,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 180,
                width: 180,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 20.0)],
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30),
                  color: Color.fromARGB(255, 54, 54, 54),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Min Temp:",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                          color: Color(0xffABCFF2),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          mintemp.toString() + '°',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w900,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
