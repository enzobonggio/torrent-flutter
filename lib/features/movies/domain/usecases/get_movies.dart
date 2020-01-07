import 'package:dartz/dartz.dart';
import 'package:torrent_media/core/error/failures.dart';
import 'package:torrent_media/core/usecases/usecases.dart';
import 'package:torrent_media/features/movies/domain/entities/movie.dart';
import 'package:torrent_media/features/movies/domain/repositories/movie_repository.dart';
import 'package:meta/meta.dart';

class GetMovies implements UseCase<List<Movie>, NoParams> {
  final MovieRepository repository;

  GetMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(NoParams params) async {
    return repository.get();
  }

}