import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/screens/UserPasswordsScreen.dart';
import 'package:password_manager/screens/UserProfileScreen.dart';
import 'package:password_manager/widgets/CustomNavDrawer.dart';
import 'package:sidebarx/sidebarx.dart';
import 'UserHomeScreen.dart';

class HomeScreen extends StatefulWidget {
  static String route = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = SidebarXController(selectedIndex: 0, extended: true);
  GlobalKey key = GlobalKey();
  String screen = 'Home';

  void updateScreen() {
    setState(() {
      print('updae');
    });
  }

  String getScreen() {
    switch (controller.selectedIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Passwords';
      case 2:
        return 'Profile';
    }
    return 'route unavailable';
  }

  void setScreen(int _screen) {
    setState(() {
      controller.selectIndex(_screen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      // appBar: AppBar(
      //   backgroundColor: secondaryColor,
      //   centerTitle: true,
      //   title: Text(getScreen()),
      // ),
      drawer: CustomNavDrawer(
        update: setScreen,
        controller: controller,
      ),
      body: Builder(
        builder: (ctx) => GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0) {
                // User swiped Left
                Scaffold.of(ctx).openDrawer();
              } else if (details.primaryVelocity! < 0) {
                // User swiped Right
                Scaffold.of(ctx).closeDrawer();
              }
            },
            child: SafeArea(
              child: controller.selectedIndex == 0
                  ? UserHomeScreen(setScreen: setScreen)
                  : controller.selectedIndex == 1
                      ? UserPasswordsScreen()
                      : controller.selectedIndex == 2
                          ? UserProfileScreen()
                          : Placeholder(),
            )),
      ),
    );
  }
}
