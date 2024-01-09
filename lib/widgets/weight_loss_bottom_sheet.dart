import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:nutritrack/widgets/datetime_picker_widget.dart';
import 'package:nutritrack/widgets/goal_textfield_widget.dart';

class WeightLossBottomSheet extends StatefulWidget {
  final BuildContext context;
  const WeightLossBottomSheet({super.key, required this.context});

  @override
  State<WeightLossBottomSheet> createState() => _WeightLossBottomSheetState();
}

class _WeightLossBottomSheetState extends State<WeightLossBottomSheet> {
  late TextEditingController startDatePickerController;
  late TextEditingController endDatePickerController;
  late TextEditingController weightLossTargetController;
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
    weightLossTargetController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    startDatePickerController.dispose();
    endDatePickerController.dispose();
    weightLossTargetController.dispose();
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
                "Weight Loss",
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
            GoalTextFieldWidget(
                textEditingController: weightLossTargetController,
                hintText: "Weight Loss",
                unit: "kg"),
            Flexible(flex: 2, child: Container()),
            GestureDetector(
              onTap: () async {
                if (weightLossTargetController.text.isNotEmpty) {
                  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
                  FirebaseAuth authRef = FirebaseAuth.instance;
                  CollectionReference targetRef = firestoreRef
                      .collection("users")
                      .doc(authRef.currentUser!.uid)
                      .collection("targets");
                  await targetRef.add({
                    "type": "Weight Loss",
                    "from": startDatePickerController.text,
                    "to": endDatePickerController.text,
                    "target": {
                      "weightLoss":
                          double.parse(weightLossTargetController.text)
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
                    )),
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
