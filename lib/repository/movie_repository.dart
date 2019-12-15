import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:torrent_media/model/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> get();
}

class MovieRepositoryImpl extends MovieRepository {
  @override
  Future<List<Movie>> get() async {
    final response = await http.get('http://localhost:8080/movies');
    final list = json.decode(response.body) as List;
    return list.map((i) => Movie.fromJson(i)).toList();
  }
}
