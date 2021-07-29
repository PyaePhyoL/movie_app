import 'package:flutter/material.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/network/api_constants.dart';
import 'package:movie_app/resources/colors.dart';
import 'package:movie_app/resources/dimens.dart';
import 'package:movie_app/widgets/play_button.dart';

class ShowCasesView extends StatelessWidget {
  final MovieVO mMovie;


  ShowCasesView({this.mMovie});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: MARGIN_MEDIUM),
      width: 300,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              "$IMAGE_BASE_URL${mMovie.posterPath}",
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: PlayButton(),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(MARGIN_MEDIUM_2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mMovie.title,
                    style: TextStyle(
                      fontSize: TEXT_LARGE,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    mMovie.releaseDate,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: TEXT_REGULAR_2X,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
