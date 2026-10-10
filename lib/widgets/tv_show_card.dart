import 'package:flutter/material.dart';
import 'package:movie_wave/models/tv_show_model.dart';

class TvShowCard extends StatelessWidget {
  final TvShow tvShow;
  const TvShowCard({super.key, required this.tvShow});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blueGrey.shade900),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  "https://image.tmdb.org/t/p/w500/${tvShow.posterPath}",
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                tvShow.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                "Overview",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 5),
              Text(
                tvShow.overView,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
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
                    "Average vote: ${tvShow.voteAverage.toString()}",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  Text(
                    "Popularity: tvShow.firstAirDate",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
