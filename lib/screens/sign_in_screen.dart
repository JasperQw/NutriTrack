import 'package:flutter/material.dart';
import 'package:nutritrack/main.dart';
import 'package:nutritrack/resources/auth_functions.dart';
import 'package:nutritrack/screens/main_screen.dart';
import 'package:nutritrack/screens/sign_up_screen.dart';
import 'package:nutritrack/utils/colors.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isShow = true;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const MyApp()),
                  (route) => false,
                );
              }
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Sign in to NutriTrack",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 32,
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
                  hintText: "user@email.com",
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
                obscureText: isShow,
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
                        isShow = !isShow;
                      });
                    },
                    icon: isShow
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  "Forget Password?",
                  style: TextStyle(
                    color: yellowishGreen,
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              InkWell(
                onTap: () async {
                  String res = await AuthFunctions()
                      .login(emailController.text, passwordController.text);

                  if (res == "success") {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const MainScreen();
                    }));
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
                    "Sign In",
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
                    "Don't have an account?",
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
                        return const SignUpScreen();
                      }));
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        color: yellowishGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
