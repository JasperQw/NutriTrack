import 'package:flutter/material.dart';
import 'package:nutritrack/utils/colors.dart';

class TrackingDateCard extends StatelessWidget {
  final int date;
  final String dayOfWeek;

  const TrackingDateCard(
      {super.key, required this.date, required this.dayOfWeek});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color cardColor;

    if (date == 12) {
      textColor = white;
      cardColor = blue;
    } else {
      textColor = gray;
      cardColor = white;
    }

    return Container(
      height: 55,
      width: 45,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: cardColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            date.toString(),
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            dayOfWeek,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
