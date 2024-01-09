import 'package:flutter/material.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class EssentialProgressBar extends StatefulWidget {
  final String label;
  final double currentVal;
  final double targetVal;
  final String unit;

  const EssentialProgressBar(
      {super.key,
      required this.label,
      required this.currentVal,
      required this.targetVal,
      required this.unit});

  @override
  State<EssentialProgressBar> createState() => _EssentialProgressBarState();
}

class _EssentialProgressBarState extends State<EssentialProgressBar> {
  @override
  Widget build(BuildContext context) {
    double curVal;
    Color color;
    if (widget.currentVal > widget.targetVal) {
      curVal = widget.currentVal - widget.targetVal;
      color = lightRed;
    } else {
      curVal = widget.currentVal;
      color = yellowishGreen;
    }

    return Column(
      children: [
        LinearPercentIndicator(
          lineHeight: 20,
          percent: curVal / widget.targetVal,
          barRadius: const Radius.circular(20),
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
              style: const TextStyle(fontSize: 20, color: white),
            ),
            Text(
              "${widget.currentVal} / ${widget.targetVal} ${widget.unit}",
              style: const TextStyle(fontSize: 20, color: white),
            ),
          ],
        )
      ],
    );
  }
}
