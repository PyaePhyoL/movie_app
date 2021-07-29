import 'package:flutter/material.dart';

class SeeMoreText extends StatelessWidget {
  final String seeMoreText;
  final Color color;
  const SeeMoreText(this.seeMoreText, {this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Text(
      seeMoreText,
      style: TextStyle(
        color: color,
        decoration: TextDecoration.underline,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}