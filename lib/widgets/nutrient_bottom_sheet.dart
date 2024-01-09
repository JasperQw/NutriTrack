import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:nutritrack/widgets/datetime_picker_widget.dart';
import 'package:nutritrack/widgets/specific_nutrient_goal_input.dart';

class NutrientBottomSheet extends StatefulWidget {
  final BuildContext context;
  const NutrientBottomSheet({super.key, required this.context});

  @override
  State<NutrientBottomSheet> createState() => _NutrientBottomSheetState();
}

class _NutrientBottomSheetState extends State<NutrientBottomSheet> {
  late TextEditingController startDatePickerController;
  late TextEditingController endDatePickerController;
  late TextEditingController nutrientTextController;
  late List<Widget> nutrientGoalList;
  List<TextEditingController> nutrientTextControllerList = [];
  List<String> dropDownNutrient = [
    "Protein",
    "Carbohydrate",
    "Vitamin C",
    "Sodium"
  ];
  Map<int, String> selectedDropdownNutrientMap = {};

  @override
  void initState() {
    startDatePickerController = TextEditingController();
    endDatePickerController = TextEditingController();
    startDatePickerController.text =
        DateFormat("dd-MM-yyyy").format(DateTime.now());
    endDatePickerController.text = DateFormat("dd-MM-yyyy").format(
      DateTime.now().add(
        const Duration(
          days: 1,
        ),
      ),
    );
    nutrientTextController = TextEditingController();
    nutrientGoalList = [];
    super.initState();
  }

  @override
  void dispose() {
    startDatePickerController.dispose();
    endDatePickerController.dispose();
    for (TextEditingController controller in nutrientTextControllerList) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget goalWidget(TextEditingController controller, int index) {
    nutrientTextControllerList.add(controller);
    selectedDropdownNutrientMap
        .addEntries(<int, String>{index: dropDownNutrient[0]}.entries);

    return SpecificNutrientGoalWidget(
      selectedDropdownNutrientMap: selectedDropdownNutrientMap,
      index: index,
      dropDownNutrient: dropDownNutrient,
      controller: controller,
      removeFunction: deleteWidget,
    );
  }

  void deleteWidget(int selectedIndex) {
    setState(() {
      int widgetIndex =
          selectedDropdownNutrientMap.keys.toList().indexOf(selectedIndex);
      nutrientTextControllerList.removeAt(widgetIndex);
      nutrientGoalList.removeAt(widgetIndex);
      selectedDropdownNutrientMap.remove(selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(widget.context).viewInsets.bottom,
                    ),
                    // height: MediaQuery.of(context).size.height * 0.8,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 40),
                          child: Text(
                            "Nutrient Goal",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DateTimePickerWidget(
                          dateTextEditingController: startDatePickerController,
                          label: "From",
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          height: 40,
                          child: const DottedLine(
                            direction: Axis.vertical,
                            dashColor: white,
                            alignment: WrapAlignment.start,
                          ),
                        ),
                        DateTimePickerWidget(
                          dateTextEditingController: endDatePickerController,
                          label: "To",
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text(
                            "Set Your Goal!",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Column(
                          children: nutrientGoalList,
                        ),
                        nutrientTextControllerList.length !=
                                dropDownNutrient.length
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (nutrientTextControllerList.length !=
                                        dropDownNutrient.length) {
                                      TextEditingController controller =
                                          TextEditingController();
                                      nutrientGoalList.add(goalWidget(
                                          controller,
                                          nutrientTextControllerList.length));
                                    }
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 80,
                                  margin: const EdgeInsets.only(top: 32),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                        20,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    "+",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: gray,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        GestureDetector(
                          onTap: () async {
                            if (nutrientTextControllerList.isEmpty) return;
                            Map<String, double> targets = {};
                            for (int i = 0;
                                i < nutrientTextControllerList.length;
                                i++) {
                              if (nutrientTextControllerList[i].text.isEmpty) {
                                return;
                              } else {
                                targets[selectedDropdownNutrientMap[i]!] =
                                    double.parse(
                                        nutrientTextControllerList[i].text);
                              }
                            }

                            FirebaseFirestore firestoreRef =
                                FirebaseFirestore.instance;
                            FirebaseAuth authRef = FirebaseAuth.instance;
                            CollectionReference targetRef = firestoreRef
                                .collection("users")
                                .doc(authRef.currentUser!.uid)
                                .collection("targets");
                            await targetRef.add({
                              "type": "Nutrient",
                              "from": startDatePickerController.text,
                              "to": endDatePickerController.text,
                              "target": targets,
                              "status": "active",
                              "created_at":
                                  DateTime.now().millisecondsSinceEpoch,
                              "track": []
                            });
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 32,
                            ),
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: blue,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  20,
                                ),
                              ),
                            ),
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
