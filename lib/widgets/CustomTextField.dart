import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';

class CustomTextField extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool hideText;
  String fieldText;
  var errorString;

  CustomTextField(
      {required this.focusNode,
      required this.controller,
      required this.labelText,
      required this.icon,
      required this.hideText,
      required this.fieldText,
      required this.errorString});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool hasFocus = false; // Added line

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      setState(() {
        hasFocus = widget.focusNode.hasFocus; // Updated line
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.focusNode.removeListener(() {});
    widget.focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 7,
              offset: Offset(0, 3)),
        ],
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5, top: 5),
            child: TextField(
              cursorColor: accentColor,
              focusNode: widget.focusNode,
              textAlignVertical: TextAlignVertical.center,
              onTap: () {
                setState(() {
                  hasFocus = true;
                });
              },
              onEditingComplete: () {
                setState(() {
                  hasFocus = false;
                });
                widget.focusNode.unfocus();
              },
              keyboardType: TextInputType.name,
              obscureText: widget.hideText,
              onChanged: (value) {
                widget.controller.text = value;
                widget.fieldText = value;
                print(widget.controller.text);
                //widget.controller.text = value;
              },
              onTapOutside: (event) {
                setState(() {
                  hasFocus = false;
                });
                widget.focusNode.unfocus();
              },
              style: TextStyle(decoration: TextDecoration.none),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  widget.icon,
                  color: hasFocus ? accentColor : secondaryColor,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                label: Text(widget.labelText),
                labelStyle: const TextStyle(color: secondaryColor),
                floatingLabelStyle: const TextStyle(color: accentColor),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                errorText: widget.errorString,
                errorStyle: const TextStyle(
                  fontSize: 0,
                ),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10)),
                focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          widget.errorString.toString() == "null"
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    widget.errorString.toString(),
                    style: TextStyle(color: Colors.red.shade600),
                  ),
                )
        ],
      ),
    );
  }
}
