import 'package:flutter/material.dart';
import 'package:nutritrack/dto_classes/nutrient_classes.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:nutritrack/widgets/nutrition_progress_bar.dart';

class EssentialNutrientCard extends StatefulWidget {
  final Map<String, Nutrient> nutrientMap;
  const EssentialNutrientCard({super.key, required this.nutrientMap});

  @override
  State<EssentialNutrientCard> createState() => _EssentialNutrientCardState();
}

class _EssentialNutrientCardState extends State<EssentialNutrientCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: secondaryColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Essentials",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 32,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                NutritionTrackingProgressBar(
                  label: widget.nutrientMap["Protein"]!.getLabel(),
                  curVal: widget.nutrientMap["Protein"]!.getCurVal(),
                  targetVal: widget.nutrientMap["Protein"]!.getTargetVal(),
                  unit: widget.nutrientMap["Protein"]!.getUnit(),
                  color: widget.nutrientMap["Protein"]!.getColor(),
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                NutritionTrackingProgressBar(
                  label: widget.nutrientMap["Carbo"]!.getLabel(),
                  curVal: widget.nutrientMap["Carbo"]!.getCurVal(),
                  targetVal: widget.nutrientMap["Carbo"]!.getTargetVal(),
                  unit: widget.nutrientMap["Carbo"]!.getUnit(),
                  color: widget.nutrientMap["Carbo"]!.getColor(),
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                NutritionTrackingProgressBar(
                  label: widget.nutrientMap["Fat"]!.getLabel(),
                  curVal: widget.nutrientMap["Fat"]!.getCurVal(),
                  targetVal: widget.nutrientMap["Fat"]!.getTargetVal(),
                  unit: widget.nutrientMap["Fat"]!.getUnit(),
                  color: widget.nutrientMap["Fat"]!.getColor(),
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                NutritionTrackingProgressBar(
                  label: widget.nutrientMap["Calories"]!.getLabel(),
                  curVal: widget.nutrientMap["Calories"]!.getCurVal(),
                  targetVal: widget.nutrientMap["Calories"]!.getTargetVal(),
                  unit: widget.nutrientMap["Calories"]!.getUnit(),
                  color: widget.nutrientMap["Calories"]!.getColor(),
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                NutritionTrackingProgressBar(
                  label: widget.nutrientMap["Water"]!.getLabel(),
                  curVal: widget.nutrientMap["Water"]!.getCurVal(),
                  targetVal: widget.nutrientMap["Water"]!.getTargetVal(),
                  unit: widget.nutrientMap["Water"]!.getUnit(),
                  color: widget.nutrientMap["Water"]!.getColor(),
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
