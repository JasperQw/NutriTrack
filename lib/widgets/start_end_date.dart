import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:nutritrack/utils/colors.dart';

class StartEndDate extends StatefulWidget {
  final String from;
  final String to;
  const StartEndDate({super.key, required this.from, required this.to});

  @override
  State<StartEndDate> createState() => _StartEndDateState();
}

class _StartEndDateState extends State<StartEndDate> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(
                right: 30,
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    100,
                  ),
                ),
                color: black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.play_arrow,
                color: white,
                size: 25,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.from,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          height: 40,
          child: const DottedLine(
            direction: Axis.vertical,
            dashColor: white,
            alignment: WrapAlignment.start,
          ),
        ),
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(
                right: 30,
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    100,
                  ),
                ),
                color: black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.pause,
                color: white,
                size: 25,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.to,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
