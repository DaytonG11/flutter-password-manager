import 'package:flutter/material.dart';

import 'package:password_manager/widgets/AccentColorTextButton.dart';
import 'package:password_manager/screens/login_screen.dart';

class AlreadyHaveAnAccountLink extends StatelessWidget {
  const AlreadyHaveAnAccountLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?"),

        //Log in button
        AccentColorTextButton(child: Text("Log in"), route: LoginScreen.route)
      ],
    );
  }
}
