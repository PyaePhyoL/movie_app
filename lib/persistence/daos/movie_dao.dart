import 'package:hive/hive.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/persistence/hive_constants.dart';

class MovieDao {
  static final MovieDao _singleton = MovieDao._internal();

  factory MovieDao() {
    return _singleton;
  }

  MovieDao._internal();

  void saveMovies(List<MovieVO> movieList) async {
    Map<int, MovieVO> movieMap = Map.fromIterable(
      movieList,
      key: (movie) => movie.id,
      value: (movie) => movie,
    );

    await getMovieBox().putAll(movieMap);
  }

  void saveSingleMovie(MovieVO movie) async {
    await getMovieBox().put(movie.id, movie);
  }

  List<MovieVO> getAllMovies() {
    return getMovieBox().values.toList();
  }

  MovieVO getMovieById(int movieId) {
    return getMovieBox().get(movieId);
  }

  Box<MovieVO> getMovieBox() {
    return Hive.box<MovieVO>(BOX_NAME_MOVIE_VO);
  }

  /// Reactive Programming
  Stream<void> getAllMoviesEventStream() {
    return getMovieBox().watch();
  }

  Stream<List<MovieVO>> getNowPlayingMoviesStream() {
    return Stream.value(
      getAllMovies().where((movie) => movie?.isNowPlaying ?? false).toList(),
    );
  }

  Stream<List<MovieVO>> getTopRatedMoviesStream() {
    return Stream.value(
      getAllMovies().where((movie) => movie?.isTopRated ?? false).toList(),
    );
  }

  Stream<List<MovieVO>> getPopularMoviesStream() {
    return Stream.value(
      getAllMovies().where((movie) => movie?.isPopular ?? false).toList(),
    );
  }

  List<MovieVO> getNowPlayingMovies() {
    if (this.getAllMovies() != null && this.getAllMovies().isNotEmpty ??
        false) {
      return getAllMovies()
          .where((movie) => movie.isNowPlaying ?? true)
          .toList();
    } else {
      return [];
    }
  }

  List<MovieVO> getTopRatedMovies() {
    if (this.getAllMovies() != null && this.getAllMovies().isNotEmpty ??
        false) {
      return getAllMovies().where((movie) => movie.isTopRated ?? true).toList();
    } else {
      return [];
    }
  }

  List<MovieVO> getPopularMovies() {
    if (this.getAllMovies() != null && this.getAllMovies().isNotEmpty ??
        false) {
      return getAllMovies().where((movie) => movie.isPopular ?? true).toList();
    } else {
      return [];
    }
  }
}
