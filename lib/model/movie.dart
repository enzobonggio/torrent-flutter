import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie {
  Movie({this.title, this.year, this.image, this.torrents});

  final String title;
  final int year;
  final String image;
  final List<MovieTorrent> torrents;

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
}

@JsonSerializable()
class MovieTorrent {
  MovieTorrent({this.url, this.quality});

  final String url;
  final String quality;

  factory MovieTorrent.fromJson(Map<String, dynamic> json) =>
      _$MovieTorrentFromJson(json);
}
