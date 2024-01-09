import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutritrack/screens/target_detail_screen.dart';
import 'package:nutritrack/utils/colors.dart';

class WeightLossCard extends StatefulWidget {
  final String from;
  final String to;
  final double target;
  final String id;

  const WeightLossCard({
    super.key,
    required this.from,
    required this.to,
    required this.target,
    required this.id,
  });

  @override
  State<WeightLossCard> createState() => _WeightLossCardState();
}

class _WeightLossCardState extends State<WeightLossCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return TargetDetailScreen(
            id: widget.id,
          );
        }));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 30,
        ),
        margin: const EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(color: white, width: 1),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "From",
                  style: TextStyle(
                    fontSize: 12,
                    color: gray,
                  ),
                ),
                Text(
                  widget.from,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
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
                const Text(
                  "To",
                  style: TextStyle(
                    fontSize: 12,
                    color: gray,
                  ),
                ),
                Text(
                  widget.to,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Weight Loss:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "${widget.target} kg",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )
            ],
          ))
        ]),
      ),
    );
  }
}
