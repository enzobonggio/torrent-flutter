export 'package:torrent_media/core/bloc/data_bloc.dart';

import 'package:dartz/dartz.dart';
import 'package:torrent_media/core/bloc/data_bloc.dart';
import 'package:torrent_media/core/error/failures.dart';
import 'package:torrent_media/core/usecases/usecases.dart';
import 'package:torrent_media/features/movies/domain/entities/movie.dart';
import 'package:torrent_media/features/movies/domain/usecases/get_movies.dart';
import 'package:meta/meta.dart';

class MovieBloc extends DataBloc<Iterable<Movie>> {
  final GetMovies movies;

  MovieBloc({@required this.movies});

  @override
  Future<Either<Failure, Iterable<Movie>>> fetch() async {
    return await movies(NoParams());
  }

  @override
  Stream<DataState<Iterable<Movie>>> mapDataEventToState(
      DataEvent event) async* {}

  @override
  Stream<DataState<Iterable<Movie>>> mapErrorEventToState(
      Object error) async* {}
}
