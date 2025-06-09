import 'package:flutter/material.dart';
import 'package:movies/modules/movie_provider.dart';
import 'package:movies/modules/movies.dart';
import 'package:movies/pages/movie_details.dart';
import 'package:provider/provider.dart';

class MovieListItem extends StatelessWidget {
  final Movie movie;
  const MovieListItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    MovieProvider movieProvider = Provider.of<MovieProvider>(
      context,
      listen: false,
    );
    return InkWell(
      onTap: () {
        movieProvider.setMovie(movie);
        Navigator.of(context).push(_createRoute());
      },
      child: Card(
        color: movie.adult! ? Colors.red : Colors.white,
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

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder:
          (context, animation, secondaryAnimation) => const MovieDetail(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
