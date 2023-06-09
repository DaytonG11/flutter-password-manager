import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreenWelcomeText extends StatelessWidget {
  HomeScreenWelcomeText({super.key});

  var name = FirebaseAuth.instance.currentUser?.displayName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome Back",
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          name!,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
