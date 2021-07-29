import 'package:flutter/material.dart';
import 'package:movie_app/resources/dimens.dart';

class TitleText extends StatelessWidget {
  final String titleText;

  const TitleText(
      this.titleText,
      );

  @override
  Widget build(BuildContext context) {
    return Text(
      titleText,
      style: TextStyle(
        color: Color.fromRGBO(83, 89, 103, 1.0),
        fontSize: TEXT_REGULAR,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}