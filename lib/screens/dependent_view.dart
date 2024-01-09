import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:nutritrack/widgets/stream_builders/all_nutrient_percent_streambuilder.dart';
import 'package:nutritrack/widgets/stream_builders/nutrient_overall_progress_streambuilder.dart';
import 'package:nutritrack/widgets/stream_builders/nutrients_streambuilder.dart';

class DependentView extends StatefulWidget {
  final String uid;
  final String name;
  const DependentView({super.key, required this.uid, required this.name});

  @override
  State<DependentView> createState() => _DependentViewState();
}

class _DependentViewState extends State<DependentView> {
  late TextEditingController dateController;

  @override
  void initState() {
    dateController = TextEditingController();
    dateController.text = DateFormat("EEEE, dd-MM-yyyy").format(
      DateTime.now(),
    );

    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
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
          title: Text(
            widget.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateFormat("EEEE, dd-MM-yyyy")
                          .parse(dateController.text),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        dateController.text =
                            DateFormat("EEEE, dd-MM-yyyy").format(pickedDate);
                      });
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.date_range,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: TextField(
                          controller: dateController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          readOnly: true,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Completeness",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  children: [
                    Expanded(
                        child: AllNutrientPercentStreamBuilder(
                            date: dateController.text, uid: widget.uid)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NutrientOverallProgressStreamBuilder(
                            date: dateController.text,
                            label: "Essentials",
                            uid: widget.uid,
                          ),
                          NutrientOverallProgressStreamBuilder(
                              date: dateController.text,
                              label: "Vitamins",
                              uid: widget.uid),
                          NutrientOverallProgressStreamBuilder(
                              date: dateController.text,
                              label: "Minerals",
                              uid: widget.uid),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                NutrientStreamBuilder(
                    date: dateController.text,
                    type: "Essentials",
                    uid: widget.uid),
                const SizedBox(
                  height: 54,
                ),
                NutrientStreamBuilder(
                    date: dateController.text,
                    type: "Vitamins",
                    uid: widget.uid),
                const SizedBox(
                  height: 54,
                ),
                NutrientStreamBuilder(
                    date: dateController.text,
                    type: "Minerals",
                    uid: widget.uid),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
