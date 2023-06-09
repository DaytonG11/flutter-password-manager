import 'package:flutter/material.dart';

import 'package:password_manager/constants.dart';

class OrContinueWithDivider extends StatelessWidget {
  const OrContinueWithDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            height: 1,
            color: secondaryColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("Or continue with"),
        ),
        Expanded(
          child: Divider(
            color: secondaryColor,
            height: 1,
          ),
        ),
      ],
    );
  }
}
