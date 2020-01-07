import 'package:dartz/dartz.dart';
import 'package:torrent_media/core/error/failures.dart';
import 'package:torrent_media/core/usecases/usecases.dart';
import 'package:torrent_media/features/torrents/domain/entities/torrent.dart';
import 'package:torrent_media/features/torrents/domain/repositories/torrent_repository.dart';

class GetTorrents extends UseCase<Iterable<Torrent>, NoParams> {
  final TorrentRepository repository;

  GetTorrents(this.repository);

  @override
  Future<Either<Failure, Iterable<Torrent>>> call(NoParams params) {
    return repository.get();
  }
}
