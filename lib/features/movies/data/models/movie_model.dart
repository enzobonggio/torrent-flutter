import 'package:torrent_media/features/movies/domain/entities/movie.dart';
import 'package:torrent_media/features/movies/domain/entities/movie_torrent.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel extends Movie {
  final String title;
  final int year;
  final String image;
  final List<MovieTorrentModel> torrents;

  MovieModel({
    this.title,
    this.year,
    this.image,
    this.torrents,
  }) : super(title: title, year: year, image: image, torrents: torrents);

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);
}

@JsonSerializable()
class MovieTorrentModel extends MovieTorrent {
  final String url;
  final String quality;

  MovieTorrentModel({
    this.url,
    this.quality,
  }) : super(url: url, quality: quality);

  factory MovieTorrentModel.fromJson(Map<String, dynamic> json) =>
      _$MovieTorrentModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieTorrentModelToJson(this);
}
