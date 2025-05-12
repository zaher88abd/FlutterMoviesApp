import 'package:flutter/material.dart';
import 'package:movies/modules/movie_provider.dart';
import 'package:movies/modules/movies.dart';
import 'package:provider/provider.dart';

class MovieListItem extends StatelessWidget {
  final Movie movie;
  const MovieListItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    MovieProvider movieProvider =
        Provider.of<MovieProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        movieProvider.setMovie(movie);
        Navigator.pushNamed(context, "/movie", arguments: movie);
      },
      child: Card(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 75,
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: Image.network(
                  "https://image.tmdb.org/t/p/w500/${movie.posterPath}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title!,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(movie.overview!, maxLines: 5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
