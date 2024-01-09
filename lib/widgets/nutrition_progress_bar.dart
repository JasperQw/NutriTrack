import 'package:flutter/material.dart';

import 'package:nutritrack/utils/colors.dart';
import 'package:nutritrack/widgets/essential_bottom_sheet.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class NutritionTrackingProgressBar extends StatefulWidget {
  final String label;
  final double curVal;
  final double targetVal;
  final String unit;
  final Color color;
  const NutritionTrackingProgressBar(
      {super.key,
      required this.label,
      required this.curVal,
      required this.targetVal,
      required this.unit,
      required this.color});

  @override
  State<NutritionTrackingProgressBar> createState() =>
      _NutritionTrackingProgressBarState();
}

class _NutritionTrackingProgressBarState
    extends State<NutritionTrackingProgressBar> {
  @override
  Widget build(BuildContext context) {
    double currentVal;
    Color color;
    if (widget.curVal > widget.targetVal) {
      currentVal = widget.curVal - widget.targetVal;
      color = red;
    } else {
      currentVal = widget.curVal;
      color = yellowishGreen;
    }
    return InkWell(
      onTap: () => showModalBottomSheet(
        // elevation: 10,
        context: context,
        builder: (context) {
          return EssentialBottomSheet(
              unit: widget.unit,
              label: widget.label,
              curVal: widget.curVal,
              targetVal: widget.targetVal);
        },
      ),
      child: Column(
        children: [
          SizedBox(
            height: 250,
            width: 5,
            child: RotatedBox(
              quarterTurns: 3,
              child: LinearPercentIndicator(
                barRadius: const Radius.circular(10),
                percent: currentVal / widget.targetVal,
                backgroundColor: Colors.transparent,
                progressColor: color,
                animation: true,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.label,
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}
