import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:torrent_media/view/movies_view.dart';
import 'package:torrent_media/view/torrents_view.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> {
  int _selected = 0;

  static final List<Widget> _children = [MoviesView(), TorrentsView()];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
            backgroundColor: Colors.grey,
            body: _children[_selected],
            bottomNavigationBar: BottomAppBar(

              child: BottomNavigationBar(
                currentIndex: _selected,
                items: [
                  BottomNavigationBarItem(title: Text('movies') , icon: Icon(Icons.add)),
                  BottomNavigationBarItem(title: Text('torrents') ,icon: Icon(Icons.create))
                ],
                onTap: (index) => setState(() {
                  _selected = index;
                }),
              ),
            )),
      ),
    );
  }
}
