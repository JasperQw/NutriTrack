import 'package:flutter/material.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class VitaminProgrssBar extends StatefulWidget {
  final String label;
  final double curVal;
  final double targetVal;
  final String unit;

  const VitaminProgrssBar(
      {super.key,
      required this.label,
      required this.curVal,
      required this.targetVal,
      required this.unit});

  @override
  State<VitaminProgrssBar> createState() => _VitaminProgrssBarState();
}

class _VitaminProgrssBarState extends State<VitaminProgrssBar> {
  @override
  Widget build(BuildContext context) {
    double curVal;
    Color color;
    if (widget.curVal > widget.targetVal) {
      curVal = widget.curVal - widget.targetVal;
      color = red;
    } else {
      curVal = widget.curVal;
      color = yellowishGreen;
    }

    return Column(
      children: [
        LinearPercentIndicator(
          percent: curVal / widget.targetVal,
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
              widget.label,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            Text(
              "$curVal / ${widget.targetVal} ${widget.unit}",
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
