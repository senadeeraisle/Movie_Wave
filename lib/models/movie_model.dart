class Movie {
  final bool isAdult;
  final String? backdropPath;
  final List<int> genreID;
  final int id;
  final String title;
  final String originalLanguage;
  final String overView;
  final double popularity;
  final String? posterPath;
  final String releaseDate;
  final bool video;
  final double voteAverage;
  final double voteCount;

  new({
    required this.isAdult,
    this.backdropPath,
    required this.genreID,
    required this.id,
    required this.title,
    required this.originalLanguage,
    required this.overView,
    required this.popularity,
    this.posterPath,
    required this.releaseDate,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      isAdult: json["adult"] ?? false,
      backdropPath: json["backdrop_path"] as String?,
      genreID: List<int>.from(json["genre_ids"] ?? []),
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      originalLanguage: json["original_language"] ?? "",
      overView: json["overview"] ?? "",
      popularity: (json["popularity"] ?? 0).toDouble(),
      posterPath: json["poster_path"] ?? "",
      releaseDate: json["release_date"] ?? "",
      video: json["video"] ?? false,
      voteAverage: (json["vote_average"] ?? 0).toDouble(),
      voteCount: json["2883"] ?? 0,
    );
  }
}
