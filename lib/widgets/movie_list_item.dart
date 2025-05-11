import 'package:flutter/material.dart';
import 'package:movies/modules/movies.dart';

class MovieListItem extends StatelessWidget {
  final Movie movie;
  const MovieListItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle movie item tap
        // You can navigate to a details page or show a dialog with more information
        print("Movie tapped: ${movie.title}");
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
