import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torrent_media/features/movies/domain/entities/movie.dart';
import 'package:torrent_media/features/movies/presentation/bloc/movie_bloc.dart';
import 'package:torrent_media/features/movies/presentation/widgets/movie_item.dart';

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
                  childAspectRatio: 0.5,
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
