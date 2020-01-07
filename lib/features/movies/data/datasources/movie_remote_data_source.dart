import 'dart:convert';

import 'package:torrent_media/core/error/exceptions.dart';
import 'package:torrent_media/features/movies/data/models/movie_model.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> get();
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final http.Client client;

  MovieRemoteDataSourceImpl({@required this.client});

  @override
  Future<List<MovieModel>> get() async {
    final response = await client.get('http://Enzos-MBP:8080/movies');
    if (response.statusCode == 200) {
      final list = json.decode(response.body) as List;
      return list.map((i) => MovieModel.fromJson(i)).toList();
    } else {
      throw ServerException();
    }
  }
}
