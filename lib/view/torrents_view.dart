import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:torrent_media/common/data_bloc.dart';
import 'package:torrent_media/model/movie.dart';
import 'package:torrent_media/model/torrent.dart';
import 'package:torrent_media/repository/impl/transmission_repository.dart';
import 'package:torrent_media/repository/movie_repository.dart';
import 'package:torrent_media/repository/torrent_repository.dart';
import 'package:torrent_media/widget/movie_item.dart';

class TorrentsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TorrentsViewState();
  }
}

class _TorrentsViewState extends State<TorrentsView> {
  TorrentBloc _torrentBloc;

  @override
  void initState() {
    super.initState();
    _torrentBloc = BlocProvider.of<TorrentBloc>(context)..add(FetchData());
  }

  @override
  void dispose() {
    _torrentBloc.stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TorrentBloc>(context)..add(FetchData());
    return Container(
      color: Colors.grey,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey,
          body: Container(
            child: Column(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: BlocBuilder<TorrentBloc, DataState>(
                      builder: (BuildContext context, DataState state) {
                    if (state is DataFetched<Iterable<TorrentResponse>>) {
                      final list = state.data.toList();
                      return GridView.builder(
                          itemCount: list.length,
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 6, crossAxisCount: 1),
                          itemBuilder: (BuildContext context, int index) =>
                              Column(children: <Widget>[
                                Text(list[index].name),
                                LinearPercentIndicator(
                                  percent: list[index].percentage,
                                )
                              ]));
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TorrentBloc extends DataBloc<Iterable<TorrentResponse>> {
  TorrentBloc() : super(repeat: true, tick: Duration(seconds: 3));

  TorrentRepository _torrentRepository = TransmissionRepository();

  @override
  Future<Iterable<TorrentResponse>> fetch() async {
    return _torrentRepository.get();
  }

  @override
  Stream<DataState<Iterable<TorrentResponse>>> mapDataEventToState(
      DataEvent event) async* {
    if (event is CreateTorrent) {
      yield DataLoading();
      try {
        await _torrentRepository.create(event.torrentRequest);
        yield TorrentCreated();
      } catch (ex) {
        yield DataFailed(cause: ex, errorMessage: "Fail creating torrent");
      }
    }
  }

  @override
  Stream<DataState<Iterable<TorrentResponse>>> mapErrorEventToState(
      Object error) async* {
    yield DataFailed(cause: error, errorMessage: "Fail fetching torrents");
  }
}

class CreateTorrent extends DataEvent {
  final TorrentRequest torrentRequest;

  CreateTorrent(this.torrentRequest);
}

class TorrentCreated<T> extends DataState<T> {}
