import "package:flutter/material.dart";
import "package:nutritrack/screens/scan_screen.dart";
import "package:nutritrack/screens/suggestion_screen.dart";
import "package:nutritrack/screens/target_screen.dart";
import "package:nutritrack/screens/track_screen.dart";
import "package:nutritrack/utils/colors.dart";
import "package:nutritrack/widgets/add_nutrient_bottom_sheet.dart";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget screen = const TrackScreen();
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    Color computeColor(int tabIndex) {
      return (selectedTab == tabIndex ? yellowishGreen : white);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NutriTrack',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: primaryColor),
      home: SafeArea(
        child: Scaffold(
          floatingActionButton: Container(
              width: 65,
              height: 65,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: yellowishGreen,
                    spreadRadius: 2,
                    blurRadius: 50,
                  ),
                ],
              ),
              margin: const EdgeInsets.only(top: 40),
              child: Builder(
                builder: (context) => FloatingActionButton(
                  onPressed: () => showModalBottomSheet(
                      isScrollControlled: true,
                      useSafeArea: true,
                      context: context,
                      builder: (context) {
                        return AddNutrientBottomSheet(context: context);
                      }),
                  backgroundColor: yellowishGreen,
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.add,
                    size: 28,
                    color: black,
                  ),
                ),
              )),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => {
                      setState(() {
                        screen = const TrackScreen();
                        selectedTab = 0;
                      })
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fact_check_outlined,
                          size: 28,
                          color: computeColor(0),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Overview",
                          style: TextStyle(
                            fontSize: 10,
                            color: computeColor(0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => {
                      setState(() {
                        screen = const TargetScreen();
                        selectedTab = 1;
                      })
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.flag_outlined,
                          size: 28,
                          color: computeColor(1),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Goal",
                          style: TextStyle(
                            fontSize: 10,
                            color: computeColor(1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Expanded(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => {
                      setState(() {
                        screen = const ScanScreen();
                        selectedTab = 2;
                      })
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 28,
                          color: computeColor(2),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Scan",
                          style: TextStyle(
                            fontSize: 10,
                            color: computeColor(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => {
                      setState(() {
                        screen = const SuggestionScreen();
                        selectedTab = 3;
                      })
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_outlined,
                          size: 28,
                          color: computeColor(3),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Suggestion",
                          style: TextStyle(
                            fontSize: 10,
                            color: computeColor(3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: screen,
            ),
          ),
        ),
      ),
    );
  }
}
