import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final FocusNode? focusNode;
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        focusNode: focusNode,
        //don't show password
        obscureText: obscureText,
        //controling the text
        controller: controller,

        //decorating
        decoration: InputDecoration(
          //normally the bordercolor white
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          //when clicked border color grey[500] - primary
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          //what text it shows when nothing is typed
          hintText: hintText,
          //hint text style
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          //what color will the textfield be
          fillColor: Theme.of(context).colorScheme.secondary,
          //will the textfield be filled with color
          filled: true,
        ),
      ),
    );
  }
}
