import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/user.dart';
import 'HomeScreenWelcomText.dart';

class PasswordNavBar extends StatelessWidget {
  bool isSearching;
  String searchText;
  Function update;
  Function updateSearch;
  int passLength;

  PasswordNavBar({
    required this.passLength,
    super.key,
    required this.update,
    required this.searchText,
    required this.updateSearch,
    required this.isSearching,
  });

  @override
  Widget build(BuildContext context) {
    return !isSearching
        ? Container(
            color: isSearching ? accentColor.withOpacity(0.2) : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${passLength} passwords saved',
                  style: TextStyle(
                      color: secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: IconButton(
                    onPressed: () {
                      update(isSearching = !isSearching);
                    },
                    icon: Icon(Icons.search),
                  ),
                ),
              ],
            ),
          )
        : Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: accentColor.withOpacity(0.1)),
                  child: TextField(
                    autocorrect: false,
                    enableSuggestions: false,
                    keyboardType: TextInputType.text,
                    cursorColor: accentColor,
                    style: TextStyle(
                        decoration: TextDecoration.none, color: secondaryColor),
                    autofocus: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hoverColor: accentColor,
                      focusColor: accentColor,
                    ),
                    onChanged: (value) {
                      searchText = value;
                      updateSearch(searchText);
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: IconButton(
                  onPressed: () {
                    update(isSearching = !isSearching);
                    updateSearch('');
                  },
                  icon: Icon(Icons.close),
                ),
              ),
            ],
          );
  }
}
