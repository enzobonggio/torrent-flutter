import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torrent_media/features/movies/domain/entities/movie.dart';
import 'package:torrent_media/features/torrents/presentation/bloc/torrent_bloc.dart';
import 'package:transparent_image/transparent_image.dart';

class MovieItem extends StatefulWidget {
  final index;
  final Movie movie;

  const MovieItem({Key key, this.index, this.movie}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MovieItemState();
  }
}

class _MovieItemState extends State<MovieItem> {
  TorrentBloc _torrentBloc;
  SelectMovieBloc _selectMovieBloc;

  @override
  void initState() {
    super.initState();
    _torrentBloc = BlocProvider.of<TorrentBloc>(context);
    _selectMovieBloc = BlocProvider.of<SelectMovieBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectMovieBloc, int>(
        condition: (before, after) =>
            (before == widget.index && after != widget.index) ||
            (before != widget.index && after == widget.index),
        builder: (BuildContext context, int selectedIndex) => GestureDetector(
              onTap: () => _selectMovieBloc.add(widget.index),
              child: Column(children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 5),
                        borderRadius: BorderRadius.circular(5)),
                    child: (widget.index == selectedIndex
                        ? Stack(alignment: Alignment.center, children: <Widget>[
                            Image.network(widget.movie.image,
                                fit: BoxFit.fill,
                                color: Color.fromRGBO(255, 255, 255, 0.3),
                                colorBlendMode: BlendMode.modulate),
                            Column(
                                children: widget.movie.torrents
                                    .map((torrent) => MaterialButton(
                                          onPressed: () => _torrentBloc.add(
                                              CreateTorrentEvent(
                                                  url: torrent.url)),
                                          color: Color.fromARGB(66, 25, 25, 29),
                                          textColor: Colors.white,
                                          child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.file_download,
                                                  color: Colors.green,
                                                ),
                                                Text(
                                                  torrent.quality,
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                )
                                              ]),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                        ))
                                    .toList())
                          ])
                        : FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            fit: BoxFit.fill,
                            image: widget.movie.image))),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      widget.movie.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.6,
                          fontWeight: FontWeight.bold),
                    )),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      widget.movie.year.toString(),
                      style: TextStyle(color: Colors.grey),
                    ))
              ]),
            ));
  }
}

class SelectMovieBloc extends Bloc<int, int> {
  @override
  int get initialState => -1;

  @override
  Stream<int> mapEventToState(int event) async* {
    if (event == state)
      yield -1;
    else
      yield event;
  }
}
