import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/widgets/AccentColorBoxButton.dart';
import 'package:password_manager/widgets/CustomTextField.dart';
import 'package:password_manager/widgets/PasswordNavBar.dart';
import 'package:uuid/uuid.dart';

import '../models/password.dart';
import '../widgets/PasswordListItem.dart';

class UserPasswordsScreen extends StatefulWidget {
  static String route = '/user/passwords';

  @override
  State<UserPasswordsScreen> createState() => _UserPasswordsScreenState();
}

class _UserPasswordsScreenState extends State<UserPasswordsScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  bool isSearching = false;

  String searchText = '';

  void updateSearching(bool value) {
    setState(() {
      isSearching = value;
    });
  }

  void updateState(_passwords) {
    setState(() {
      //passwords = _passwords;
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
    return StreamBuilder(
        stream: _firestore.collection("UserData").doc(_user?.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            CircularProgressIndicator();
          }

          List<dynamic> passwordList;
          try {
            passwordList = snapshot.data?.get('passwords') ?? [];
          } catch (e) {
            passwordList = [];
          }
          List<dynamic> filteredPasswords = passwordList
              .where((password) => password['site']
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
              .toList();

          return Container(
            color: ThemeData.light().scaffoldBackgroundColor,
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  PasswordNavBar(
                    passLength: passwordList.length,
                    updateSearch: updateSearch,
                    update: updateSearching,
                    isSearching: isSearching,
                    searchText: searchText,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                      child: passwordList.length == 0
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "OOPS",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    "Looks Like you dont have any saved passwords!",
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
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ElevatedButton(
                            onPressed: () {
                              showBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return BottomSheet(updateState);
                                  });
                            },
                            child: Text("Add Password"),
                            style: const ButtonStyle(
                              shape: MaterialStatePropertyAll(StadiumBorder()),
                              foregroundColor:
                                  MaterialStatePropertyAll(primaryColor),
                              backgroundColor:
                                  MaterialStatePropertyAll(accentColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

class BottomSheet extends StatefulWidget {
  late Function updateState;
  BottomSheet(this.updateState);

  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool hasError = false;

  void handleAdd(context) async {
    var user = _auth.currentUser;
    final docRef = _firestore.collection("UserData").doc(user?.uid);

    siteError = null;
    imageError = null;
    emailOrUsernameError = null;
    passwordErrorText = null;
    hasError = false;

    if (siteController.text == "") {
      hasError = true;
      siteError = "Required";
    }
    if (emailOrUsernameController.text == "") {
      emailOrUsernameError = "Required";
      hasError = true;
    }
    if (passwordController.text == "") {
      hasError = true;
      passwordErrorText = "Required";
    }

    if (hasError == false) {
      print('object');
      try {
        final existing = await docRef.get();
        final passwordList = existing.data()?['passwords'] ?? [];

        passwordList.add({
          "id": Uuid().v4(),
          "site": siteController.text,
          "emailOrUsername": emailOrUsernameController.text,
          "password": passwordController.text,
          "created": DateTime.now(),
          'image': imageController.text == ""
              ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSet0Q_ByOeOpuSI_PXncBQPuG0j3CDWiz0rQ&usqp=CAU"
              : imageController.text
        });

        await docRef.update({'passwords': passwordList});

        print(passwordList);

        // updateState(passwordList);
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
      }
    }

    setState(() {});
  }

  final TextEditingController siteController = TextEditingController();

  final FocusNode siteNode = FocusNode();

  String siteText = "";

  final TextEditingController emailOrUsernameController =
      TextEditingController();

  final FocusNode emailOrUsernameNode = FocusNode();

  String emailOrUsernameText = "";

  final TextEditingController passwordController = TextEditingController();

  final FocusNode passwordNode = FocusNode();

  String passwordText = "";

  final TextEditingController imageController = TextEditingController();

  final FocusNode imageNode = FocusNode();

  String imageText = "";

  var siteError = null;

  var emailOrUsernameError = null;

  var passwordErrorText = null;

  var imageError = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Save A new password",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 50,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: CustomTextField(
                      focusNode: siteNode,
                      controller: siteController,
                      labelText: "Site",
                      icon: Icons.alternate_email_sharp,
                      hideText: false,
                      fieldText: siteText,
                      errorString: siteError),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: CustomTextField(
                      focusNode: emailOrUsernameNode,
                      controller: emailOrUsernameController,
                      labelText: "Email or Username",
                      icon: Icons.person,
                      hideText: false,
                      fieldText: emailOrUsernameText,
                      errorString: emailOrUsernameError),
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: CustomTextField(
                        focusNode: passwordNode,
                        controller: passwordController,
                        labelText: "Password",
                        icon: Icons.key,
                        hideText: false,
                        fieldText: passwordText,
                        errorString: passwordErrorText)),
                Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: CustomTextField(
                        focusNode: imageNode,
                        controller: imageController,
                        labelText: "Image Url",
                        icon: Icons.image,
                        hideText: false,
                        fieldText: imageText,
                        errorString: null)),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: AccentColorBoxButton(
                        child: Text("Add"),
                        onPressed: () async {
                          handleAdd(context);
                        })),
              ],
            )
          ],
        ),
      ),
    );
  }
}
