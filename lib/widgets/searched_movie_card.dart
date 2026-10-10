import 'package:flutter/material.dart';
import 'package:movie_wave/models/movie_model.dart';

class SearchedMovieCard extends StatelessWidget {
  final Movie movie;
  const SearchedMovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        movie.posterPath == null
            ? const SizedBox()
            : ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  "https://image.tmdb.org/t/p/w500/${movie.posterPath}",
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
        const SizedBox(height: 10),
        Text(
          movie.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          "Release Date: ${movie.releaseDate}",
          style: TextStyle(
            color: Colors.red[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Overview",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 5),
        Text(
          movie.overView,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Average vote: ${movie.voteAverage.toString()}",
              style: TextStyle(fontSize: 14, color: Colors.red[600]),
            ),
            Text(
              "Popularity: ${movie.popularity.toString()}",
              style: TextStyle(fontSize: 14, color: Colors.red[600]),
            ),
          ],
        ),
        const Divider(thickness: 2),
        const SizedBox(height: 15),
      ],
    );
  }
}
