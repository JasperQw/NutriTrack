import 'package:flutter/material.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:nutritrack/widgets/goal_textfield_widget.dart';

class SpecificNutrientGoalWidget extends StatefulWidget {
  final Map<int, String> selectedDropdownNutrientMap;
  final int index;
  final List<String> dropDownNutrient;
  final TextEditingController controller;
  final Function removeFunction;
  const SpecificNutrientGoalWidget(
      {super.key,
      required this.selectedDropdownNutrientMap,
      required this.index,
      required this.dropDownNutrient,
      required this.controller,
      required this.removeFunction});

  @override
  State<SpecificNutrientGoalWidget> createState() =>
      _SpecificNutrientGoalWidgetState();
}

class _SpecificNutrientGoalWidgetState
    extends State<SpecificNutrientGoalWidget> {
  late String selectedVal;

  @override
  void initState() {
    selectedVal = widget.dropDownNutrient[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 32, right: 15),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              value: selectedVal,
              onChanged: (value) {
                setState(() {
                  widget.selectedDropdownNutrientMap[widget.index] = value!;
                  selectedVal = value;
                });
              },
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  10,
                ),
              ),
              items: widget.dropDownNutrient
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: SizedBox(
                        width: 85,
                        child: Text(
                          e,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        Expanded(
          child: GoalTextFieldWidget(
            textEditingController: widget.controller,
            hintText: "Intake Percent",
            unit: "%",
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              widget.removeFunction(widget.index);
            });
          },
          child: Container(
            padding: const EdgeInsets.only(top: 32, left: 10),
            width: 30,
            alignment: Alignment.center,
            child: const Icon(
              Icons.close,
              color: gray,
            ),
          ),
        )
      ],
    );
  }
}
