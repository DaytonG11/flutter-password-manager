import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';

class AccentColorTextButton extends StatelessWidget {
  final String route;
  final Widget child;
  AccentColorTextButton({required this.child, required this.route});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: const ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(accentColor),
            overlayColor: MaterialStatePropertyAll(Color(0x4DAE43FF))),
        onPressed: () {
          Navigator.of(context).pushReplacementNamed(route);
        },
        child: child);
  }
}
