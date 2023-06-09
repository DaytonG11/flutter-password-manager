import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:password_manager/constants.dart';

class CustomNavDrawer extends StatelessWidget {
  final SidebarXController controller;
  final Function update;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CustomNavDrawer({required this.controller, required this.update});

  void handleTap(context, int i) {
    update(i);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      showToggleButton: false,
      controller: controller,
      theme: SidebarXTheme(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      footerItems: [
        SidebarXItem(
            icon: Icons.exit_to_app,
            label: "Log Out",
            onTap: () async {
              await _auth.signOut();
              //TODO Sign out functionality
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginScreen.route, ModalRoute.withName('/'));
            })
      ],
      items: [
        SidebarXItem(
          icon: Icons.home,
          label: "Home",
          onTap: () => handleTap(context, 0),
        ),
        SidebarXItem(
          icon: Icons.key,
          label: "Passwords",
          onTap: () => handleTap(context, 1),
        ),
        SidebarXItem(
          icon: Icons.person,
          label: "Profile",
          onTap: () => handleTap(context, 2),
        ),
      ],
      extendedTheme: SidebarXTheme(
        padding: EdgeInsets.only(bottom: 20),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: accentColor.withOpacity(0.37),
          ),
        ),
        itemTextPadding: const EdgeInsets.only(left: 10),
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        width: 200,
        selectedTextStyle: TextStyle(color: accentColor, fontSize: 20),
        selectedIconTheme: IconThemeData(color: accentColor, size: 20),
        selectedItemTextPadding: EdgeInsets.only(left: 10),
        iconTheme:
            IconThemeData(color: Colors.white.withOpacity(0.7), size: 15),
        hoverColor: Colors.grey,
        decoration: BoxDecoration(
          color: secondaryColor.withOpacity(1),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade900.withOpacity(0.8),
                spreadRadius: 5,
                blurRadius: 30)
          ],
        ),
      ),
      headerBuilder: (context, extended) {
        return Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: SizedBox(
            height: 150,
            width: 150,
            child: Image.asset(
              'assets/images/greylogo.png',
              height: 100,
              width: 100,
            ),
          ),
        );
      },
    );
  }
}
