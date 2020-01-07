import 'package:dartz/dartz.dart';
import 'package:torrent_media/core/error/failures.dart';
import 'package:torrent_media/core/usecases/usecases.dart';
import 'package:torrent_media/features/torrents/domain/entities/torrent.dart';
import 'package:torrent_media/features/torrents/domain/repositories/torrent_repository.dart';

class CreateTorrent extends UseCase<void, Params> {
  final TorrentRepository repository;

  CreateTorrent(this.repository);

  @override
  Future<Either<Failure, void>> call(Params params) {
    return repository.create(params.url);
  }
}

class Params {
  final String url;

  Params({this.url});
}
