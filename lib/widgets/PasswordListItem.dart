import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/models/password.dart';
import '../constants.dart';
import 'package:clipboard/clipboard.dart';

class PasswordListItem extends StatefulWidget {
  final dynamic password;
  final Function delete;

  PasswordListItem({super.key, required this.password, required this.delete});

  @override
  State<PasswordListItem> createState() => _PasswordListItemState();
}

class _PasswordListItemState extends State<PasswordListItem> {
  bool shoxClose = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => setState(() {
        shoxClose = !shoxClose;
      }),
      child: Container(
        height: 75,
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.symmetric(vertical: 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 50,
                padding: EdgeInsets.all(10),
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Image.network(
                  widget.password["image"],
                  errorBuilder: (context, error, stackTrace) => Container(),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.password["site"],
                        style: TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.password["emailOrUsername"],
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              !shoxClose
                  ? IconButton(
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: widget.password["password"]));
                      },
                      icon: Icon(Icons.copy_rounded),
                      color: secondaryColor.withOpacity(0.6),
                    )
                  : IconButton(
                      onPressed: () {
                        widget.delete(widget.password["id"]);
                      },
                      icon: Icon(Icons.close),
                      iconSize: 30,
                      color: Colors.red.withOpacity(0.6),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
