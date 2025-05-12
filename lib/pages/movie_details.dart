import 'package:flutter/material.dart';
import 'package:movies/modules/movie_provider.dart';
import 'package:movies/modules/movies.dart';
import 'package:provider/provider.dart';

class MovieDetail extends StatelessWidget {
  const MovieDetail({super.key});

  @override
  Widget build(BuildContext context) {
    Movie movie = Provider.of<MovieProvider>(context).movie;

    return Scaffold(
      appBar: AppBar(title: const Text("Movie Details")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 200,
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: Image.network(
                  "https://image.tmdb.org/t/p/w500/${movie.posterPath}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(movie.title ?? "", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text(
              "${movie.releaseDate ?? ""} / ${movie.voteAverage ?? 0}",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(movie.overview ?? "", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}
