import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      color: Color(0x1d1d1d),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: SvgPicture.network(
                  'https://upload.wikimedia.org/wikipedia/commons/4/4e/Logo-YTS.svg',
                  fit: BoxFit.contain,
                  width: 89,
                  height: 28),
              backgroundColor: Color(0x1d1d1d),
            ),
            backgroundColor: Colors.black,
            body: _children[_selected],
            bottomNavigationBar: BottomAppBar(
              color: Color(0x1d1d1d),
              child: BottomNavigationBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                currentIndex: _selected,
                items: [
                  BottomNavigationBarItem(
                    title: Text(
                      'movies',
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: Icon(Icons.home, color: Colors.white),
                  ),
                  BottomNavigationBarItem(
                      title: Text(
                        'torrents',
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: Icon(Icons.format_list_bulleted, color: Colors.white,))
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
