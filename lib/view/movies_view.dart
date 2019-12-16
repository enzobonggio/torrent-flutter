import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torrent_media/common/data_bloc.dart';
import 'package:torrent_media/model/movie.dart';
import 'package:torrent_media/repository/movie_repository.dart';
import 'package:torrent_media/widget/movie_item.dart';

class MoviesView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MoviesViewState();
  }
}

class _MoviesViewState extends State<MoviesView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MovieBloc>(context)..add(FetchData());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: BlocBuilder<MovieBloc, DataState>(
          builder: (BuildContext context, DataState state) {
        if (state is DataFetched<Iterable<Movie>>) {
          final list = state.data.toList();
          return GridView.builder(
            cacheExtent: 300,
              itemCount: list.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.6,
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemBuilder: (BuildContext context, int index) => MovieItem(
                    movie: list[index],
                    index: index,
                  ));
        }
        return Center(child: CircularProgressIndicator());
      }),
    );
  }
}

class MovieBloc extends DataBloc<Iterable<Movie>> {
  MovieRepository _movieRepository = MovieRepositoryImpl();

  @override
  Future<Iterable<Movie>> fetch() async {
    return _movieRepository.get();
  }

  @override
  Stream<DataState<Iterable<Movie>>> mapDataEventToState(
      DataEvent event) async* {}

  @override
  Stream<DataState<Iterable<Movie>>> mapErrorEventToState(
      Object error) async* {}
}
