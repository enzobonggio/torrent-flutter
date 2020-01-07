import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:torrent_media/core/error/exceptions.dart';
import 'package:torrent_media/core/error/failures.dart';
import 'package:torrent_media/features/torrents/data/datasources/transmission_remote_data_source.dart';
import 'package:torrent_media/features/torrents/data/models/torrent_model.dart';
import 'package:torrent_media/features/torrents/domain/entities/torrent.dart';
import 'package:torrent_media/features/torrents/domain/repositories/torrent_repository.dart';

class TorrentRepositoryImpl implements TorrentRepository {
  final TransmissionRemoteDataSource remoteDataSource;

  TorrentRepositoryImpl({@required this.remoteDataSource});

  @override
  Future<Either<Failure, Iterable<Torrent>>> get() async {
    try {
      final result = await remoteDataSource.get();
      return Right(result
          .map((t) => TorrentModel(name: t.name, percentage: t.percentage)));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> create(String url) async {
    try {
      final result = await remoteDataSource.create(url);
      return Right(
          result.map((t) => Torrent(name: t.name, percentage: t.percentage)));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
