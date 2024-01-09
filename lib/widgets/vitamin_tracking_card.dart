import 'package:flutter/material.dart';
import 'package:nutritrack/dto_classes/nutrient_classes.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:nutritrack/widgets/vitamin_progress_bar.dart';

class VitaminTrackingCard extends StatefulWidget {
  final Map<String, Nutrient> nutrientMap;
  const VitaminTrackingCard({super.key, required this.nutrientMap});

  @override
  State<VitaminTrackingCard> createState() => _VitaminTrackingCardState();
}

class _VitaminTrackingCardState extends State<VitaminTrackingCard> {
  late List<Widget> widgetList;
  late bool open = false;
  @override
  void initState() {
    widgetList = [
      VitaminProgrssBar(
        label: widget.nutrientMap["Vitamin A"]!.getLabel(),
        curVal: widget.nutrientMap["Vitamin A"]!.getCurVal(),
        targetVal: widget.nutrientMap["Vitamin A"]!.getTargetVal(),
        unit: widget.nutrientMap["Vitamin A"]!.getUnit(),
      ),
      const SizedBox(
        height: 32,
      ),
      VitaminProgrssBar(
        label: widget.nutrientMap["Vitamin B"]!.getLabel(),
        curVal: widget.nutrientMap["Vitamin B"]!.getCurVal(),
        targetVal: widget.nutrientMap["Vitamin B"]!.getTargetVal(),
        unit: widget.nutrientMap["Vitamin B"]!.getUnit(),
      ),
      const SizedBox(
        height: 32,
      ),
      VitaminProgrssBar(
        label: widget.nutrientMap["Vitamin C"]!.getLabel(),
        curVal: widget.nutrientMap["Vitamin C"]!.getCurVal(),
        targetVal: widget.nutrientMap["Vitamin C"]!.getTargetVal(),
        unit: widget.nutrientMap["Vitamin C"]!.getUnit(),
      ),
      const SizedBox(
        height: 32,
      ),
    ];

    super.initState();
  }

  @override
  void didUpdateWidget(covariant VitaminTrackingCard oldWidget) {
    if (widget.nutrientMap != oldWidget.nutrientMap) {
      setState(() {
        widgetList = [
          VitaminProgrssBar(
            label: widget.nutrientMap["Vitamin A"]!.getLabel(),
            curVal: widget.nutrientMap["Vitamin A"]!.getCurVal(),
            targetVal: widget.nutrientMap["Vitamin A"]!.getTargetVal(),
            unit: widget.nutrientMap["Vitamin A"]!.getUnit(),
          ),
          const SizedBox(
            height: 32,
          ),
          VitaminProgrssBar(
            label: widget.nutrientMap["Vitamin B"]!.getLabel(),
            curVal: widget.nutrientMap["Vitamin B"]!.getCurVal(),
            targetVal: widget.nutrientMap["Vitamin B"]!.getTargetVal(),
            unit: widget.nutrientMap["Vitamin B"]!.getUnit(),
          ),
          const SizedBox(
            height: 32,
          ),
          VitaminProgrssBar(
            label: widget.nutrientMap["Vitamin C"]!.getLabel(),
            curVal: widget.nutrientMap["Vitamin C"]!.getCurVal(),
            targetVal: widget.nutrientMap["Vitamin C"]!.getTargetVal(),
            unit: widget.nutrientMap["Vitamin C"]!.getUnit(),
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
          "Vitamins",
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
          onTap: () {
            setState(() {
              if (!open) {
                widgetList.addAll([
                  VitaminProgrssBar(
                    label: widget.nutrientMap["Vitamin D"]!.getLabel(),
                    curVal: widget.nutrientMap["Vitamin D"]!.getCurVal(),
                    targetVal: widget.nutrientMap["Vitamin D"]!.getTargetVal(),
                    unit: widget.nutrientMap["Vitamin D"]!.getUnit(),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  VitaminProgrssBar(
                    label: widget.nutrientMap["Vitamin E"]!.getLabel(),
                    curVal: widget.nutrientMap["Vitamin E"]!.getCurVal(),
                    targetVal: widget.nutrientMap["Vitamin E"]!.getTargetVal(),
                    unit: widget.nutrientMap["Vitamin E"]!.getUnit(),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  VitaminProgrssBar(
                    label: widget.nutrientMap["Vitamin F"]!.getLabel(),
                    curVal: widget.nutrientMap["Vitamin F"]!.getCurVal(),
                    targetVal: widget.nutrientMap["Vitamin F"]!.getTargetVal(),
                    unit: widget.nutrientMap["Vitamin F"]!.getUnit(),
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
            });
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
