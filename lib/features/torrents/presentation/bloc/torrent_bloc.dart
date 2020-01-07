import 'package:dartz/dartz.dart';
import 'package:torrent_media/core/bloc/data_bloc.dart';
import 'package:torrent_media/core/error/failures.dart';
import 'package:torrent_media/core/usecases/usecases.dart';
import 'package:torrent_media/features/torrents/domain/entities/torrent.dart';
import 'package:torrent_media/features/torrents/domain/usecases/create_torrent.dart';
import 'package:torrent_media/features/torrents/domain/usecases/get_torrents.dart';

class TorrentBloc extends DataBloc<Iterable<Torrent>> {
  final GetTorrents getTorrents;
  final CreateTorrent createTorrent;

  TorrentBloc({this.getTorrents, this.createTorrent})
      : super(repeat: true, tick: Duration(seconds: 3));

  @override
  Future<Either<Failure, Iterable<Torrent>>> fetch() async {
    return getTorrents(NoParams());
  }

  @override
  Stream<DataState<Iterable<Torrent>>> mapDataEventToState(
      DataEvent event) async* {
    if (event is CreateTorrentEvent) {
      yield DataLoading();
      try {
        await createTorrent(Params(url: event.url));
        yield TorrentCreated();
      } catch (ex) {
        yield DataFailed(cause: ex, errorMessage: "Fail creating torrent");
      }
    }
  }

  @override
  Stream<DataState<Iterable<Torrent>>> mapErrorEventToState(
      Object error) async* {
    yield DataFailed(cause: error, errorMessage: "Fail fetching torrents");
  }
}

class CreateTorrentEvent extends DataEvent {
  final String url;

  CreateTorrentEvent({this.url});
}

class TorrentCreated<T> extends DataState<T> {}
