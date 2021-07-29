import 'package:flutter/material.dart';
import 'package:movie_app/resources/colors.dart';
import 'package:movie_app/resources/dimens.dart';

class GenreChipView extends StatelessWidget {
  final String genreText;

  const GenreChipView(this.genreText);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: MARGIN_SMALL),
      child: Chip(
        label: Text(
          genreText,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor:
        MOVIE_DETAIL_SCREEN_GENRE_CHIP_COLOR,
      ),
    );
  }
}
