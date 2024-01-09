import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AllNutrientPercentStreamBuilder extends StatefulWidget {
  final String date;
  final String? uid;
  const AllNutrientPercentStreamBuilder(
      {super.key, required this.date, this.uid});

  @override
  State<AllNutrientPercentStreamBuilder> createState() =>
      _AllNutrientPercentStreamBuilderState();
}

class _AllNutrientPercentStreamBuilderState
    extends State<AllNutrientPercentStreamBuilder> {
  late StreamSubscription<QuerySnapshot> mineralsSubscription;
  late StreamSubscription<QuerySnapshot> vitaminsSubscription;
  late StreamSubscription<QuerySnapshot> essentialsSubscription;
  late double essentialPercentage = 0;
  late double vitaminPercentage = 0;
  late double mineralPercentage = 0;

  @override
  void initState() {
    super.initState();
    setupListeners();
  }

  @override
  void didUpdateWidget(covariant AllNutrientPercentStreamBuilder oldWidget) {
    if (widget.date != oldWidget.date) {
      disposeListeners();
      setupListeners();
    }
    super.didUpdateWidget(oldWidget);
  }

  void setupListeners() {
    FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
    FirebaseAuth firebaseAuthRef = FirebaseAuth.instance;
    DocumentReference refEssential = firestoreRef
        .collection("users")
        .doc(widget.uid ?? firebaseAuthRef.currentUser!.uid)
        .collection("nutrients")
        .doc(widget.date);

    DocumentReference refVitamins = firestoreRef
        .collection("users")
        .doc(widget.uid ?? firebaseAuthRef.currentUser!.uid)
        .collection("nutrients")
        .doc(widget.date);
    DocumentReference refMinerals = firestoreRef
        .collection("users")
        .doc(widget.uid ?? firebaseAuthRef.currentUser!.uid)
        .collection("nutrients")
        .doc(widget.date);

    essentialsSubscription =
        refEssential.collection("Essentials").snapshots().listen((event) {
      double overallPercentage = 0;
      int items = 0;
      if (event.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in event.docs) {
          items++;
          double curVal = double.parse(doc.get("curVal").toString());
          double targetVal = double.parse(doc.get("targetVal").toString());
          double percentage = curVal / targetVal * 100;
          overallPercentage += percentage > 100 ? 100 : percentage;
        }
        setState(() {
          essentialPercentage =
              double.parse((overallPercentage / items).toStringAsFixed(2));
        });
      } else {
        setState(() {
          essentialPercentage = 0;
        });
      }
    });

    vitaminsSubscription =
        refVitamins.collection("Vitamins").snapshots().listen((event) {
      double overallPercentage = 0;
      int items = 0;
      if (event.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in event.docs) {
          items++;
          double curVal = double.parse(doc.get("curVal").toString());
          double targetVal = double.parse(doc.get("targetVal").toString());
          double percentage = curVal / targetVal * 100;
          overallPercentage += percentage > 100 ? 100 : percentage;
        }
        setState(() {
          vitaminPercentage =
              double.parse((overallPercentage / items).toStringAsFixed(2));
        });
      } else {
        setState(() {
          vitaminPercentage = 0;
        });
      }
    });

    mineralsSubscription =
        refMinerals.collection("Minerals").snapshots().listen((event) {
      double overallPercentage = 0;
      int items = 0;
      if (event.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in event.docs) {
          items++;
          double curVal = double.parse(doc.get("curVal").toString());
          double targetVal = double.parse(doc.get("targetVal").toString());
          double percentage = curVal / targetVal * 100;
          overallPercentage += percentage > 100 ? 100 : percentage;
        }
        setState(() {
          mineralPercentage =
              double.parse((overallPercentage / items).toStringAsFixed(2));
        });
      } else {
        setState(() {
          mineralPercentage = 0;
        });
      }
    });
  }

  void disposeListeners() {
    essentialsSubscription.cancel();
    vitaminsSubscription.cancel();
    mineralsSubscription.cancel();
  }

  @override
  void dispose() {
    disposeListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double total = double.parse(
        ((essentialPercentage + vitaminPercentage + mineralPercentage) / 3)
            .toStringAsFixed(2));
    return CircularPercentIndicator(
      radius: 60,
      percent: total > 100 ? 1 : total / 100,
      center: Text(
        "${total > 100 ? 100 : total}%",
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      progressColor: yellowishGreen,
      backgroundColor: primaryColor,
      lineWidth: 8,
      reverse: true,
      animation: true,
    );
  }
}
