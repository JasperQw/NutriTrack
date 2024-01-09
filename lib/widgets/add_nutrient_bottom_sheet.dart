import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:nutritrack/widgets/nutrient_card.dart';

class AddNutrientBottomSheet extends StatefulWidget {
  final BuildContext context;

  const AddNutrientBottomSheet({super.key, required this.context});

  @override
  State<AddNutrientBottomSheet> createState() => _AddNutrientBottomSheetState();
}

class _AddNutrientBottomSheetState extends State<AddNutrientBottomSheet> {
  late List<Map<String, String>> items = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    await getData();
  }

  getData() async {
    FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
    CollectionReference foodRef = firestoreRef.collection("food");

    QuerySnapshot foods = await foodRef.limit(10).get();

    for (QueryDocumentSnapshot food in foods.docs) {
      setState(() {
        items.add({
          "foodName": food.id,
          "imagePath": food.get("imagePath"),
          "measure": food.get("measure")
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
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
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                cursorColor: white,
                                onTapOutside: (event) {
                                  FocusScope.of(context).unfocus();
                                },
                                decoration: const InputDecoration(
                                  hintText: "Seach your food...",
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        20,
                                      ),
                                    ),
                                    borderSide: BorderSide(color: white),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        20,
                                      ),
                                    ),
                                    borderSide: BorderSide(color: gray),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            IconButton(
                              onPressed: () {},
                              padding: const EdgeInsets.all(20),
                              icon: const Icon(
                                Icons.search,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Column(
                          children: items.map((e) {
                            return NutrientCard(
                              foodName: e["foodName"]!,
                              imagePath: e["imagePath"]!,
                              measure: e["measure"]!,
                            );
                          }).toList(),
                        )
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
