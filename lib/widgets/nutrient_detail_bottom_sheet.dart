import 'package:flutter/material.dart';
import 'package:nutritrack/resources/food_functions.dart';
import 'package:nutritrack/utils/colors.dart';

class NutrientDetailBottomSheet extends StatefulWidget {
  final BuildContext context;
  final String foodName;
  final String imagePath;
  final String measure;

  const NutrientDetailBottomSheet(
      {super.key,
      required this.context,
      required this.foodName,
      required this.imagePath,
      required this.measure});

  @override
  State<NutrientDetailBottomSheet> createState() =>
      _NutrientDetailBottomSheetState();
}

class _NutrientDetailBottomSheetState extends State<NutrientDetailBottomSheet> {
  late Map<String, dynamic> essentials = {};
  late Map<String, dynamic> vitamins = {};
  late Map<String, dynamic> minerals = {};
  late TextEditingController amountController;

  @override
  void initState() {
    loadGetNutrient();
    amountController = TextEditingController();
    super.initState();
  }

  loadGetNutrient() async {
    Map<String, dynamic> foodNutrients =
        await FoodFunctions().getNutrient(widget.foodName);
    setState(() {
      essentials = foodNutrients['essentials'];
      vitamins = foodNutrients['vitamins'];
      minerals = foodNutrients['minerals'];
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(widget.context).viewInsets.bottom,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      20,
                    ),
                    topRight: Radius.circular(
                      20,
                    ),
                  ),
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            widget.imagePath,
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Container(
                                    height: 300,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 50, horizontal: 30),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Intake Amount",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(40),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black54,
                                                  blurRadius: 10,
                                                  spreadRadius: 1,
                                                ),
                                              ]),
                                          child: TextField(
                                            controller: amountController,
                                            keyboardType: TextInputType.number,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            onTapOutside: (event) {
                                              FocusScope.of(context).unfocus();
                                            },
                                            cursorColor: white,
                                            decoration: InputDecoration(
                                              errorBorder:
                                                  const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                borderSide: BorderSide.none,
                                              ),
                                              suffix: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 30.0),
                                                child: Text(
                                                  widget.measure,
                                                ),
                                              ),
                                              suffixStyle: const TextStyle(
                                                fontSize: 13,
                                                color: white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              filled: true,
                                              fillColor: black,
                                              labelStyle: const TextStyle(
                                                  color: Colors.white70),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                left: 20,
                                                top: 20,
                                                bottom: 20,
                                              ),
                                              border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                borderSide: BorderSide.none,
                                              ),
                                              label: const Text(
                                                "Amount",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (amountController.text == "") {
                                            } else {
                                              FoodFunctions().addIntake(
                                                  double.parse(
                                                      amountController.text),
                                                  essentials,
                                                  vitamins,
                                                  minerals);
                                              amountController.text = "";
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 15),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                border: Border.all(
                                                    color: white, width: 1)),
                                            child: const Text("Submit"),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: black,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    50,
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black54,
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.add,
                                color: white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 20,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(widget.context).pop();
                            },
                            child: const Icon(
                              Icons.close,
                              color: black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.foodName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "1 ${widget.measure}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: gray,
                            ),
                          ),

                          // !! ESSENTIALS
                          const SizedBox(
                            height: 24,
                          ),
                          const Text(
                            "Essentials",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: essentials.entries
                                .map((MapEntry<String, dynamic> entry) {
                              return Column(
                                children: [
                                  Text(
                                    "${entry.key}: ${entry.value["amount"]} ${entry.value["unit"]}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            }).toList(),
                          ),

                          // !! VITAMINS
                          const SizedBox(
                            height: 50,
                          ),
                          const Text(
                            "Vitamins",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: vitamins.entries
                                .map((MapEntry<String, dynamic> entry) {
                              return Column(
                                children: [
                                  Text(
                                    "${entry.key}: ${entry.value["amount"]} ${entry.value["unit"]}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                          // !! MINERALS
                          const SizedBox(
                            height: 50,
                          ),
                          const Text(
                            "Minerals",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: minerals.entries
                                .map((MapEntry<String, dynamic> entry) {
                              return Column(
                                children: [
                                  Text(
                                    "${entry.key}: ${entry.value["amount"]} ${entry.value["unit"]}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
