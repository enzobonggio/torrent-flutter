import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:torrent_media/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:torrent_media/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:torrent_media/features/movies/domain/repositories/movie_repository.dart';
import 'package:torrent_media/features/movies/domain/usecases/get_movies.dart';
import 'package:torrent_media/features/movies/presentation/bloc/movie_bloc.dart';
import 'package:torrent_media/features/torrents/data/repositories/torrent_repository_impl.dart';
import 'package:torrent_media/features/torrents/domain/repositories/torrent_repository.dart';
import 'package:torrent_media/features/torrents/domain/usecases/create_torrent.dart';
import 'package:torrent_media/features/torrents/domain/usecases/get_torrents.dart';
import 'package:torrent_media/features/torrents/presentation/bloc/torrent_bloc.dart';

import 'features/torrents/data/datasources/transmission_remote_data_source.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () => MovieBloc(movies: sl()),
  );
  sl.registerFactory(
    () => TorrentBloc(
      getTorrents: sl(),
      createTorrent: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetMovies(sl()));
  sl.registerLazySingleton(() => GetTorrents(sl()));
  sl.registerLazySingleton(() => CreateTorrent(sl()));

  // Repository
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<TorrentRepository>(
    () => TorrentRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<TransmissionRemoteDataSource>(
    () => TransmissionRemoteDataSourceImpl(client: sl()),
  );

  //! External
  sl.registerLazySingleton(() => http.Client());
}
