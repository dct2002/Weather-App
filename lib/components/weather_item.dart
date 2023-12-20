import 'package:flutter/material.dart';

class WeatherItem extends StatelessWidget {
  final int value;
  final String unit;
  final String imageUrl;
  final String type;

  const WeatherItem({
    Key? key,
    required this.value,
    required this.unit,
    required this.imageUrl,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          height: 60,
          //width: 90,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Image.asset(imageUrl),
        ),
        const SizedBox(
          height: 6.0,
        ),
        Text(
          value.toString() + unit,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          type,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: Color.fromARGB(255, 210, 217, 224),
          ),
        ),
        const SizedBox(
          height: 8.0,
        )
      ],
    );
  }
}
