import 'dart:convert';

import 'package:movies/modules/movies.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

class MoviesRepository {
  final List<Movie> _movies = [];

  Future<List<Movie>> fetchMovies(int page) async {
    final url = Uri.parse(
      "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=$page&sort_by=popularity.desc",
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

  Future<List<Movie>> fetchMovieDetails(int id) async {
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
      return [movie];
    }
    return [];
  }
}
