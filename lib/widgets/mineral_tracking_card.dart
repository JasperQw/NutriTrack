import 'package:flutter/material.dart';
import 'package:nutritrack/dto_classes/nutrient_classes.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:nutritrack/widgets/mineral_progress_bar.dart';

class MineralTrackingCard extends StatefulWidget {
  final Map<String, Nutrient> nutrientMap;
  const MineralTrackingCard({super.key, required this.nutrientMap});

  @override
  State<MineralTrackingCard> createState() => _MineralTrackingCardState();
}

class _MineralTrackingCardState extends State<MineralTrackingCard> {
  late List<Widget> widgetList;
  late bool open = false;

  @override
  void initState() {
    widgetList = [
      MineralProgressBar(
        label: widget.nutrientMap["Sodium"]!.getLabel(),
        currentVal: widget.nutrientMap["Sodium"]!.getCurVal(),
        targetVal: widget.nutrientMap["Sodium"]!.getTargetVal(),
        unit: widget.nutrientMap["Sodium"]!.getUnit(),
      ),
      const SizedBox(
        height: 32,
      ),
      MineralProgressBar(
        label: widget.nutrientMap["Magnesium"]!.getLabel(),
        currentVal: widget.nutrientMap["Magnesium"]!.getCurVal(),
        targetVal: widget.nutrientMap["Magnesium"]!.getTargetVal(),
        unit: widget.nutrientMap["Magnesium"]!.getUnit(),
      ),
      const SizedBox(
        height: 32,
      ),
      MineralProgressBar(
        label: widget.nutrientMap["Calcium"]!.getLabel(),
        currentVal: widget.nutrientMap["Calcium"]!.getCurVal(),
        targetVal: widget.nutrientMap["Calcium"]!.getTargetVal(),
        unit: widget.nutrientMap["Calcium"]!.getUnit(),
      ),
      const SizedBox(
        height: 32,
      ),
    ];
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MineralTrackingCard oldWidget) {
    if (widget.nutrientMap != oldWidget.nutrientMap) {
      setState(() {
        widgetList = [
          MineralProgressBar(
            label: widget.nutrientMap["Sodium"]!.getLabel(),
            currentVal: widget.nutrientMap["Sodium"]!.getCurVal(),
            targetVal: widget.nutrientMap["Sodium"]!.getTargetVal(),
            unit: widget.nutrientMap["Sodium"]!.getUnit(),
          ),
          const SizedBox(
            height: 32,
          ),
          MineralProgressBar(
            label: widget.nutrientMap["Magnesium"]!.getLabel(),
            currentVal: widget.nutrientMap["Magnesium"]!.getCurVal(),
            targetVal: widget.nutrientMap["Magnesium"]!.getTargetVal(),
            unit: widget.nutrientMap["Magnesium"]!.getUnit(),
          ),
          const SizedBox(
            height: 32,
          ),
          MineralProgressBar(
            label: widget.nutrientMap["Calcium"]!.getLabel(),
            currentVal: widget.nutrientMap["Calcium"]!.getCurVal(),
            targetVal: widget.nutrientMap["Calcium"]!.getTargetVal(),
            unit: widget.nutrientMap["Calcium"]!.getUnit(),
          ),
          const SizedBox(
            height: 32,
          ),
        ];
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Minerals",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 54,
        ),
        ...widgetList,
        GestureDetector(
          onTap: () => {
            setState(() {
              if (!open) {
                widgetList.addAll([
                  MineralProgressBar(
                    label: widget.nutrientMap["Potassium"]!.getLabel(),
                    currentVal: widget.nutrientMap["Potassium"]!.getCurVal(),
                    targetVal: widget.nutrientMap["Potassium"]!.getTargetVal(),
                    unit: widget.nutrientMap["Potassium"]!.getUnit(),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  MineralProgressBar(
                    label: widget.nutrientMap["Phosphorus"]!.getLabel(),
                    currentVal: widget.nutrientMap["Phosphorus"]!.getCurVal(),
                    targetVal: widget.nutrientMap["Phosphorus"]!.getTargetVal(),
                    unit: widget.nutrientMap["Phosphorus"]!.getUnit(),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  MineralProgressBar(
                    label: widget.nutrientMap["Sulfur"]!.getLabel(),
                    currentVal: widget.nutrientMap["Sulfur"]!.getCurVal(),
                    targetVal: widget.nutrientMap["Sulfur"]!.getTargetVal(),
                    unit: widget.nutrientMap["Sulfur"]!.getUnit(),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                ]);
              } else {
                for (int i = 0; i < 6; i++) {
                  widgetList.removeLast();
                }
              }
              open = !open;
            })
          },
          child: Text(
            open ? "Less" : "More",
            style: const TextStyle(color: blue, fontSize: 18),
          ),
        )
      ],
    );
  }
}
