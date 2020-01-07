import 'package:dartz/dartz.dart';
import 'package:torrent_media/core/error/failures.dart';
import 'package:torrent_media/features/movies/domain/entities/movie.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> get();
}