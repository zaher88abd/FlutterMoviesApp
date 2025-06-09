import 'dart:convert';

import 'package:movies/modules/genres.dart';
import 'package:movies/modules/movies.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

class MoviesRepository {
  final List<Movie> _movies = [];

  Future<List<Movie>> fetchMovies(int page) async {
    final url = Uri.parse(
      "https://api.themoviedb.org/3/discover/movie?include_adult=false&language=en-US&page=$page&sort_by=popularity.desc",
    );
    final responce = await http.get(
      url,
      headers: {
        'Authorization': "Bearer ${dotenv.env['MOVIES_API_KEY']}",
        'accept': 'application/json',
      },
    );
    if (responce.statusCode == 200) {
      // Handle successful response
      final movies = Movies.fromJson(responce.body);
      if (movies.results != null) {
        _movies.addAll(movies.results!);
      }
    }
    return _movies;
  }

  Future<Movie?> fetchMovieDetails(int id) async {
    final url = Uri.parse(
      "https://api.themoviedb.org/3/movie/$id?language=en-US",
    );
    final responce = await http.get(
      url,
      headers: {
        'Authorization': "Bearer ${dotenv.env['MOVIES_API_KEY']}",
        'accept': 'application/json',
      },
    );
    if (responce.statusCode == 200) {
      // Handle successful response
      final movie = Movie.fromJson(jsonDecode(responce.body));
      return movie;
    }
    return null;
  }

  Future<List<Genre>> fetchGenres() async {
    final url = Uri.parse(
      "https://api.themoviedb.org/3/genre/movie/list?language=en-US&include_adult=false",
    );
    final responce = await http.get(
      url,
      headers: {
        'Authorization': "Bearer ${dotenv.env['MOVIES_API_KEY']}",
        'accept': 'application/json',
      },
    );
    if (responce.statusCode == 200) {
      // Handle successful response
      final genresJson = jsonDecode(responce.body);
      final Genres genresList = Genres.fromJson(genresJson);
      return genresList.genres;
    }
    return [];
  }
}
