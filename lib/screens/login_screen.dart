import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/screens/Home_Screen.dart';
import 'package:password_manager/widgets/AccentColorBoxButton.dart';
import 'package:password_manager/widgets/CustomTextField.dart';
import 'package:password_manager/widgets/DontHaveAnAccountLink.dart';
import 'package:password_manager/widgets/OrContinueWithDivider.dart';
import 'package:password_manager/widgets/ThirdPartyAuthButtons.dart';

class LoginScreen extends StatefulWidget {
  static String route = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode emailFocus = FocusNode();

  TextEditingController emailController = TextEditingController();

  FocusNode passwordFocus = FocusNode();

  TextEditingController passwordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  var emailError = null;

  var passwordError = null;

  String email = '';

  String password = '';

  void handleLogin() async {
    setState(() {
      emailError = null;
      passwordError = null;
    });

    if (emailController.text == "") {
      setState(() {
        emailError = "This field is required";
      });
    }
    if (passwordController.text == '') {
      setState(() {
        passwordError = "This field is required";
      });
    }

    try {
      await _auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.of(context).pushReplacementNamed(HomeScreen.route);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          emailError = 'User not found';
        });
      }
      if (e.code == "wrong-password") {
        setState(() {
          emailError = 'Invalid credentials';
          passwordError = 'Invalid Credentials';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    //First column welcome message
                    children: [
                      const Text(
                        'Welcome Back!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: secondaryColor),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Please enter your login credentials",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w100,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  Hero(
                    tag: "logo",
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 200,
                      width: 200,
                    ),
                  ),

                  //second Column form fields

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: CustomTextField(
                            errorString: emailError,
                            fieldText: email,
                            focusNode: emailFocus,
                            controller: emailController,
                            labelText: "Email",
                            icon: Icons.mail,
                            hideText: false),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: CustomTextField(
                            errorString: passwordError,
                            fieldText: password,
                            focusNode: passwordFocus,
                            controller: passwordController,
                            labelText: "Password",
                            icon: Icons.key,
                            hideText: true),
                      ),
                    ],
                  ),
                  AccentColorBoxButton(
                    child: const Text("LOGIN"),
                    onPressed: () {
                      //TODO add authentication
                      handleLogin();
                    },
                  ),
                  // Column(
                  //   children: [
                  //     OrContinueWithDivider(),
                  //     SizedBox(
                  //       height: 15,
                  //     ),
                  //     ThirdPartyAuthButtons(),
                  //   ],
                  // ),

                  const DontHaveAnAccountLink()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
