import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutritrack/resources/auth_functions.dart';
import 'package:nutritrack/screens/profile_screen.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:nutritrack/widgets/stream_builders/all_nutrient_percent_streambuilder.dart';
import 'package:nutritrack/widgets/stream_builders/nutrient_overall_progress_streambuilder.dart';
import 'package:nutritrack/widgets/stream_builders/nutrients_streambuilder.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  late TextEditingController dateController;
  late String imagePath =
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";

  @override
  void initState() {
    dateController = TextEditingController();
    dateController.text = DateFormat("EEEE, dd-MM-yyyy").format(
      DateTime.now(),
    );
    loadUserData();

    super.initState();
  }

  loadUserData() async {
    Map<String, String> userData = await AuthFunctions().getUserData();
    setState(() {
      imagePath = userData['imagePath']!;
    });
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi, Welcome!",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      "Wish you have a good day.",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: gray),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()),
                    );
                  },
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(imagePath),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate:
                      DateFormat("EEEE, dd-MM-yyyy").parse(dateController.text),
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
                        date: dateController.text)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NutrientOverallProgressStreamBuilder(
                          date: dateController.text, label: "Essentials"),
                      NutrientOverallProgressStreamBuilder(
                          date: dateController.text, label: "Vitamins"),
                      NutrientOverallProgressStreamBuilder(
                          date: dateController.text, label: "Minerals"),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            NutrientStreamBuilder(
                date: dateController.text, type: "Essentials"),
            const SizedBox(
              height: 54,
            ),
            NutrientStreamBuilder(date: dateController.text, type: "Vitamins"),
            const SizedBox(
              height: 54,
            ),
            NutrientStreamBuilder(date: dateController.text, type: "Minerals"),
          ],
        ),
      ),
    );
  }
}
