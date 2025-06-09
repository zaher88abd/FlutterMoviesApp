class Genres {
  List<Genre> genres = List.empty(growable: true);

  Genres();

  Genres.fromJson(Map<String, dynamic> json) {
    if (json['genres'] != null) {
      genres = <Genre>[];
      json['genres'].forEach((v) {
        genres.add(Genre.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['genres'] = genres.map((v) => v.toJson()).toList();
    return data;
  }
}

class Genre {
  late int id;
  late String name;

  Genre({required id, required name});

  Genre.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
