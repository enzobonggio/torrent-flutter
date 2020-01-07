import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:torrent_media/core/bloc/data_bloc.dart';
import 'package:torrent_media/features/torrents/domain/entities/torrent.dart';
import 'package:torrent_media/features/torrents/presentation/bloc/torrent_bloc.dart';

class TorrentsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TorrentsViewState();
  }
}

class _TorrentsViewState extends State<TorrentsView> {
  TorrentBloc _torrentBloc;

  @override
  void initState() {
    super.initState();
    _torrentBloc = BlocProvider.of<TorrentBloc>(context)..add(FetchData());
  }

  @override
  void dispose() {
    _torrentBloc.stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TorrentBloc>(context)..add(FetchData());
    return Container(
      margin: EdgeInsets.all(20),
      color: Colors.black,
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: BlocBuilder<TorrentBloc, DataState>(
                builder: (BuildContext context, DataState state) {
              if (state is DataFetched<Iterable<Torrent>>) {
                final list = state.data.toList();
                return GridView.builder(
                    itemCount: list.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 4, crossAxisCount: 1),
                    itemBuilder: (BuildContext context, int index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                list[index].name,
                                style: TextStyle(color: Colors.white),
                              ),
                              LinearPercentIndicator(
                                lineHeight: 30,
                                padding: EdgeInsets.all(0),
                                progressColor: Colors.green,
                                percent: list[index].percentage,
                              )
                            ]));
              }
              return Center(child: CircularProgressIndicator());
            }),
          )
        ],
      ),
    );
  }
}