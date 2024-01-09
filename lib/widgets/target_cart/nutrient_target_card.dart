import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:nutritrack/screens/nutrient_target_detail.dart';

import 'package:nutritrack/utils/colors.dart';

class NutrientTargetCard extends StatefulWidget {
  final String from;
  final String to;
  final int amount;
  final String id;

  const NutrientTargetCard(
      {super.key,
      required this.from,
      required this.to,
      required this.amount,
      required this.id});

  @override
  State<NutrientTargetCard> createState() => _NutrientTargetCardState();
}

class _NutrientTargetCardState extends State<NutrientTargetCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return NutrientTargetDetailScreen(
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
                "Nutrient Number(s):",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "${widget.amount}",
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
