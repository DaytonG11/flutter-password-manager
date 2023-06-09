// ignore_for_file: await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';

import '../models/user.dart' as UserModel;
import '../models/password.dart';
import '../widgets/PasswordListItem.dart';
import '../widgets/TopWelocmeBar.dart';
import '../widgets/UserHomePassDivider.dart';

class UserHomeScreen extends StatefulWidget {
  final Function setScreen;
  UserHomeScreen({required this.setScreen});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  bool isSearching = false;

  String searchText = '';
  String safetyScore = "0%";
  void updateSearching(bool value) {
    setState(() {
      isSearching = value;
    });
  }

  void updateSearch(String search) {
    setState(() {
      searchText = search;
    });
  }

  void handleDelete(String id) async {
    if (_user != null) {
      final docRef = _firestore.collection("UserData").doc(_user?.uid);

      final existing = await docRef.get();

      final passwordList = List.from(existing.data()?['passwords'] ?? []);

      try {
        passwordList.removeWhere((password) => password["id"] == id);

        await docRef.update({'passwords': passwordList});

        // Update the screen by triggering a rebuild
        setState(() {});
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(searchText);

    return StreamBuilder(
        stream: _firestore.collection("UserData").doc(_user?.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            CircularProgressIndicator();
          }
          List<dynamic> passwordList;
          try {
            passwordList = snapshot.data?.get('passwords') ?? [];
            passwordList = passwordList
                .where((password) =>
                    DateTime.now()
                        .difference(password["created"].toDate())
                        .inDays <=
                    3)
                .toList();
          } catch (e) {
            passwordList = [];
          }

          List<dynamic> filteredPasswords = passwordList
              .where((password) => password['site']
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
              .toList();
          switch (passwordList.length) {
            case <= 0:
              safetyScore = "0%";
            case >= 2:
              safetyScore = "15%";
            case >= 5:
              safetyScore = "45%";
            case >= 8:
              safetyScore = "60%";
            case >= 10:
              safetyScore = "80%";
            case >= 14:
              safetyScore = "98%";
          }

          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TopWelcomeBar(
                    updateSearch: updateSearch,
                    update: updateSearching,
                    isSearching: isSearching,
                    searchText: searchText,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          stops: [0.5, 0.8],
                          colors: [
                            accentColor.withOpacity(0.8),
                            secondaryColor,
                          ],
                        ),
                        boxShadow: [BoxShadow(color: Colors.black)]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Safety Score",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                passwordList.length > 1
                                    ? '${passwordList.length.toString()} Passwords'
                                    : '${passwordList.length.toString()} Password',
                                style: const TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          Text(
                            safetyScore,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        UserHomePassDivider(
                          text: "Recently Added",
                          onPress: () => widget.setScreen(1),
                        ),
                        Expanded(
                            child: passwordList.length == 0
                                ? const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "OOPS",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          "Looks Like you havent been adding passwords!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        )
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: filteredPasswords.length,
                                    itemBuilder: (context, index) {
                                      return PasswordListItem(
                                        delete: handleDelete,
                                        password: filteredPasswords[index],
                                      );
                                    },
                                  )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
