import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:nutritrack/widgets/datetime_picker_widget.dart';
import 'package:nutritrack/widgets/goal_textfield_widget.dart';

class CompletenessBottomSheet extends StatefulWidget {
  final BuildContext context;
  const CompletenessBottomSheet({super.key, required this.context});

  @override
  State<CompletenessBottomSheet> createState() =>
      _CompletenessBottomSheetState();
}

class _CompletenessBottomSheetState extends State<CompletenessBottomSheet> {
  late TextEditingController startDatePickerController;
  late TextEditingController endDatePickerController;
  late TextEditingController completenessTextController;
  late String dropdownVal;
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
    completenessTextController = TextEditingController();
    dropdownVal = "All";
    super.initState();
  }

  @override
  void dispose() {
    startDatePickerController.dispose();
    endDatePickerController.dispose();
    completenessTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(widget.context).viewInsets.bottom,
        ),
        height: MediaQuery.of(context).size.height * 0.8,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 40),
              child: Text(
                "Completeness Target",
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
            Row(
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
                      value: dropdownVal,
                      onChanged: (value) {
                        setState(() {
                          dropdownVal = value!;
                        });
                      },
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          10,
                        ),
                      ),
                      items: ["All", "Essentials", "Vitamins", "Minerals"]
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
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
                    textEditingController: completenessTextController,
                    hintText: "Completeness Percent",
                    unit: "%",
                  ),
                ),
              ],
            ),
            Flexible(flex: 2, child: Container()),
            GestureDetector(
              onTap: () async {
                if (completenessTextController.text.isNotEmpty) {
                  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
                  FirebaseAuth authRef = FirebaseAuth.instance;
                  CollectionReference targetRef = firestoreRef
                      .collection("users")
                      .doc(authRef.currentUser!.uid)
                      .collection("targets");
                  await targetRef.add({
                    "type": "Completeness",
                    "from": startDatePickerController.text,
                    "to": endDatePickerController.text,
                    "target": {
                      dropdownVal: double.parse(completenessTextController.text)
                    },
                    "status": "active",
                    "created_at": DateTime.now().millisecondsSinceEpoch,
                    "track": []
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Container(
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
            Flexible(
              flex: 1,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
