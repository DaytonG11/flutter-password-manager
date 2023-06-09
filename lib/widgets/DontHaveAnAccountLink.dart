import 'package:flutter/material.dart';
import 'package:password_manager/screens/register_screen.dart';

import 'package:password_manager/widgets/AccentColorTextButton.dart';

class DontHaveAnAccountLink extends StatelessWidget {
  const DontHaveAnAccountLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?"),

        //Log in button
        AccentColorTextButton(
            child: Text("Register"), route: RegisterScreen.route)
      ],
    );
  }
}
