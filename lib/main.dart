import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/screens/Home_Screen.dart';
import 'package:password_manager/screens/UserPasswordsScreen.dart';
import 'package:password_manager/screens/intro_screen.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:password_manager/screens/register_screen.dart';
import 'package:password_manager/widgets/CustomNavDrawer.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(PasswordManager());
}

class PasswordManager extends StatelessWidget {
  final controller = SidebarXController(selectedIndex: 0, extended: true);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Montserrat",
      ),
      initialRoute:
          _auth.currentUser != null ? HomeScreen.route : 'introScreen',
      routes: {
        IntroScreen.route: (context) => IntroScreen(),
        HomeScreen.route: (context) => HomeScreen(),
        RegisterScreen.route: (context) => RegisterScreen(),
        LoginScreen.route: (context) => LoginScreen(),
        UserPasswordsScreen.route: (context) => UserPasswordsScreen(),
      },
    );
  }
}
