import 'package:flutter/material.dart';
import 'package:movie_wave/models/movie_model.dart';
import 'package:movie_wave/services/movie_service.dart';
import 'package:movie_wave/widgets/searched_movie_card.dart';

class SearchPage extends StatefulWidget {
  const new({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _movieController = TextEditingController();
  List<Movie> _searchedMovies = [];
  bool _isloading = false;
  String _error = '';

  //method to search movies
  Future<void> _searchMovies() async {
    setState(() {
      _isloading = true;
      _error = "";
    });

    try {
      final List<Movie> movies = await MovieService().searchMovie(
        _movieController.text,
      );

      setState(() {
        _searchedMovies = movies;
      });
    } catch (error) {
      setState(() {
        _error = "Error searching movie";
      });
      print(error.toString());
    } finally {
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _movieController,
                      onSubmitted: (_) {
                        _searchMovies();
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(width: 2),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.red[600],
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          _searchMovies();
                        },
                        icon: Icon(Icons.search, size: 30),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (_isloading)
                Center(child: CircularProgressIndicator())
              else if (_error.isNotEmpty)
                Text(_error, style: TextStyle(color: Colors.red, fontSize: 14))
              else if (_searchedMovies.isEmpty)
                Text("No movies found. Please search!")
              else
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _searchedMovies.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return SearchedMovieCard(movie: _searchedMovies[index]);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
