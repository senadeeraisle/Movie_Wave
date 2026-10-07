import 'dart:convert';

import 'package:flutter/material.dart';
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
}
