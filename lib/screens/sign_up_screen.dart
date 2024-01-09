import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutritrack/resources/auth_functions.dart';
import 'package:nutritrack/screens/sign_in_screen.dart';
import 'package:nutritrack/utils/colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController raceController;
  late TextEditingController religionController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmedPasswordController;
  bool isShowPassword = true;
  bool isShowConfirmedPassword = true;
  String selectedDropdownVal = "Normal";
  Uint8List? profileImg;

  @override
  void initState() {
    nameController = TextEditingController();
    ageController = TextEditingController();
    heightController = TextEditingController();
    weightController = TextEditingController();
    raceController = TextEditingController();
    religionController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmedPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    weightController.dispose();
    heightController.dispose();
    ageController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmedPasswordController.dispose();
    raceController.dispose();
    religionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: primaryColor,
      ),
      debugShowCheckedModeBanner: false,
      title: "NutriTrack",
      home: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.only(left: 20),
              child: const Icon(
                Icons.navigate_before_outlined,
                size: 40,
              ),
            ),
          ),
        ),
        body: SafeArea(
            child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Sign up to NutriTrack",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.transparent,
                              backgroundImage: (profileImg == null)
                                  ? const NetworkImage(
                                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                                    )
                                  : MemoryImage(profileImg!) as ImageProvider,
                            ),
                            Positioned(
                                bottom: -10,
                                right: 0,
                                child: IconButton(
                                  onPressed: () async {
                                    ImagePicker? imagePicker = ImagePicker();
                                    XFile? file = await imagePicker.pickImage(
                                        source: ImageSource.gallery);
                                    if (file != null) {
                                      Uint8List img = await file.readAsBytes();
                                      setState(() {
                                        profileImg = img;
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.add_a_photo_outlined,
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      const Text("Name"),
                      TextField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        cursorColor: gray,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        decoration: const InputDecoration(
                          fillColor: black,
                          border: InputBorder.none,
                          hintText: "John Doe",
                          focusColor: gray,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Type"),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedDropdownVal,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDropdownVal = value!;
                                      });
                                    },
                                    items:
                                        ["Normal", "Diabetes", "Hypertension"]
                                            .map(
                                              (e) => DropdownMenuItem<String>(
                                                value: e,
                                                child: Text(e),
                                              ),
                                            )
                                            .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Age"),
                              TextField(
                                controller: ageController,
                                keyboardType: TextInputType.number,
                                cursorColor: gray,
                                onTapOutside: (event) {
                                  FocusScope.of(context).unfocus();
                                },
                                decoration: const InputDecoration(
                                  fillColor: black,
                                  border: InputBorder.none,
                                  hintText: "Your Age",
                                  focusColor: gray,
                                ),
                              ),
                            ],
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Height (cm)"),
                                TextField(
                                  controller: heightController,
                                  keyboardType: TextInputType.number,
                                  cursorColor: gray,
                                  onTapOutside: (event) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  decoration: const InputDecoration(
                                    fillColor: black,
                                    border: InputBorder.none,
                                    hintText: "Your Height (cm)",
                                    focusColor: gray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Weight (kg)"),
                                TextField(
                                  controller: weightController,
                                  keyboardType: TextInputType.number,
                                  cursorColor: gray,
                                  onTapOutside: (event) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  decoration: const InputDecoration(
                                    fillColor: black,
                                    border: InputBorder.none,
                                    hintText: "Your Weight (kg)",
                                    focusColor: gray,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Race"),
                                TextField(
                                  controller: raceController,
                                  keyboardType: TextInputType.text,
                                  cursorColor: gray,
                                  onTapOutside: (event) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  decoration: const InputDecoration(
                                    fillColor: black,
                                    border: InputBorder.none,
                                    hintText: "Your Race",
                                    focusColor: gray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Religion"),
                                TextField(
                                  controller: religionController,
                                  keyboardType: TextInputType.number,
                                  cursorColor: gray,
                                  onTapOutside: (event) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  decoration: const InputDecoration(
                                    fillColor: black,
                                    border: InputBorder.none,
                                    hintText: "Your Religion",
                                    focusColor: gray,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      const Text("Email"),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: gray,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        decoration: const InputDecoration(
                          fillColor: black,
                          border: InputBorder.none,
                          hintText: "example@email.com",
                          focusColor: gray,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      const Text("Password"),
                      TextField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        cursorColor: gray,
                        obscureText: isShowPassword,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        decoration: InputDecoration(
                          fillColor: black,
                          border: InputBorder.none,
                          hintText: "Your Password",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isShowPassword = !isShowPassword;
                              });
                            },
                            icon: isShowPassword
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      const Text("Confirmed Password"),
                      TextField(
                        controller: confirmedPasswordController,
                        keyboardType: TextInputType.text,
                        cursorColor: gray,
                        obscureText: isShowConfirmedPassword,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        decoration: InputDecoration(
                          fillColor: black,
                          border: InputBorder.none,
                          hintText: "Your Password",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isShowConfirmedPassword =
                                    !isShowConfirmedPassword;
                              });
                            },
                            icon: isShowConfirmedPassword
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      InkWell(
                        onTap: () async {
                          String res = await AuthFunctions().signUp(
                              nameController.text,
                              emailController.text,
                              passwordController.text,
                              confirmedPasswordController.text,
                              selectedDropdownVal,
                              int.parse(ageController.text),
                              double.parse(heightController.text),
                              double.parse(weightController.text),
                              profileImg,
                              raceController.text,
                              religionController.text);

                          if (res == "success") {
                            if (context.mounted) {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const SignInScreen();
                              }));
                            }
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          decoration: const BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                10,
                              ),
                            ),
                          ),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(
                              color: white,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const SignInScreen();
                              }));
                            },
                            child: const Text(
                              "Sign in",
                              style: TextStyle(
                                color: yellowishGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
