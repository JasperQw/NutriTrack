import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:nutritrack/widgets/completeness_bottom_sheet.dart';
import 'package:nutritrack/widgets/nutrient_bottom_sheet.dart';
import 'package:nutritrack/widgets/weight_loss_bottom_sheet.dart';

class GoalSelectContainer extends StatefulWidget {
  final String imagePath;
  final String title;
  final String desc;
  const GoalSelectContainer(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.desc});

  @override
  State<GoalSelectContainer> createState() => _GoalSelectContainerState();
}

class _GoalSelectContainerState extends State<GoalSelectContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModalBottomSheet(
          // elevation: 10,
          isScrollControlled: true,
          context: context,
          builder: (context) {
            if (widget.title == "Weight Loss") {
              return WeightLossBottomSheet(context: context);
            } else if (widget.title == "Completeness Target") {
              return CompletenessBottomSheet(context: context);
            } else {
              return NutrientBottomSheet(context: context);
            }
          }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: const BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(-5, 5),
              )
            ]),
        child: Row(
          children: [
            SvgPicture.asset(
              widget.imagePath,
              height: 54,
              width: 54,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      child: Text(
                        widget.desc,
                        style: const TextStyle(
                          color: white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
