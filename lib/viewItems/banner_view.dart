import 'package:flutter/material.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/network/api_constants.dart';
import 'package:movie_app/resources/dimens.dart';
import 'package:movie_app/widgets/gradient_view.dart';
import 'package:movie_app/widgets/play_button.dart';

class BannerView extends StatelessWidget {
  final MovieVO mMovie;

  BannerView({this.mMovie});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Positioned.fill(
            child: BannerImageView(mImageUrl: mMovie.posterPath,),
          ),
          Positioned.fill(
            child: GradientView(),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: BannerTitleView(title: mMovie.title,),
          ),
          Align(
            alignment: Alignment.center,
            child: PlayButton(),
          ),
        ],
      ),
    );
  }
}



class BannerTitleView extends StatelessWidget {
  final String title;


  BannerTitleView({this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(MARGIN_MEDIUM_2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: TEXT_HEADING_1X,
            ),
          ),
          Text(
            "Official Review",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: TEXT_HEADING_1X,
            ),
          ),
        ],
      ),
    );
  }
}

class BannerImageView extends StatelessWidget {
  final String mImageUrl;


  BannerImageView({this.mImageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      "$IMAGE_BASE_URL$mImageUrl",
      fit: BoxFit.cover,
    );
  }
}
