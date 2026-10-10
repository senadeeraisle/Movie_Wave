import 'package:flutter/material.dart';
import 'package:movie_wave/models/movie_model.dart';
import 'package:movie_wave/services/movie_service.dart';
import 'package:movie_wave/widgets/movie_card.dart';

class NowPlaying extends StatefulWidget {
  const new({super.key});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  @override
  void initState() {
    super.initState();
    _fetchNowPlayingMovies();
  }

  List<Movie> _nowplayingMovies = [];
  int _currentPage = 1;
  int _totalPages = 0;
  bool _isLoading = false;

  //method to fetch movies

  Future<void> _fetchNowPlayingMovies() async {
    try {
      setState(() {
        _isLoading = true;
      });
      List<Movie> fetchedMovies = await MovieService().fetchNowPlayingMovies(
        page: _currentPage,
      );
      setState(() {
        _nowplayingMovies = fetchedMovies;
        _totalPages = 100;
      });
    } catch (error) {
      print("error on fetching movies: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //method to go to prevoius page
  void goToPrevious() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _fetchNowPlayingMovies();
    }
  }

  //method to go to the next page
  void goToNextPage() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
      });
      _fetchNowPlayingMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Now Playing")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _nowplayingMovies.length + 1,
                    itemBuilder: (context, index) {
                      if (index > _nowplayingMovies.length - 1) {
                        return _buildPaginationController();
                      } else {
                        return MovieCard(movie: _nowplayingMovies[index]);
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }

  //pagination bar

  Widget _buildPaginationController() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _currentPage > 1 ? goToPrevious : null,
          child: const Text("Previous Page"),
        ),
        const SizedBox(width: 20),
        Text("$_currentPage of $_totalPages"),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: _currentPage < _totalPages ? goToNextPage : null,
          child: const Text("Next Page"),
        ),
      ],
    );
  }
}
