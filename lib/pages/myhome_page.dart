import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movies/modules/movies.dart';
import 'package:movies/repositories/movie_repository.dart';
import 'package:movies/widgets/genre_filter_widget.dart';
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
  final MoviesRepository _moviesRepository = MoviesRepository();

  final ScrollController _scrollController = ScrollController();
  final StreamController<List<Movie>> _streamController =
      StreamController<List<Movie>>();

  final Set<int> _selectedCategories = <int>{};

  @override
  void initState() {
    super.initState();
    _fetchPopularMovies();
    _scrollController.addListener(loadNextPage);
  }

  Future<void> _fetchPopularMovies() async {
    try {
      print("Fetching movies for page: $currentPage");
      _moviesRepository.fetchMovies(currentPage).then((movie) {
        _streamController.add(movie);
      });
      currentPage++;
    } catch (e) {
      _streamController.addError('Failed to load movies: $e');
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
                GenreFilterWidget(
                  onCategorySelected: (Set<int> selectedSet) {
                    setState(() {
                      _selectedCategories.clear();
                      _selectedCategories.addAll(selectedSet);
                    });
                  },
                ),
                SizedBox(height: 8),
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
