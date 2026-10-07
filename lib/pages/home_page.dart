import 'package:flutter/material.dart';
import 'package:movie_wave/models/movie_model.dart';
import 'package:movie_wave/services/movie_service.dart';
import 'package:movie_wave/widgets/movie_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Movie> _movies = [];
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoading = false;

  //method to fetch movies

  Future<void> _fetchMovies() async {
    if (_isLoading || !_hasMore) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 1));
    try {
      final newMovies = await MovieService().getPopularMovies(
        page: _currentPage,
      );
      setState(() {
        if (newMovies.isEmpty) {
          _hasMore = false;
        } else {
          _movies.addAll(newMovies);
          _currentPage++;
        }
      });
    } catch (error) {
      print("Error fetching movies: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Page")),
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (!_isLoading &&
                notification.metrics.pixels ==
                    notification.metrics.maxScrollExtent) {
              _fetchMovies();
            }
            return true;
          },
          child: ListView.builder(
            itemCount: _movies.length + (_isLoading ? 1 : 0),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (index == _movies.length) {
                return Center(child: CircularProgressIndicator());
              }
              final movie = _movies[index];
              return MovieCard(movie: movie);
            },
          ),
        ),
      ),
    );
  }
}
