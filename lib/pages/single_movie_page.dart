// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:movie_wave/models/movie_model.dart';
import 'package:movie_wave/services/movie_service.dart';

class SingleMoviePage extends StatefulWidget {
  Movie movie;
  SingleMoviePage({super.key, required this.movie});

  @override
  State<SingleMoviePage> createState() => _SingleMoviePageState();
}

class _SingleMoviePageState extends State<SingleMoviePage> {
  List<String> _movieImages = [];
  bool _isLoadingImage = true;
  String _imageLoadingError = "";

  List<Movie> _similerMovie = [];
  bool _isLoadingSimilerMovies = true;
  String _similerMovieError = "";

  List<Movie> _recommendedMovies = [];
  bool _isLoadingRecommendedMovies = true;
  String _recommendedMovieError = "";

  //method to fetch movie images
  Future<void> _fetchMovieImages() async {
    try {
      List<String> fetchImages = await MovieService().getMovieImages(
        id: widget.movie.id,
      );
      setState(() {
        _movieImages = fetchImages;
        _isLoadingImage = false;
      });
    } catch (error) {
      setState(() {
        _imageLoadingError = "error fetching images";
        _isLoadingImage = false;
      });
      print("error fetching images: $error");
    }
  }
  // method to fetch similer movies

  Future<void> _fetchSimilerMovies() async {
    try {
      List<Movie> similerMovies = await MovieService().getSimilerMovies(
        id: widget.movie.id,
      );
      setState(() {
        _similerMovie = similerMovies;
        _isLoadingSimilerMovies = false;
      });
    } catch (error) {
      setState(() {
        _similerMovieError = "Error on fetching similer movies";
        _isLoadingSimilerMovies = false;
      });
      print("Error on fetching similer movies: $error");
      throw Exception("Error on fetching similer movies");
    }
  }

  //method to fetch recommended movies

  Future<void> _fetchRecommendedMovies() async {
    try {
      final List<Movie> recommendedMovies = await MovieService()
          .getRecommendedMovies(id: widget.movie.id);

      setState(() {
        _recommendedMovies = recommendedMovies;
        _isLoadingRecommendedMovies = false;
      });
    } catch (error) {
      setState(() {
        _recommendedMovieError = "Error loading recommended movies";
      });
      print("Error loading recommended movies: $error");
      _isLoadingRecommendedMovies = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMovieImages();
    _fetchSimilerMovies();
    _fetchRecommendedMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                        "https://image.tmdb.org/t/p/w500/${widget.movie.posterPath}",
                        fit: BoxFit.cover,
                        height: 200,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.movie.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Release Date: ${widget.movie.releaseDate}",
                      style: TextStyle(
                        color: Colors.red[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Overview",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.movie.overView,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Average vote: ${widget.movie.voteAverage.toString()}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Popularity: ${widget.movie.popularity.toString()}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Move Images",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildImageCard(),
            SizedBox(height: 10),
            const Text(
              "Similer Movies",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            _buildMovieSection(
              _similerMovie,
              _isLoadingSimilerMovies,
              _similerMovieError,
            ),
            const SizedBox(height: 10),
            const Text(
              "Recommended Movies",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            _buildMovieSection(
              _recommendedMovies,
              _isLoadingRecommendedMovies,
              _recommendedMovieError,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard() {
    if (_isLoadingImage) {
      return const Center(child: CircularProgressIndicator());
    } else if (_movieImages.isEmpty) {
      return Center(child: Text(_imageLoadingError));
    } else {
      return SizedBox(
        height: 200,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: _movieImages.length,
          itemBuilder: (context, index) {
            return Container(
              height: 200,
              margin: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  _movieImages[index],
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      );
    }
  }

  Widget _buildMovieSection(List<Movie> movie, bool isLoading, String error) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : error.isNotEmpty
        ? Text(error)
        : movie.isEmpty
        ? Text("No Movies found")
        : SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movie.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.movie = movie[index];
                      _fetchMovieImages();
                      _fetchSimilerMovies();
                      _fetchRecommendedMovies();
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          if (movie[index].posterPath != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                "https://image.tmdb.org/t/p/w500/${movie[index].posterPath}",
                                fit: BoxFit.cover,
                                height: 150,
                              ),
                            ),
                          const SizedBox(height: 5),
                          Text(
                            movie[index].title,
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Vote: ${movie[index].voteAverage.toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }
}
