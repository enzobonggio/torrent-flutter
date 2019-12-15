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

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TorrentBloc>(context)
      ..add(FetchData());
    final _movieBloc = BlocProvider.of<MovieBloc>(context)..add(FetchData());

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
                  child: BlocBuilder<MovieBloc, DataState>(
                    builder: (BuildContext context, DataState state) {
                      if (state is DataFetched<MovieResponse>) {
                        final list = state.data.movies.toList();
                        return GridView.builder(
                            itemCount: list.length,
                            gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.7, crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int index) =>
                                InkWell(
                                  onTap: () =>
                                      _movieBloc.add(SelectMovie(index)),
                                  child: MovieItem(
                                    movie: list[index],
                                    tapped: index == state.data.selected,
                                  ),
                                ));
                      }
                      return Container();
                    },
                  ),
                ),
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
                          itemBuilder: (BuildContext context, int index) {
                            return Column(children: <Widget>[
                              Text(list[index].name),
                              LinearPercentIndicator(
                                percent: list[index].percentage,
                              )
                            ]);
                          });
                    }
                    return Container();
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

class MovieBloc extends DataBloc<MovieResponse> {
  MovieRepository _movieRepository = MovieRepositoryImpl();

  @override
  Future<MovieResponse> fetch() async {
    return MovieResponse(await _movieRepository.get());
  }

  @override
  Stream<DataState<MovieResponse>> mapDataEventToState(DataEvent event) async* {
    if (event is SelectMovie && state is DataFetched<MovieResponse>) {
      final dataFetched = (state as DataFetched<MovieResponse>);
      if (dataFetched.data.selected == event.index) {
        yield DataFetched(MovieResponse(
            (state as DataFetched<MovieResponse>).data.movies,
            selected: -1));
      } else {
        yield DataFetched(MovieResponse(
            (state as DataFetched<MovieResponse>).data.movies,
            selected: event.index));
      }
    }
  }

  @override
  Stream<DataState<MovieResponse>> mapErrorEventToState(Object error) {
    // TODO: implement mapErrorEventToState
    return null;
  }
}

class SelectMovie extends DataEvent {
  final int index;

  SelectMovie(this.index);
}

class MovieResponse {
  final Iterable<Movie> movies;
  final int selected;

  MovieResponse(this.movies, {this.selected = -1});
}
