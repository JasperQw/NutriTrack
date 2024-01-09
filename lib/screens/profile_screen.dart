import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutritrack/resources/auth_functions.dart';
import 'package:nutritrack/resources/profile_dialog_functions.dart';
import 'package:nutritrack/screens/notification_screen.dart';
import 'package:nutritrack/screens/sign_in_screen.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:nutritrack/widgets/dependent_guardian_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String name = "";
  late String plan = "";
  late String imagePath =
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";
  late TextEditingController dependentController;
  late TextEditingController guardianController;
  late List<Map<String, String>> dependentList = [];
  late List<Map<String, String>> guardianList = [];
  late int notiAmount = 0;
  late StreamSubscription notificationListener;

  getNotification() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    Stream<QuerySnapshot> snapshots = firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("notification")
        .where("status", isEqualTo: "unread")
        .snapshots();

    notificationListener = snapshots.listen((event) {
      if (event.size != 0 && event.docs.isNotEmpty) {
        setState(() {
          notiAmount = event.docs.length;
        });
      } else {
        setState(() {
          notiAmount = 0;
        });
      }
    });
  }

  @override
  void initState() {
    getNotification();
    dependentController = TextEditingController();
    guardianController = TextEditingController();
    loadUserData();
    loadDependet();
    loadGuardian();
    super.initState();
  }

  loadDependet() async {
    List<Map<String, String>> dependents = await AuthFunctions().getDependent();
    setState(() {
      dependentList = dependents;
    });
  }

  loadGuardian() async {
    List<Map<String, String>> guardians = await AuthFunctions().getGuardian();
    setState(() {
      guardianList = guardians;
    });
  }

  loadUserData() async {
    Map<String, String> userData = await AuthFunctions().getUserData();
    setState(() {
      name = userData["name"]!;
      plan = userData["type"]!;
      imagePath = userData['imagePath']!;
    });
  }

  @override
  void dispose() {
    dependentController.dispose();
    guardianController.dispose();
    notificationListener.cancel();
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
            actions: [
              Container(
                padding: const EdgeInsets.only(right: 20),
                child: Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return const NotificationScreen();
                          },
                        ));
                      },
                      icon: const Icon(
                        Icons.notifications_none,
                        size: 30,
                      ),
                    ),
                    notiAmount == 0
                        ? Container()
                        : Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              alignment: Alignment.center,
                              height: 20,
                              width: 20,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                              child: Text(
                                "$notiAmount",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ],
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
              "Profile",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
            child: Column(
              children: [
                Expanded(
                  child: SafeArea(
                    child: SingleChildScrollView(
                      clipBehavior: Clip.none,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 50, bottom: 30),
                            alignment: Alignment.center,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: NetworkImage(imagePath),
                                ),
                                Positioned(
                                  bottom: -10,
                                  right: -10,
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.add_a_photo_outlined,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Plan: $plan",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 100,
                                margin:
                                    const EdgeInsets.only(top: 20, right: 20),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: white),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(
                                      10,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "Edit",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  FirebaseAuth authRef = FirebaseAuth.instance;
                                  await authRef.signOut();
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignInScreen()),
                                    (route) => false,
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 100,
                                  margin: const EdgeInsets.only(top: 20),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: white),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                        10,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    "Logout",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Guardian(s)",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    ProfileDialog().profileDialog(context,
                                        "Guardian", guardianController);
                                  },
                                  child: const Icon(Icons.add))
                            ],
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Column(
                            children: guardianList.isEmpty
                                ? [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: const Text(
                                        "No Guardian",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ]
                                : guardianList.map((e) {
                                    return DependentOrGuardianWidget(
                                      name: e["name"]!,
                                      plan: "",
                                      imagePath: e["imagePath"]!,
                                      type: "Guardian",
                                      userUID: "",
                                    );
                                  }).toList(),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Dependent(s)",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  ProfileDialog().profileDialog(context,
                                      "Dependent", dependentController);
                                },
                                child: const Icon(
                                  Icons.add,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Column(
                            children: dependentList.isEmpty
                                ? [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: const Text(
                                        "No Dependent",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ]
                                : dependentList.map((e) {
                                    return DependentOrGuardianWidget(
                                      name: e["name"]!,
                                      plan: e["plan"]!,
                                      imagePath: e["imagePath"]!,
                                      type: "Dependent",
                                      userUID: e["key"]!,
                                    );
                                  }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
