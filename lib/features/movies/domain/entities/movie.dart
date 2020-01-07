import 'package:torrent_media/features/movies/domain/entities/movie_torrent.dart';

class Movie {
  Movie({this.title, this.year, this.image, this.torrents});

  final String title;
  final int year;
  final String image;
  final List<MovieTorrent> torrents;
}