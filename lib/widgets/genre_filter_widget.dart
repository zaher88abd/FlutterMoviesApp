import 'package:flutter/material.dart';
import 'package:movies/modules/genres.dart';
import 'package:movies/repositories/movie_repository.dart';

class GenreFilterWidget extends StatefulWidget {
  late void Function(Set<int> selected) onCategorySelected;
  GenreFilterWidget({super.key, required this.onCategorySelected});

  @override
  State<GenreFilterWidget> createState() => _GenreFilterWidgetState();
}

class _GenreFilterWidgetState extends State<GenreFilterWidget> {
  late Set<int> selectedCategories;
  late Set<Genre> allGenrs;
  final MoviesRepository _moviesRepository = MoviesRepository();
  @override
  void initState() {
    super.initState();
    selectedCategories = <int>{};
    allGenrs = <Genre>{};
    _moviesRepository.fetchGenres().then((genrs) {
      setState(() {
        allGenrs.addAll(genrs);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8),
        Text(
          'Movies Genre',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
          textAlign: TextAlign.start,
          maxLines: 1,
        ),
        SizedBox(height: 2),
        Wrap(
          spacing: 4,
          children:
              allGenrs.map((Genre genre) {
                return FilterChip(
                  label: Text(genre.name),
                  selected: selectedCategories.contains(genre.id),
                  onSelected: (bool selected) {
                    selected
                        ? selectedCategories.add(genre.id)
                        : selectedCategories.remove(genre.id);
                    widget.onCategorySelected(selectedCategories);
                  },
                );
              }).toList(),
        ),
      ],
    );
  }
}
