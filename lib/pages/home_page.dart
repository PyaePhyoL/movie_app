import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/data/models/movie_model_impl.dart';
import 'package:movie_app/data/vos/actor_vo.dart';
import 'package:movie_app/data/vos/genre_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/pages/movie_detail_page.dart';
import 'package:movie_app/resources/colors.dart';
import 'package:movie_app/resources/dimens.dart';
import 'package:movie_app/resources/strings.dart';
import 'package:movie_app/viewItems/actors_and_creators_section_view.dart';
import 'package:movie_app/viewItems/banner_view.dart';
import 'package:movie_app/viewItems/movie_view.dart';
import 'package:movie_app/viewItems/show_cases_view.dart';
import 'package:movie_app/widgets/see_more_text.dart';
import 'package:movie_app/widgets/title_text.dart';
import 'package:movie_app/widgets/title_text_with_see_more_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MovieModel mMovieModel = MovieModelImpl();

  List<MovieVO> mNowPlayingMovieList;
  List<MovieVO> mShowcaseMovieList;
  List<MovieVO> mPopularMovieList;
  List<MovieVO> mMoviesByGenreList;
  List<GenreVO> mGenreList;
  List<ActorVO> mActorList;

  @override
  void initState() {
    super.initState();

    /// Now Playing Movies
    // mMovieModel.getNowPlayingMovies(1).then((movieList) {
    //   setState(() {
    //     mNowPlayingMovieList = movieList;
    //   });
    // }).catchError((error) {
    //   debugPrint(error.toString());
    // });

    /// Now Playing Movies Database
    mMovieModel.getNowPlayingMoviesFromDatabase().listen((movieList) {
      setState(() {
        mNowPlayingMovieList = movieList;
      });
    }).onError((error) {
      debugPrint(error.toString());
    });

    /// Popular Movies
    // mMovieModel.getPopularMovies(1).then((movieList) {
    //   setState(() {
    //     mPopularMovieList = movieList;
    //   });
    // }).catchError((error) {
    //   debugPrint(error.toString());
    // });

    /// Popular Movies Database
    mMovieModel.getPopularMoviesFromDatabase().listen((movieList) {
      setState(() {
        mPopularMovieList = movieList;
      });
    }).onError((error) {
      debugPrint(error.toString());
    });

    /// Showcase
    // mMovieModel.getTopRatedMovies(1).then((movieList) {
    //   setState(() {
    //     mShowcaseMovieList = movieList;
    //   });
    // }).catchError((error) {
    //   debugPrint(error.toString());
    // });

    /// Showcase Database
    mMovieModel.getTopRatedMoviesFromDatabase().listen((movieList) {
      setState(() {
        mShowcaseMovieList = movieList;
      });
    }).onError((error) {
      debugPrint(error.toString());
    });

    /// Actors
    mMovieModel.getActors(1).then((actorList) {
      setState(() {
        mActorList = actorList;
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });

    /// Actors Database
    mMovieModel.getAllActorsFromDatabase().then((actorList) {
      setState(() {
        mActorList = actorList;
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });

    /// Genres
    mMovieModel.getGenres().then((genreList) {
      setState(() {
        mGenreList = genreList;

        /// Movies by Genre
        _getMoviesByGenreAndRefresh(mGenreList.first.id);
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });

    /// Genres Database
    mMovieModel.getGenresFromDatabase().then((genreList) {
      setState(() {
        mGenreList = genreList;

        _getMoviesByGenreAndRefresh(genreList.first.id);
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  void _getMoviesByGenreAndRefresh(int genreId) {
    mMovieModel.getMoviesByGenre(genreId).then((moviesByGenre) {
      setState(() {
        mMoviesByGenreList = moviesByGenre;
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: PRIMARY_COLOR,
        title: Text(
          "Discover",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: Icon(
          Icons.menu,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: MARGIN_MEDIUM_2,
            ),
            child: Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      body: Container(
        color: HOME_SCREEN_BACKGROUND_COLOR,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BannerSectionView(mPopularMovieList),
              BestPopularMoviesAndSerialsSectionView(
                (movieId) => _navigateToMovieDetailsScreen(context, movieId),
                mNowPlayingMovieList,
              ),
              SizedBox(
                height: MARGIN_LARGE,
              ),
              CheckMovieShowTimesSectionView(),
              SizedBox(
                height: MARGIN_LARGE,
              ),
              GenreSectionView(
                genreList: mGenreList,
                mMoviesByGenreList: mMoviesByGenreList,
                onTapMovie: (movieId) => _navigateToMovieDetailsScreen(context, movieId),
                onTapGenre: (genreId) => _getMoviesByGenreAndRefresh(genreId),
              ),
              SizedBox(
                height: MARGIN_LARGE,
              ),
              ShowcasesSectionView(
                showcasesMovies: mShowcaseMovieList,
              ),
              SizedBox(
                height: MARGIN_LARGE,
              ),
              ActorsAndCreatorsSectionView(
                BEST_ACTORS_TITLE,
                MORE_ACTORS_TITLE,
                actorList: mActorList,
              ),
              SizedBox(
                height: MARGIN_LARGE,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToMovieDetailsScreen(BuildContext context, int movieId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieDetailPage(movieId)),
    );
  }
}

class GenreSectionView extends StatelessWidget {
  final List<GenreVO> genreList;
  final List<MovieVO> mMoviesByGenreList;
  final Function(int) onTapMovie;
  final Function(int) onTapGenre;

  GenreSectionView({
    this.genreList,
    this.mMoviesByGenreList,
    this.onTapMovie,
    this.onTapGenre,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
          child: DefaultTabController(
            initialIndex: 0,
            length: genreList.length,
            child: TabBar(
              onTap: (index) {
                onTapGenre(genreList[index].id);
              },
              isScrollable: true,
              indicatorColor: PLAY_BUTTON_COLOR,
              unselectedLabelColor: HOME_SCREEN_LIST_TITLE_COLOR,
              tabs: genreList
                  .map(
                    (genre) => Tab(
                      child: Text(genre.name),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        Container(
          color: PRIMARY_COLOR,
          padding: EdgeInsets.only(top: MARGIN_MEDIUM_2, bottom: MARGIN_LARGE),
          child: HorizontalMovieListView(
            (movieId) => onTapMovie(movieId),
            movieList: mMoviesByGenreList,
          ),
        ),
      ],
    );
  }
}

class CheckMovieShowTimesSectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MARGIN_LARGE,
      ),
      padding: EdgeInsets.all(MARGIN_MEDIUM_2),
      height: 180,
      color: HOME_SCREEN_MOVIE_SHOWTIME_BACKGROUND_COLOR,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Check Movie\nShowtimes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: TEXT_LARGE,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              SeeMoreText(
                "SEE MORE",
                color: Colors.amber,
              ),
            ],
          ),
          Spacer(),
          Icon(
            Icons.location_on,
            size: BANNER_PLAY_BUTTON_SIZE,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class ShowcasesSectionView extends StatefulWidget {
  final List<MovieVO> showcasesMovies;

  ShowcasesSectionView({this.showcasesMovies});

  @override
  _ShowcasesSectionViewState createState() => _ShowcasesSectionViewState();
}

class _ShowcasesSectionViewState extends State<ShowcasesSectionView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
          child:
              TitleTextWithSeeMoreView(SHOWCASES_TITLE, MORE_SHOWCASES_TITLE),
        ),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        Container(
          height: SHOWCASES_HEIGHT,
          child: (widget.showcasesMovies != null)
              ? ListView(
                  padding: EdgeInsets.only(left: MARGIN_MEDIUM_2),
                  scrollDirection: Axis.horizontal,
                  children: widget.showcasesMovies
                      .map((showcaseMovie) => ShowCasesView(
                            mMovie: showcaseMovie,
                          ))
                      .take(5)
                      .toList(),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ],
    );
  }
}

class BestPopularMoviesAndSerialsSectionView extends StatelessWidget {
  final Function(int) onTapMovie;
  final List<MovieVO> movieList;

  BestPopularMoviesAndSerialsSectionView(this.onTapMovie, this.movieList);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(MARGIN_MEDIUM_2),
          child: TitleText(HOME_SCREEN_BEST_POPULAR_MOVIES_AND_SERIALS),
        ),
        HorizontalMovieListView(
          (movieId) => onTapMovie(movieId),
          movieList: movieList,
        ),
      ],
    );
  }
}

class HorizontalMovieListView extends StatelessWidget {
  final Function(int) onTapMovie;
  final List<MovieVO> movieList;

  HorizontalMovieListView(this.onTapMovie, {this.movieList});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MOVIE_LIST_HEIGHT,
      child: (movieList != null)
          ? ListView.builder(
              padding: EdgeInsets.only(left: MARGIN_MEDIUM_2),
              scrollDirection: Axis.horizontal,
              itemCount: movieList.length,
              itemBuilder: (context, index) {
                return MovieView(
                  (movieId) => onTapMovie(movieId),
                  movieList[index],
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class BannerSectionView extends StatefulWidget {
  final List<MovieVO> mPopularMovies;

  BannerSectionView(this.mPopularMovies);

  @override
  _BannerSectionViewState createState() => _BannerSectionViewState();
}

class _BannerSectionViewState extends State<BannerSectionView> {
  double _position = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 3,
          child: (widget.mPopularMovies != null)
              ? PageView(
                  onPageChanged: (page) {
                    setState(() {
                      _position = page.toDouble();
                    });
                  },
                  children: widget.mPopularMovies
                      .map((popularMovie) => BannerView(
                            mMovie: popularMovie,
                          ))
                      .take(5)
                      .toList(),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        DotsIndicator(
          dotsCount: 5,
          position: _position,
          decorator: DotsDecorator(
            color: HOME_SCREEN_DOTS_INACTION_COLOR,
            activeColor: PLAY_BUTTON_COLOR,
          ),
        ),
      ],
    );
  }
}
