import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torrent_media/navigator/navigator_bloc.dart';
import 'package:torrent_media/navigator/routes.dart';
import 'package:torrent_media/view/home_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final NavigatorBloc _navigator = NavigatorBloc(navigatorKey: _navigatorKey);

    return MultiBlocProvider(
      providers: <BlocProvider>[
        BlocProvider<TorrentBloc>(
            create: (BuildContext context) => TorrentBloc()),
        BlocProvider<MovieBloc>(create: (BuildContext context) => MovieBloc()),
      ],
      child: MaterialApp(
          title: 'Torrent Media',
          navigatorKey: _navigatorKey,
          onGenerateRoute: generateRoute,
          initialRoute: Routes.HOME,
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          )),
    );
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.HOME:
        return MaterialPageRoute(
            settings: RouteSettings(name: Routes.HOME),
            builder: (context) => HomeView());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
