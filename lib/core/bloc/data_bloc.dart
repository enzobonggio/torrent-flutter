import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:torrent_media/core/error/failures.dart';

abstract class DataBloc<T> extends Bloc<DataEvent, DataState<T>> {
  final Duration tick;
  final bool repeat;

  Timer timer;

  DataBloc({this.tick, this.repeat = false});

  @override
  DataState<T> get initialState => DataUninitialized();

  Future<void> pullToRefresh() async {
    final completer = Completer<void>();
    this.add(PullToRefresh(completer));
    return completer.future;
  }

  @override
  Stream<DataState<T>> mapEventToState(DataEvent event) async* {
    if (event is FetchData) {
      if (!(state is DataFetched)) yield DataLoading<T>();
      if (repeat && timer == null) {
        timer = Timer.periodic(tick, (_) => this.add(FetchData()));
      } else {
        final either = await fetch();
        yield* either.fold((failure) async* {
          yield* mapErrorEventToState(failure);
        }, (data) async* {
          yield DataFetched<T>(data);
        });
      }
    } else if (event is PullToRefresh) {
      final either = await fetch();
      either.fold((failure) async* {
        yield* mapErrorEventToState(failure);
      }, (data) async* {
        yield DataFetched<T>(data);
      });
    } else {
      yield* mapDataEventToState(event);
    }
  }

  Stream<DataState<T>> mapDataEventToState(DataEvent event);

  Stream<DataState<T>> mapErrorEventToState(Object error);

  Future<Either<Failure, T>> fetch();

  void stopPolling() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
  }
}

abstract class DataEvent {}

class FetchData extends DataEvent {}

class PullToRefresh extends DataEvent {
  final Completer<void> completer;

  PullToRefresh(this.completer);
}

abstract class DataState<T> {}

class DataUninitialized<T> extends DataState<T> {}

class DataLoading<T> extends DataState<T> {}

class DataFailed<T> extends DataState<T> {
  final Object cause;
  final String errorMessage;

  DataFailed({this.cause, this.errorMessage});
}

class DataFetched<T> extends DataState<T> {
  final T data;

  DataFetched(this.data);
}
