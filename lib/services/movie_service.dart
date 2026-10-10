import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_wave/models/movie_model.dart';

class MovieService {
  final String _baseUrl = "https://api.themoviedb.org/3/movie";
  final String _apiKey = dotenv.env["MOVIE_API"] ?? "";

  //method to fetch popular movies from api
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      final String url = "$_baseUrl/upcoming?api_key=$_apiKey&page=$page";
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

  //method to fetch now playing movies from api

  Future<List<Movie>> fetchNowPlayingMovies({int page = 1}) async {
    final String url = "$_baseUrl/now_playing?api_key=$_apiKey&page=$page";
    final response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> result = data["results"];

        return result.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception("error on fetching upcoming movies");
      }
    } catch (error) {
      print("error on fetching upcoming movies: $error");
      return [];
    }
  }

  //method to search movies

  Future<List<Movie>> searchMovie(String query) async {
    String url =
        "https://api.themoviedb.org/3/search/movie?query=$query&api_key=$_apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> result = data["results"];
        return result.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception("error on searching movie");
      }
    } catch (error) {
      print("Error on searching movies: $error");
      throw Exception("error on searching movie");
    }
  }

  //method to get similer movies

  Future<List<Movie>> getSimilerMovies({required int id}) async {
    String url = "$_baseUrl/$id/similar?api_key=$_apiKey";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> result = data["results"];
        return result.take(10).map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception("Error on loading similer movies");
      }
    } catch (error) {
      print("error on loading similer movies $error");
      throw Exception("Error on loading similer movies");
    }
  }

  // method to get recommended movies
  //recommendations
  Future<List<Movie>> getRecommendedMovies({required int id}) async {
    String url = "$_baseUrl/$id/recommendations?api_key=$_apiKey";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> result = data["results"];
        return result
            .take(10)
            .map((movieData) => Movie.fromJson(movieData))
            .toList();
      } else {
        throw Exception("error pn loading recommended movies");
      }
    } catch (error) {
      print("error pn loading recommended movies: $error");
      throw Exception("error pn loading recommended movies");
    }
  }

  //method to get images for relevent the movie
  Future<List<String>> getMovieImages({required int id}) async {
    String url = "$_baseUrl/$id/images?api_key=$_apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> backdrops = data["backdrops"];
        return backdrops
            .take(10)
            .map(
              (image) =>
                  "https://image.tmdb.org/t/p/w500/${image["file_path"]}",
            )
            .toList();
      } else {
        throw Exception("error on loading images");
      }
    } catch (error) {
      print("error on loading images: $error");
      throw Exception("error on loading images");
    }
  }
}
