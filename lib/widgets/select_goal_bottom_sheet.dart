import 'package:flutter/material.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:nutritrack/widgets/goal_select_container.dart';

class SelectGoalBottomSheet extends StatefulWidget {
  const SelectGoalBottomSheet({super.key});

  @override
  State<SelectGoalBottomSheet> createState() => _SelectGoalBottomSheetState();
}

class _SelectGoalBottomSheetState extends State<SelectGoalBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.9,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(15),
            width: 120,
            child: Container(
              width: 120,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: gray,
              ),
            ),
          ),
          const SizedBox(
            height: 64,
          ),
          const Text(
            "Choose Type of Goal!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 64,
          ),
          const GoalSelectContainer(
              imagePath: "assets/Weight_loss.svg",
              title: "Weight Loss",
              desc:
                  "Monitoring your nutrient intake while observing your weight change!"),
          const SizedBox(
            height: 32,
          ),
          const GoalSelectContainer(
              imagePath: "assets/Completeness.svg",
              title: "Completeness Target",
              desc: "Create your strike on nutrient intake completeness!"),
          const SizedBox(
            height: 32,
          ),
          const GoalSelectContainer(
              imagePath: "assets/Nutrient_intake.svg",
              title: "Nutrient Intake",
              desc:
                  "Reminding yourself to take adequate amount of specific nutrient!"),
        ],
      ),
    );
  }
}
