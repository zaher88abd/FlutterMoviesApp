import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;
import 'package:movies/modules/movies.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPage = 1;
  bool isLoading = false;
  List<Results> movies = [];
  final ScrollController _scrollController = ScrollController();

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
      setState(() {
        isLoading = true;
      });
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
        setState(() {
          isLoading = false;
          if (movies.results != null) {
            this.movies.addAll(movies.results!);
          }
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Visibility(
            visible: isLoading,
            child: const LinearProgressIndicator(),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(
                    "https://image.tmdb.org/t/p/w500/${movies[index].posterPath}",
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(movies[index].title!),
                  subtitle: Text(movies[index].overview!),
                );
              },
              itemCount: movies.length,
            ),
          ),
        ],
      ),
      floatingActionButton:
          null, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void loadNextPage() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      currentPage++;
      _fetchPopularMovies();
    }
    return;
  }
}
