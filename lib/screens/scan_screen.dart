import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutritrack/resources/food_detection.dart';
import 'package:nutritrack/resources/food_functions.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:nutritrack/widgets/goal_textfield_widget.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  Uint8List? _image;
  late bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Detect Your Meal!",
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),
          Flexible(child: Container()),
          loading
              ? Container(
                  width: double.infinity,
                  height: 350,
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: white,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text("Detecting...")
                    ],
                  ))
              : InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () async {
                    try {
                      final ImagePicker imagePicker = ImagePicker();

                      XFile? file = await imagePicker.pickImage(
                          source: ImageSource.gallery);

                      if (file != null) {
                        Uint8List im = await file.readAsBytes();
                        setState(() {
                          _image = im;
                        });
                      }
                    } catch (e) {
                      print("Error");
                    }
                  },
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    alignment: Alignment.center,
                    height: 350,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          20,
                        ),
                      ),
                    ),
                    child: _image == null
                        ? SvgPicture.asset(
                            "assets/Gallery.svg",
                            height: 220,
                            width: 220,
                          )
                        : Image.memory(
                            _image!,
                            height: 350,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
          const SizedBox(
            height: 64,
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () async {
              setState(() {
                loading = true;
              });
              Map<String, dynamic> response =
                  await FoodDetection().foodDetectionAPI(_image!);

              if (response['code'] == 200) {
                List<String> result =
                    (response['message'] as String).split(",");

                List<TextEditingController> tecs = [];
                List<Widget> widgetList = [];
                FirebaseFirestore firestore = FirebaseFirestore.instance;
                for (int i = 0; i < result.length; i++) {
                  tecs.add(TextEditingController());
                  String foodName =
                      result[i][0].toUpperCase() + result[i].substring(1);
                  DocumentReference docs =
                      firestore.collection("food").doc(foodName);
                  DocumentSnapshot doc = await docs.get();

                  widgetList.add(Container(
                    margin: const EdgeInsets.only(bottom: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GoalTextFieldWidget(
                          textEditingController: tecs[i],
                          hintText: foodName,
                          unit: doc.get("measure"),
                          margin: true,
                        )
                      ],
                    ),
                  ));
                }
                if (context.mounted) {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      useSafeArea: true,
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, bottom: 15),
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Column(children: [
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
                                clipBehavior: Clip.hardEdge,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 15),
                                  child: Column(children: [
                                    ...widgetList,
                                    GestureDetector(
                                      onTap: () async {
                                        for (int i = 0; i < tecs.length; i++) {
                                          if (tecs[i].text.isEmpty) return;
                                        }

                                        for (int i = 0;
                                            i < result.length;
                                            i++) {
                                          String foodName =
                                              result[i][0].toUpperCase() +
                                                  result[i].substring(1);

                                          Map<String, dynamic> foodNutrients =
                                              await FoodFunctions()
                                                  .getNutrient(foodName);
                                          FoodFunctions().addIntake(
                                              double.parse(tecs[i].text),
                                              foodNutrients['essentials'],
                                              foodNutrients['vitamins'],
                                              foodNutrients['minerals']);
                                        }
                                        if (context.mounted) {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 14,
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
                                  ]),
                                ),
                              ),
                            ),
                          ]),
                        );
                      });
                }
              } else {
                print("error: ${response['message']}");
              }

              setState(() {
                loading = false;
              });
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
                "Detect",
                style: TextStyle(
                  color: white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Flexible(child: Container()),
        ],
      ),
    );
  }
}
