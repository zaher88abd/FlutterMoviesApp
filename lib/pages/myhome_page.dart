import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;
import 'package:movies/modules/movies.dart';
import 'package:movies/widgets/movie_list_item.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPage = 1;
  bool isLoading = false;
  List<Movie> movies = [];
  final ScrollController _scrollController = ScrollController();
  final StreamController<List<Movie>> _streamController =
      StreamController<List<Movie>>();

  @override
  void initState() {
    super.initState();
    _fetchPopularMovies();
    _scrollController.addListener(loadNextPage);
  }

  Future<void> _fetchPopularMovies() async {
    try {
      if (isLoading) {
        return;
      }
      isLoading = true;

      final url = Uri.parse(
        "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=$currentPage&sort_by=popularity.desc",
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
        isLoading = false;
        if (movies.results != null) {
          this.movies.addAll(movies.results!);
          _streamController.add(this.movies);
          currentPage++;
        }
      }
    } catch (e) {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: StreamBuilder<List<Movie>>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text("No movies found"));
          } else {
            final movies = snapshot.data ?? [];
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: index == 0 ? 4 : 0,
                          bottom: index == movies.length - 1 ? 4 : 0,
                        ),
                        child: MovieListItem(movie: movies[index]),
                      );
                    },
                    itemCount: movies.length,
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton:
          null, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void loadNextPage() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      _fetchPopularMovies();
    }
  }
}
