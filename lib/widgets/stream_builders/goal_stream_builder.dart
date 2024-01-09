import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:nutritrack/widgets/placeholder/goal_placeholder.dart';
import 'package:nutritrack/widgets/target_cart/completeness_target_card.dart';
import 'package:nutritrack/widgets/target_cart/nutrient_target_card.dart';
import 'package:nutritrack/widgets/target_cart/weight_loss_card.dart';

class GoalStreamBuilder extends StatefulWidget {
  final String status;
  const GoalStreamBuilder({super.key, required this.status});

  @override
  State<GoalStreamBuilder> createState() => _GoalStreamBuilderState();
}

class _GoalStreamBuilderState extends State<GoalStreamBuilder> {
  getSnapshot() {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Query targetRef = firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("targets")
        .orderBy('created_at', descending: true)
        .where("status", isEqualTo: widget.status);
    return targetRef.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      child: StreamBuilder<QuerySnapshot>(
          stream: getSnapshot(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                List<Map<String, dynamic>> targets = [];
                for (QueryDocumentSnapshot doc in snapshot.data!.docs) {
                  targets.add({
                    "from": doc.get("from"),
                    "to": doc.get("to"),
                    "target": doc.get("target"),
                    "id": doc.id,
                    "type": doc.get("type"),
                  });
                }

                List<Widget> widgetList = [];
                for (Map<String, dynamic> target in targets) {
                  if (target['type'] == "Weight Loss") {
                    widgetList.add(WeightLossCard(
                      from: target['from'],
                      to: target['to'],
                      target: target['target']['weightLoss'],
                      id: target['id'],
                    ));
                  } else if (target['type'] == "Completeness") {
                    String type =
                        (target["target"] as Map<String, dynamic>).keys.first;
                    widgetList.add(
                      CompletenessTargetCard(
                        from: target['from'],
                        to: target['to'],
                        type: type,
                        percentage: target["target"][type],
                        id: target['id'],
                      ),
                    );
                  } else {
                    int amount =
                        (target['target'] as Map<String, dynamic>).keys.length;
                    widgetList.add(
                      NutrientTargetCard(
                        from: target["from"],
                        to: target["to"],
                        amount: amount,
                        id: target['id'],
                      ),
                    );
                  }
                }

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(children: widgetList),
                      ),
                    ),
                  ],
                );
              } else {
                return const GoalPlaceholder();
              }
            } else {
              return Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    color: white,
                  ));
            }
          }),
    );
  }
}
