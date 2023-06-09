import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';

class AccentColorBoxButton extends StatelessWidget {
  final Widget child;
  final Function onPressed;

  AccentColorBoxButton({
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: const ButtonStyle(
          foregroundColor: MaterialStatePropertyAll(primaryColor),
          backgroundColor: MaterialStatePropertyAll(accentColor),
        ),
        onPressed: () => onPressed(),
        child: child);
  }
}
