import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class NavigatorBloc extends Bloc<NavigatorEvent, dynamic> {
  final GlobalKey<NavigatorState> navigatorKey;

  NavigatorBloc({this.navigatorKey});

  @override
  dynamic get initialState => 0;

  @override
  Stream<dynamic> mapEventToState(NavigatorEvent event) async* {
    if (event is Pop) {
      navigatorKey.currentState.pop();
    } else if (event is Push) {
      navigatorKey.currentState.pushNamed(event.routeName);
    } else if (event is PushAndRemoveAll) {
      navigatorKey.currentState
          .pushNamedAndRemoveUntil(event.routeName, (_) => false);
    }
  }
}

abstract class NavigatorEvent {
  const NavigatorEvent();
}

class Pop extends NavigatorEvent {}

class Push extends NavigatorEvent {
  final String routeName;

  const Push(this.routeName);
}

class PushAndRemoveAll extends NavigatorEvent {
  final String routeName;

  const PushAndRemoveAll(this.routeName);
}
