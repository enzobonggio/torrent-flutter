import 'package:dartz/dartz.dart';
import 'package:torrent_media/core/error/exceptions.dart';
import 'package:torrent_media/core/error/failures.dart';
import 'package:torrent_media/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:torrent_media/features/movies/domain/entities/movie.dart';
import 'package:torrent_media/features/movies/domain/repositories/movie_repository.dart';
import 'package:meta/meta.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl({@required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Movie>>> get() async {
    try {
      return Right(await remoteDataSource.get());
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
