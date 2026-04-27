import 'package:flutter/material.dart';

class MySignButton extends StatelessWidget {
  final String buttonText;
  final Function()? onTap;
  const MySignButton({
    super.key,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 25),
        margin: EdgeInsets.symmetric(horizontal: 25),
        color: Theme.of(context).colorScheme.primary,
        child: Center(child: Text(buttonText)),
      ),
    );
  }
}
