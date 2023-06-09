import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';

class UserHomePassDivider extends StatelessWidget {
  const UserHomePassDivider({
    required this.text,
    super.key,
    required this.onPress,
  });

  final String text;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text),
        TextButton(
            style: TextButtonStyle,
            onPressed: () => onPress(),
            child: const Text(
              'view all',
              style: TextStyle(
                fontSize: 12,
              ),
            ))
      ],
    );
  }
}
