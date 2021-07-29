import 'package:movie_app/data/vos/actor_vo.dart';
import 'package:movie_app/data/vos/credit_vo.dart';
import 'package:movie_app/data/vos/genre_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/network/dataagents/movie_data_agent.dart';
import 'package:movie_app/network/dataagents/retrofit_data_agent_impl.dart';
import 'package:movie_app/persistence/daos/actor_dao.dart';
import 'package:movie_app/persistence/daos/genre_dao.dart';
import 'package:movie_app/persistence/daos/movie_dao.dart';
import 'package:stream_transform/stream_transform.dart';

import 'movie_model.dart';

class MovieModelImpl extends MovieModel {
  MovieDataAgent mDataAgent = RetrofitDataAgentImpl();

  static final MovieModelImpl _singleton = MovieModelImpl._internal();

  factory MovieModelImpl() {
    return _singleton;
  }

  MovieModelImpl._internal();

  /// Daos
  ///
  ActorDao mActorDao = ActorDao();
  GenreDao mGenreDao = GenreDao();
  MovieDao mMovieDao = MovieDao();

  ///States
  List<MovieVO> mNowPlayingMovieList;
  List<MovieVO> mShowcaseMovieList;
  List<MovieVO> mPopularMovieList;
  List<MovieVO> mMoviesByGenreList;
  List<GenreVO> mGenreList;
  List<ActorVO> mActorList;

  /// Network
  ///
  @override
  void getNowPlayingMovies(int page) {
    mDataAgent.getNowPlayingMovies(page).then((movies) async {
      List<MovieVO> nowPlayingMovies = movies.map((movie) {
        movie.isNowPlaying = true;
        movie.isTopRated = false;
        movie.isPopular = false;
        return movie;
      }).toList();
      mMovieDao.saveMovies(nowPlayingMovies);
      mNowPlayingMovieList = nowPlayingMovies;
      notifyListeners();
    });
  }

  @override
  void getPopularMovies(int page) {
    mDataAgent.getPopularMovies(page).then((movies) async {
      List<MovieVO> popularMovies = movies.map((movie) {
        movie.isPopular = true;
        movie.isTopRated = false;
        movie.isNowPlaying = false;
        return movie;
      }).toList();
      mMovieDao.saveMovies(popularMovies);
      mPopularMovieList = popularMovies;
      notifyListeners();
    });
  }

  @override
  void getTopRatedMovies(int page) {
    mDataAgent.getTopRatedMovies(page).then((movies) async {
      List<MovieVO> topRatedMovies = movies.map((movie) {
        movie.isTopRated = true;
        movie.isNowPlaying = false;
        movie.isPopular = false;
        return movie;
      }).toList();
      mMovieDao.saveMovies(topRatedMovies);
      mShowcaseMovieList = topRatedMovies;
      notifyListeners();
    });
  }

  @override
  Future<List<ActorVO>> getActors(int page) {
    return mDataAgent.getActors(page).then((actors) async {
      mActorDao.saveAllActors(actors);
      mActorList = actors;
      notifyListeners();
      return Future.value(actors);
    });
  }

  @override
  Future<List<GenreVO>> getGenres() {
    return mDataAgent.getGenres().then((genres) async {
      mGenreDao.saveAllGenres(genres);
      mGenreList = genres;
      getMoviesByGenre(genres.first.id).then((moviesByGenreList) {
        mMoviesByGenreList = moviesByGenreList;
        notifyListeners();
      });
      notifyListeners();
      return Future.value(genres);
    });
  }

  @override
  Future<List<MovieVO>> getMoviesByGenre(int genreId) {
    return mDataAgent.getMoviesByGenre(genreId);
  }

  @override
  Future<List<CreditVO>> getCreditsByMovie(int movieId) {
    return mDataAgent.getCreditsByMovie(movieId);
  }

  @override
  Future<MovieVO> getMovieDetails(int movieId) {
    return mDataAgent.getMovieDetails(movieId).then((movie) async {
      mMovieDao.saveSingleMovie(movie);
      return Future.value(movie);
    });
  }

  /// Database

  @override
  Future<List<ActorVO>> getAllActorsFromDatabase() {
    return Future.value(mActorDao.getAllActors());
  }

  @override
  Future<List<GenreVO>> getGenresFromDatabase() {
    return Future.value(mGenreDao.getAllGenres());
  }

  @override
  Future<MovieVO> getMovieDetailFromDatabase(int movieId) {
    return Future.value(mMovieDao.getMovieById(movieId));
  }

  @override
  Stream<List<MovieVO>> getNowPlayingMoviesFromDatabase() {
    this.getNowPlayingMovies(1);
    return mMovieDao
        .getAllMoviesEventStream()
        .startWith(mMovieDao.getNowPlayingMoviesStream())
        .map((event) => mMovieDao.getNowPlayingMovies());
  }

  @override
  Stream<List<MovieVO>> getPopularMoviesFromDatabase() {
    this.getPopularMovies(1);
    return mMovieDao
        .getAllMoviesEventStream()
        .startWith(mMovieDao.getPopularMoviesStream())
        .map((event) => mMovieDao.getPopularMovies());
  }

  @override
  Stream<List<MovieVO>> getTopRatedMoviesFromDatabase() {
    this.getTopRatedMovies(1);
    return mMovieDao
        .getAllMoviesEventStream()
        .startWith(mMovieDao.getTopRatedMoviesStream())
        .map((event) => mMovieDao.getTopRatedMovies());
  }
}
