// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/screens/Home_Screen.dart';
import 'package:password_manager/widgets/AccentColorBoxButton.dart';
import '../widgets/AlreadyHaveAnAccountLink.dart';
import '../widgets/CustomTextField.dart';
import '../widgets/OrContinueWithDivider.dart';
import '../widgets/ThirdPartyAuthButtons.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  static String route = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  FocusNode nameFocus = FocusNode();

  TextEditingController nameController = TextEditingController();

  FocusNode emailFocus = FocusNode();

  TextEditingController emailController = TextEditingController();

  FocusNode passwordFocus = FocusNode();

  TextEditingController passwordController = TextEditingController();

  FocusNode confirmPasswordFocus = FocusNode();

  TextEditingController confirmPasswordController = TextEditingController();

  var emailError = null;

  var nameError = null;

  var passwordError = null;

  var confirmError = null;

  bool noErrors = true;

  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //TODO check to make sure passwords match and handle errors
  void handleRegister() async {
    setState(() {
      noErrors = true;
      emailError = null;
      nameError = null;
      passwordError = null;
      confirmError = null;
    });
    if (emailController.text == "") {
      setState(() {
        emailError = "This field is required";
        noErrors = false;
      });
    }
    if (nameController.text == '') {
      setState(() {
        nameError = "This field is required";
        noErrors = false;
      });
    }
    if (passwordController.text == '') {
      setState(() {
        passwordError = "This field is required";
        noErrors = false;
      });
    }
    if (confirmPasswordController.text == '') {
      setState(() {
        confirmError = "This field is required";
        noErrors = false;
      });
    }

    if (passwordController.text == confirmPasswordController.text) {
      if (noErrors) {
        try {
          await _auth.createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

          User? currentUser = await _auth.currentUser;

          currentUser?.updateDisplayName(nameController.text);

          await _firestore
              .collection("UserData")
              .doc(currentUser?.uid)
              .set({'passwords': []});

          await _auth.signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

          Navigator.of(context).pushReplacementNamed(HomeScreen.route);
        } on FirebaseAuthException catch (e) {
          print('code${e.message}');
          if (e.code == "email-already-in-use") {
            setState(() {
              emailError = "Email already in use";
            });
          }
          if (e.code == "weak-password") {
            setState(() {
              print("here");
              passwordError = "Password must be at least 6 characters";
            });
          }
        }
      }
    } else {
      setState(() {
        confirmError = "Passwords dont match";
        passwordError = "Passwords dont match";
      });
    }
  }

  String name = '';

  String email = '';

  String password = '';

  String confirm = '';

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
                    children: [
                      Text(
                        'Registration',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: secondaryColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Please register down below",
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
                      height: 100,
                      width: 100,
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: CustomTextField(
                          errorString: nameError,
                          fieldText: name,
                          focusNode: nameFocus,
                          controller: nameController,
                          labelText: "Full name",
                          icon: Icons.person,
                          hideText: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: CustomTextField(
                          errorString: emailError,
                          fieldText: email,
                          focusNode: emailFocus,
                          controller: emailController,
                          labelText: "Email",
                          icon: Icons.mail,
                          hideText: false,
                        ),
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
                          hideText: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: CustomTextField(
                          errorString: confirmError,
                          fieldText: confirm,
                          focusNode: confirmPasswordFocus,
                          controller: confirmPasswordController,
                          labelText: "Confirm password",
                          icon: Icons.key,
                          hideText: true,
                        ),
                      ),
                    ],
                  ),
                  AccentColorBoxButton(
                      child: Text('REGISTER'),
                      onPressed: () async {
                        //TODO: Add registration

                        handleRegister();

                        // Navigator.of(context)
                        //     .pushReplacementNamed(HomeScreen.route);
                      }),
                  Column(
                    children: [],
                  ),
                  // OrContinueWithDivider(),
                  //ThirdPartyAuthButtons(),
                  AlreadyHaveAnAccountLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
