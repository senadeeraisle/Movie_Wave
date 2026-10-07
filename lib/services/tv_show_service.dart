import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_wave/models/tv_show_model.dart';

class TvShowService {
  final String _baseUrl = "https://api.themoviedb.org/3/tv";
  final String _apiKey = dotenv.env["MOVIE_API"] ?? "";

  //method to get popular tv show

  Future<List<TvShow>> getPopulerTvShow({int page = 1}) async {
    try {
      final String url = "$_baseUrl/popular?api_key=$_apiKey&page=$page";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> result = data["results"];
        return result.map((tvShow) => TvShow.fromJson(tvShow)).toList();
      } else {
        throw Exception("Error on loading tv shows");
      }
    } catch (error) {
      print("Error loading tv show $error");
      throw Exception("Error loading tv show");
    }
  }

  //method to get tv shows
  Future<List<TvShow>> getTVShows() async {
    try {
      final topRatedTvShowResponse = await http.get(
        Uri.parse("$_baseUrl/top_rated?api_key=$_apiKey"),
      );
      final airingTvShowResponse = await http.get(
        Uri.parse("$_baseUrl/airing_today?api_key=$_apiKey"),
      );
      final populerTvShowsResponse = await http.get(
        Uri.parse("$_baseUrl/popular?api_key=$_apiKey"),
      );
      if (populerTvShowsResponse.statusCode == 200 &&
          airingTvShowResponse.statusCode == 200 &&
          populerTvShowsResponse.statusCode == 200) {
        final topRatedTvShowData = json.decode(topRatedTvShowResponse.body);
        final airingTvShowData = json.decode(airingTvShowResponse.body);
        final populerTvShowsData = json.decode(populerTvShowsResponse.body);

        final List<dynamic> topRatedTvShowResult =
            topRatedTvShowData["results"];

        final List<dynamic> airingTvShowResult = airingTvShowData["results"];
        final List<dynamic> populerTvShowsResult =
            populerTvShowsData["results"];
        List<TvShow> allTvShows = [];

        allTvShows.addAll(
          topRatedTvShowResult
              .map((tvShow) => TvShow.fromJson(tvShow))
              .take(20),
        );
        allTvShows.addAll(
          airingTvShowResult.map((tvShow) => TvShow.fromJson(tvShow)).take(20),
        );
        allTvShows.addAll(
          populerTvShowsResult
              .map((tvShow) => TvShow.fromJson(tvShow))
              .take(20),
        );
        return allTvShows;
      } else {
        throw Exception("error on getting tv shows");
      }
    } catch (error) {
      print("error on getting tv shows $error");
      throw Exception("error on getting tv shows");
    }
  }
}
