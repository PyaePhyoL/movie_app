import 'package:flutter/material.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/data/models/movie_model_impl.dart';
import 'package:movie_app/data/vos/credit_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/network/api_constants.dart';
import 'package:movie_app/resources/colors.dart';
import 'package:movie_app/resources/dimens.dart';
import 'package:movie_app/resources/strings.dart';
import 'package:movie_app/viewItems/actors_and_creators_section_view.dart';
import 'package:movie_app/widgets/genre_chip_view.dart';
import 'package:movie_app/widgets/gradient_view.dart';
import 'package:movie_app/widgets/rating_view.dart';
import 'package:movie_app/widgets/title_text.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  MovieDetailPage(this.movieId);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {

  MovieModel mMovieModel = MovieModelImpl();

  MovieVO mMovie;
  List<CreditVO> mActorsList;
  List<CreditVO> mCreatorsList;

  @override
  void initState() {
    super.initState();

    /// Movie Detail
    mMovieModel.getMovieDetails(widget.movieId).then((movie) {
      setState(() {
        mMovie = movie;
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });

    /// Movie Detail Database
    mMovieModel.getMovieDetailFromDatabase(widget.movieId).then((movie) {
      setState(() {
        mMovie = movie;
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });

    mMovieModel.getCreditsByMovie(widget.movieId).then((creditsList) {
      setState(() {
        mActorsList = creditsList.where((credit) => credit.isActor()).toList();

        mCreatorsList =
            creditsList.where((credit) => credit.isCreator()).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: HOME_SCREEN_BACKGROUND_COLOR,
        child: (mMovie != null)
            ? CustomScrollView(
                slivers: [
                  MovieDetailSliverAppBarView(
                    () => Navigator.pop(context),
                    mMovie,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        TrailerSection(
                          mMovie: mMovie,
                        ),
                        ActorsAndCreatorsSectionView(
                          MOVIE_DETAIL_ACTORS_TITLE,
                          "",
                          seeMoreButtonVisibility: false,
                          actorList: mActorsList,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: MARGIN_MEDIUM_2,
                            vertical: MARGIN_LARGE,
                          ),
                          child: AboutFilmSectionView(
                            mMovie: mMovie,
                          ),
                        ),
                        (mCreatorsList != null && mCreatorsList.isNotEmpty)
                            ? ActorsAndCreatorsSectionView(
                                MOVIE_DETAIL_CREATORS_TITLE,
                                MOVIE_DETAIL_MORE_CREATORS_TITLE,
                                actorList: mCreatorsList,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              ),
      ),
    );
  }
}

class AboutFilmSectionView extends StatelessWidget {
  final MovieVO mMovie;

  AboutFilmSectionView({
    @required this.mMovie,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText("ABOUT FILM"),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        AboutFilmInfoView(
          "Original Title:",
          mMovie.originalTitle,
        ),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        AboutFilmInfoView(
          "Type:",
          mMovie.genres.map((genre) => genre.name).join(","),
        ),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        AboutFilmInfoView(
          "Production:",
          mMovie.productionCountries.map((country) => country.name).join(","),
        ),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        AboutFilmInfoView(
          "Premiere:",
          mMovie.releaseDate,
        ),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        AboutFilmInfoView(
          "Description:",
          mMovie.overview,
        ),
      ],
    );
  }
}

class AboutFilmInfoView extends StatelessWidget {
  final String title;
  final String info;

  AboutFilmInfoView(this.title, this.info);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 4,
          child: Text(
            title,
            style: TextStyle(
              color: HOME_SCREEN_LIST_TITLE_COLOR,
              fontWeight: FontWeight.w500,
              fontSize: TEXT_REGULAR_2X,
            ),
          ),
        ),
        SizedBox(
          width: MARGIN_MEDIUM_2,
        ),
        Expanded(
          child: Text(
            info,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: TEXT_REGULAR_2X,
            ),
          ),
        )
      ],
    );
  }
}

class TrailerSection extends StatelessWidget {
  final MovieVO mMovie;

  TrailerSection({this.mMovie});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MARGIN_MEDIUM_2, vertical: MARGIN_MEDIUM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MovieTimeAndGenreView(
              genreList: mMovie.genres.map((genre) => genre.name).toList()),
          SizedBox(
            height: MARGIN_MEDIUM_2,
          ),
          StoryLineView(
            storyLine: mMovie.overview,
          ),
          SizedBox(
            height: MARGIN_MEDIUM_2,
          ),
          Row(
            children: [
              MovieDetailScreenButtonView(
                "PLAY TRAILER",
                PLAY_BUTTON_COLOR,
                Icon(
                  Icons.play_circle_fill,
                  color: Colors.black45,
                ),
              ),
              SizedBox(
                width: MARGIN_MEDIUM_2,
              ),
              MovieDetailScreenButtonView(
                "RATE MOVIE",
                Colors.transparent,
                Icon(
                  Icons.star,
                  color: PLAY_BUTTON_COLOR,
                ),
                isGhostButton: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MovieDetailScreenButtonView extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Icon icon;
  final bool isGhostButton;

  MovieDetailScreenButtonView(
    this.title,
    this.backgroundColor,
    this.icon, {
    this.isGhostButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MARGIN_XXLARGE,
      padding: EdgeInsets.symmetric(horizontal: MARGIN_CARD_MEDIUM_2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(MARGIN_LARGE),
        border: (isGhostButton)
            ? Border.all(
                color: Colors.white,
              )
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(
            width: MARGIN_SMALL,
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: TEXT_REGULAR_2X,
            ),
          )
        ],
      ),
    );
  }
}

class StoryLineView extends StatelessWidget {
  final String storyLine;

  StoryLineView({this.storyLine});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText("STORYLINE"),
        SizedBox(
          height: MARGIN_MEDIUM,
        ),
        Text(
          storyLine,
          style: TextStyle(
            color: Colors.white,
            fontSize: TEXT_REGULAR_2X,
          ),
        ),
      ],
    );
  }
}

class MovieTimeAndGenreView extends StatelessWidget {
  const MovieTimeAndGenreView({
    Key key,
    @required this.genreList,
  }) : super(key: key);

  final List<String> genreList;

  List<Widget> _createMovieTimeAndGenreWidget() {
    List<Widget> widgets = [
      Icon(
        Icons.access_time,
        color: Colors.amber,
      ),
      SizedBox(
        width: MARGIN_MEDIUM,
      ),
      Text(
        "2hr 13min",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      SizedBox(
        width: MARGIN_MEDIUM,
      ),
    ];

    widgets.addAll(genreList.map((genre) => GenreChipView(genre)).toList());

    widgets.add(
      Icon(
        Icons.favorite_border_outlined,
        color: Colors.white,
      ),
    );

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: _createMovieTimeAndGenreWidget(),
    );
  }
}

class MovieDetailSliverAppBarView extends StatelessWidget {
  final Function onTapBack;
  final MovieVO mMovie;

  MovieDetailSliverAppBarView(this.onTapBack, this.mMovie);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: PRIMARY_COLOR,
      automaticallyImplyLeading: false,
      expandedHeight: MOVIE_DETAIL_SCREEN_SLIVER_APP_BAR_HEIGHT,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Positioned.fill(
              child: MovieDetailSliverAppBarImageView(mMovie.posterPath),
            ),
            Positioned.fill(
              child: GradientView(),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: MARGIN_XLARGE,
                  left: MARGIN_MEDIUM_2,
                ),
                child: BackButtonView(onTapBack),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: MARGIN_XLARGE + MARGIN_MEDIUM,
                  right: MARGIN_MEDIUM_2,
                ),
                child: SearchButtonView(),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: MARGIN_MEDIUM_2,
                  vertical: MARGIN_MEDIUM,
                ),
                child: SliverAppBarInfoView(
                  mMovie: mMovie,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SliverAppBarInfoView extends StatelessWidget {
  final MovieVO mMovie;

  SliverAppBarInfoView({
    @required this.mMovie,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            MovieDetailYearView(
              releaseDate: mMovie.releaseDate,
            ),
            Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RatingView(),
                    SizedBox(
                      height: MARGIN_SMALL,
                    ),
                    Text(
                      "${mMovie.voteCount} VOTES",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: MARGIN_CARD_MEDIUM_2,
                    ),
                  ],
                ),
                SizedBox(
                  width: MARGIN_MEDIUM,
                ),
                Text(
                  "${mMovie.voteAverage}",
                  style: TextStyle(
                    fontSize: 56,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        Text(
          mMovie.originalTitle,
          style: TextStyle(
            fontSize: TEXT_HEADING_2X,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}

class MovieDetailYearView extends StatelessWidget {
  final String releaseDate;

  MovieDetailYearView({
    @required this.releaseDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Text(
          releaseDate.substring(0, 4),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: TEXT_REGULAR_2X,
          ),
        ),
      ),
    );
  }
}

class SearchButtonView extends StatelessWidget {
  const SearchButtonView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.search,
      size: MARGIN_XLARGE,
      color: Colors.white,
    );
  }
}

class BackButtonView extends StatelessWidget {
  final Function onTapBack;

  BackButtonView(this.onTapBack);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapBack,
      child: Container(
        width: MARGIN_XXLARGE,
        height: MARGIN_XXLARGE,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black54,
        ),
        child: Icon(
          Icons.chevron_left,
          size: MARGIN_XLARGE,
          color: Colors.white,
        ),
      ),
    );
  }
}

class MovieDetailSliverAppBarImageView extends StatelessWidget {
  final String imageUrl;

  MovieDetailSliverAppBarImageView(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      "$IMAGE_BASE_URL$imageUrl",
      fit: BoxFit.cover,
    );
  }
}
