import 'package:flutter/material.dart';
import 'package:movie_app/resources/colors.dart';
import 'package:movie_app/resources/dimens.dart';

class PlayButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.play_circle_fill,
      color: PLAY_BUTTON_COLOR,
      size: BANNER_PLAY_BUTTON_SIZE,
    );
  }
}