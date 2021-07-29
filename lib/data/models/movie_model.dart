import 'package:movie_app/data/vos/actor_vo.dart';
import 'package:movie_app/data/vos/credit_vo.dart';
import 'package:movie_app/data/vos/genre_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:scoped_model/scoped_model.dart';

abstract class MovieModel extends Model{
  // Network
  void getNowPlayingMovies(int page);
  void getTopRatedMovies(int page);
  void getPopularMovies(int page);
  Future<List<GenreVO>> getGenres();
  Future<List<MovieVO>> getMoviesByGenre(int genreId);
  Future<List<ActorVO>> getActors(int page);
  Future<MovieVO> getMovieDetails(int movieId);
  Future<List<CreditVO>> getCreditsByMovie(int movieId);

  // Database
  Stream<List<MovieVO>> getNowPlayingMoviesFromDatabase();
  Stream<List<MovieVO>> getTopRatedMoviesFromDatabase();
  Stream<List<MovieVO>> getPopularMoviesFromDatabase();
  Future<List<GenreVO>> getGenresFromDatabase();
  Future<List<ActorVO>> getAllActorsFromDatabase();
  Future<MovieVO> getMovieDetailFromDatabase(int movieId);
}