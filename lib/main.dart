import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nutritrack/screens/main_screen.dart';
import 'package:nutritrack/screens/sign_in_screen.dart';
import 'package:nutritrack/screens/sign_up_screen.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:nutritrack/utils/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: FIREBASE_API_KEY,
      appId: APP_ID,
      messagingSenderId: MESSAGING_SENDER_ID,
      projectId: PROJECT_ID,
      storageBucket: STORAGE_BUCKET,
    ));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isLoggedin;
  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        isLoggedin = true;
      });
    } else {
      setState(() {
        isLoggedin = false;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedin
        ? const MainScreen()
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'NutriTrack',
            theme: ThemeData.dark()
                .copyWith(scaffoldBackgroundColor: primaryColor),
            home: SafeArea(
              child: Scaffold(
                body: SafeArea(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 64, horizontal: 32),
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "NutriTrack",
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Simplify nutrition tracking for a healthier you.",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 64,
                                  ),
                                  SvgPicture.asset(
                                    "assets/FoodTracking.svg",
                                    height: 240,
                                    width: 240,
                                  ),
                                  const SizedBox(
                                    height: 64,
                                  ),
                                  Builder(builder: (context) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                            return const SignInScreen();
                                          }),
                                        );
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15,
                                        ),
                                        decoration: const BoxDecoration(
                                          color: blue,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Sign In",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Builder(builder: (context) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                            return const SignUpScreen();
                                          }),
                                        );
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15,
                                        ),
                                        decoration: const BoxDecoration(
                                          color: gray,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Sign Up",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          );
  }
}
