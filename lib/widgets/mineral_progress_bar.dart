import 'package:flutter/material.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MineralProgressBar extends StatelessWidget {
  final String label;
  final double currentVal;
  final double targetVal;
  final String unit;

  const MineralProgressBar(
      {super.key,
      required this.label,
      required this.currentVal,
      required this.targetVal,
      required this.unit});

  @override
  Widget build(BuildContext context) {
    double curVal;
    Color color;
    if (currentVal > targetVal) {
      curVal = currentVal - targetVal;
      color = red;
    } else {
      curVal = currentVal;
      color = yellowishGreen;
    }

    return Column(
      children: [
        LinearPercentIndicator(
          percent: curVal / targetVal,
          barRadius: const Radius.circular(10),
          progressColor: color,
          animation: true,
        ),
        const SizedBox(
          height: 18,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            Text(
              "$curVal / $targetVal $unit",
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        )
      ],
    );
  }
}
