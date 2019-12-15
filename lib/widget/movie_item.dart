import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torrent_media/model/movie.dart';
import 'package:torrent_media/model/torrent.dart';
import 'package:torrent_media/view/home_view.dart';
import 'package:transparent_image/transparent_image.dart';

class MovieItem extends StatefulWidget {
  final tapped;
  final Movie movie;

  const MovieItem({Key key, this.tapped = false, this.movie}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MovieItemState();
  }
}

class _MovieItemState extends State<MovieItem> {
  TorrentBloc _torrentBloc;

  @override
  void initState() {
    super.initState();
    _torrentBloc = BlocProvider.of<TorrentBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Column(children: <Widget>[
      Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 5),
              borderRadius: BorderRadius.circular(5)),
          child: (widget.tapped
              ? Stack(alignment: Alignment.center, children: <Widget>[
                  Image.network(widget.movie.image,
                      height: 240,
                      width: 170,
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                      colorBlendMode: BlendMode.modulate),
                  Column(
                      children: widget.movie.torrents
                          .map((torrent) => MaterialButton(
                                onPressed: () => _torrentBloc.add(CreateTorrent(
                                    TorrentRequest(url: torrent.url))),
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
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ]),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                              ))
                          .toList())
                ])
              : FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: widget.movie.image,
                  height: 240,
                  width: 170))),
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
    ]);
  }
}
