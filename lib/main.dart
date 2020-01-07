import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:torrent_media/app_localizations.dart';
import 'package:torrent_media/core/navigator/navigator_bloc.dart';
import 'package:torrent_media/core/navigator/routes.dart';
import 'package:torrent_media/features/movies/presentation/bloc/movie_bloc.dart';
import 'package:torrent_media/features/movies/presentation/widgets/movie_item.dart';
import 'package:torrent_media/features/torrents/presentation/bloc/torrent_bloc.dart';
import 'package:torrent_media/injection_container.dart';
import 'package:torrent_media/view/home_view.dart';

import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

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
            create: (BuildContext context) => sl<TorrentBloc>()),
        BlocProvider<MovieBloc>(
            create: (BuildContext context) => sl<MovieBloc>()),
        BlocProvider<SelectMovieBloc>(
            create: (BuildContext context) => SelectMovieBloc()),
      ],
      child: MaterialApp(
          title: 'Torrent Media',
          supportedLocales: [Locale('es', 'AR'), Locale('en')],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportLocales) {
            if (locale == null) return supportLocales.first;
            for (final supportLocale in supportLocales) {
              if (supportLocale.languageCode == locale.languageCode &&
                  supportLocale.countryCode == locale.countryCode) {
                return supportLocale;
              }
              if (supportLocale.languageCode == locale.languageCode) {
                return supportLocale;
              }
            }
            return supportLocales.first;
          },
          navigatorKey: _navigatorKey,
          onGenerateRoute: generateRoute,
          initialRoute: Routes.HOME,
          darkTheme: ThemeData(
              // additional settings go here
              ),
          theme: ThemeData(
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
