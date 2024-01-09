import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:nutritrack/widgets/chart/line_chart.dart';
import 'package:nutritrack/widgets/start_end_date.dart';

class NutrientTargetDetailScreen extends StatefulWidget {
  final String id;
  const NutrientTargetDetailScreen({super.key, required this.id});

  @override
  State<NutrientTargetDetailScreen> createState() =>
      _NutrientTargetDetailScreenState();
}

class _NutrientTargetDetailScreenState
    extends State<NutrientTargetDetailScreen> {
  late List<Map<String, double>> points = [];
  late String from = "";
  late String to = "";
  late Map<String, dynamic> target = {};
  late String type = "";
  late bool loading = true;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  getData() async {
    DocumentSnapshot snapshot = await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("targets")
        .doc(widget.id)
        .get();

    setState(() {
      List<dynamic> point = snapshot.get("track");
      from = snapshot.get("from");
      to = snapshot.get("to");
      target = snapshot.get("target");
      type = snapshot.get("type");
      loading = false;

      if (point.isNotEmpty) {
        for (dynamic p in point) {
          points.add({"x": double.parse(p['x']), "y": double.parse(p['y'])});
        }
      } else {
        points = [
          {"x": 1, "y": 10},
          {"x": 2, "y": 13},
          {"x": 3, "y": 12},
          {"x": 4, "y": 15}
        ];
      }
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NutriTrack',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: primaryColor),
      home: Scaffold(
        appBar: AppBar(
          leading: Container(
            padding: const EdgeInsets.only(left: 20),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
              ),
            ),
          ),
          title: const Text(
            "Tracking",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 50),
            color: primaryColor,
            child: loading
                ? Column(
                    children: [
                      Expanded(
                          child: Container(
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator())),
                    ],
                  )
                : Column(
                    children: [
                      LineChartDrawing(points: points),
                      const SizedBox(
                        height: 32,
                      ),
                      StartEndDate(from: from, to: to),
                      const SizedBox(
                        height: 32,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Nutrient Target:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            ...target.keys.map(
                              (e) {
                                return Text(
                                  "$e: ${target[e]} %",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                );
                              },
                            ).toList(),
                          ],
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
