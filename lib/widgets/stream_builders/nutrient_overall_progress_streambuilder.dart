import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class NutrientOverallProgressStreamBuilder extends StatefulWidget {
  final String date;
  final String label;
  final String? uid;
  const NutrientOverallProgressStreamBuilder(
      {super.key, required this.date, required this.label, this.uid});

  @override
  State<NutrientOverallProgressStreamBuilder> createState() =>
      _NutrientOverallProgressStreamBuilderState();
}

class _NutrientOverallProgressStreamBuilderState
    extends State<NutrientOverallProgressStreamBuilder> {
  Stream<QuerySnapshot> getSnapshot() {
    FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
    FirebaseAuth firebaseAuthRef = FirebaseAuth.instance;
    CollectionReference ref = firestoreRef
        .collection("users")
        .doc(widget.uid ?? firebaseAuthRef.currentUser!.uid)
        .collection("nutrients")
        .doc(widget.date)
        .collection(widget.label);

    return ref.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getSnapshot(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          double overallPercentage = 0;
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            double percentage = 0;
            int items = 0;
            for (DocumentSnapshot document in snapshot.data!.docs) {
              items++;
              double percentageB4Add =
                  double.parse(document['curVal'].toString()) /
                      double.parse(document['targetVal'].toString()) *
                      100;
              percentage += percentageB4Add > 100 ? 100 : percentageB4Add;
            }
            overallPercentage = percentage / items;
            overallPercentage =
                double.parse(overallPercentage.toStringAsFixed(2));
          } else {
            overallPercentage = 0;
          }

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: 10.0,
                    bottom: 5,
                    top: widget.label == "Essentials" ? 0 : 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.label,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "$overallPercentage%",
                    ),
                  ],
                ),
              ),
              LinearPercentIndicator(
                percent: overallPercentage / 100 > 1
                    ? overallPercentage / 100 - 1
                    : overallPercentage / 100,
                lineHeight: 5,
                animation: true,
                barRadius: const Radius.circular(10),
                padding: const EdgeInsets.only(right: 10),
              )
            ],
          );
        } else {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: 10.0,
                    bottom: 5,
                    top: widget.label == "Essentials" ? 0 : 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.label,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "0%",
                    ),
                  ],
                ),
              ),
              LinearPercentIndicator(
                percent: 0,
                lineHeight: 5,
                animation: true,
                barRadius: const Radius.circular(10),
                padding: const EdgeInsets.only(right: 10),
              )
            ],
          );
        }
      },
    );
  }
}
