import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app/resources/colors.dart';
import 'package:movie_app/resources/dimens.dart';

class RatingView extends StatelessWidget {
  const RatingView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      itemSize: MARGIN_MEDIUM_2,
      initialRating: 5,
      allowHalfRating: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Icon(
          Icons.star,
          color: PLAY_BUTTON_COLOR,
        );
      },
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }
}
