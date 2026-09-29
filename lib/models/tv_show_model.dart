class TvShow {
  final String name;
  final String? posterPath;
  final String overView;
  final double voteAverage;
  final String firstAirDate;

  new({
    required this.name,
    this.posterPath,
    required this.overView,
    required this.voteAverage,
    required this.firstAirDate,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      name: json["name"] ?? "",
      posterPath: json["poster_path"] as String?,
      overView: json["overview"],
      voteAverage: (json["vote_average"] ?? 0).toDouble(),
      firstAirDate: json["first_air_date"] ?? "",
    );
  }
}
