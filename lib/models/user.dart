import 'package:flutter/foundation.dart';

class User extends ChangeNotifier {
  String fullName;
  String email;
  String password;
  List passwords;

  User({
    required this.email,
    required this.fullName,
    required this.password,
    this.passwords = const [],
  });
}
