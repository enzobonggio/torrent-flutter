import 'package:dartz/dartz.dart';
import 'package:torrent_media/core/error/failures.dart';
import 'package:torrent_media/features/torrents/domain/entities/torrent.dart';

abstract class TorrentRepository {
  Future<Either<Failure, Iterable<Torrent>>> get();

  Future<Either<Failure, void>> create(String url) {}
}
