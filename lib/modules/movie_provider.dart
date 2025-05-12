import 'package:flutter/foundation.dart';
import 'package:movies/modules/movies.dart';

class MovieProvider with ChangeNotifier, DiagnosticableTreeMixin {
  Movie movie = Movie();

  void setMovie(Movie movie) {
    this.movie = movie;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('movieTitle', movie.title ?? ""));
  }
}
