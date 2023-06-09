import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:password_manager/screens/register_screen.dart';
import 'package:password_manager/widgets/AccentColorTextButton.dart';
import 'package:password_manager/widgets/AccentColorBoxButton.dart';

class IntroScreen extends StatelessWidget {
  static String route = 'introScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
          child: SingleChildScrollView(
            //sets the contents of the scroll view to 90 percent of the screen
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Tired of constantly forgetting passwords?",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 25.0,
                    ),
                  ),

                  //logo graphic

                  Hero(
                    tag: "logo",
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 200,
                      width: 200,
                    ),
                  ),
                  //Column containing both buttons
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //Get started button
                      AccentColorBoxButton(
                        child: Text("Get Started"),
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(RegisterScreen.route);
                        },
                      ),

                      //Row containing elements related to navigating to log in page
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),

                          //Log in button
                          AccentColorTextButton(
                              child: Text("Log in"), route: LoginScreen.route)
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
