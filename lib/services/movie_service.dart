import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_wave/models/movie_model.dart';

class MovieService {
  final String _baseUrl = "https://api.themoviedb.org/3/movie/upcoming";
  final String _apiKey = dotenv.env["MOVIE_API"] ?? "";

  //method to fetch movies from api
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      final String url = "$_baseUrl?api_key=$_apiKey&page=$page";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> result = data["results"];

        return result.map((jsonMovie) => Movie.fromJson(jsonMovie)).toList();
      } else {
        throw Exception("Error fetching upcoming movies");
      }
    } catch (error) {
      print("error fetching upcoming movies: $error");
      return [];
    }
  }
}
