import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutritrack/dto_classes/nutrient_classes.dart';
import 'package:nutritrack/widgets/essential_nutrient_card.dart';
import 'package:nutritrack/widgets/mineral_tracking_card.dart';
import 'package:nutritrack/widgets/vitamin_tracking_card.dart';

class NutrientStreamBuilder extends StatefulWidget {
  final String date;
  final String type;
  final String? uid;
  const NutrientStreamBuilder(
      {super.key, required this.date, required this.type, this.uid});

  @override
  State<NutrientStreamBuilder> createState() => _NutrientStreamBuilderState();
}

class _NutrientStreamBuilderState extends State<NutrientStreamBuilder> {
  Stream<QuerySnapshot> getSnapshot() {
    FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
    FirebaseAuth firebaseAuthRef = FirebaseAuth.instance;
    CollectionReference ref = firestoreRef
        .collection("users")
        .doc(widget.uid ?? firebaseAuthRef.currentUser!.uid)
        .collection("nutrients")
        .doc(widget.date)
        .collection(widget.type);

    return ref.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getSnapshot(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          Map<String, Nutrient> nutrientMap;

          if (widget.type == "Essentials") {
            nutrientMap = {
              "Protein": Nutrient("Protein", 0, 3000, "mg"),
              "Carbo": Nutrient("Carbo", 0, 3000, "mg"),
              "Fat": Nutrient("Fat", 0, 3000, "mg"),
              "Calories": Nutrient("Calories", 0, 3000, "kcal"),
              "Water": Nutrient("Water", 0, 3000, "ml")
            };
          } else if (widget.type == "Vitamins") {
            nutrientMap = {
              "Vitamin A": Nutrient("Vitamin A", 0, 3000, "mg"),
              "Vitamin B": Nutrient("Vitamin B", 0, 3000, "mg"),
              "Vitamin C": Nutrient("Vitamin C", 0, 3000, "mg"),
              "Vitamin D": Nutrient("Vitamin D", 0, 3000, "mg"),
              "Vitamin E": Nutrient("Vitamin E", 0, 3000, "mg"),
              "Vitamin F": Nutrient("Vitamin F", 0, 3000, "mg"),
            };
          } else {
            nutrientMap = {
              "Sodium": Nutrient("Sodium", 0, 3000, "mg"),
              "Magnesium": Nutrient("Magnesium", 0, 3000, "mg"),
              "Calcium": Nutrient("Calcium", 0, 3000, "mg"),
              "Potassium": Nutrient("Potassium", 0, 3000, "mg"),
              "Phosphorus": Nutrient("Phosphorus", 0, 3000, "mg"),
              "Sulfur": Nutrient("Sulfur", 0, 3000, "mg"),
            };
          }

          if (snapshot.hasData) {
            for (DocumentSnapshot document in snapshot.data!.docs) {
              Map<String, dynamic> essential =
                  document.data() as Map<String, dynamic>;
              nutrientMap[essential['label']] = Nutrient(
                  essential['label'],
                  double.parse(essential['curVal'].toString()),
                  double.parse(essential['targetVal'].toString()),
                  essential['unit']);
            }
          }

          return widget.type == "Vitamins"
              ? VitaminTrackingCard(nutrientMap: nutrientMap)
              : (widget.type == "Essentials"
                  ? EssentialNutrientCard(nutrientMap: nutrientMap)
                  : MineralTrackingCard(
                      nutrientMap: nutrientMap,
                    ));
        } else {
          return Container(
            alignment: Alignment.center,
            height: 300,
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
