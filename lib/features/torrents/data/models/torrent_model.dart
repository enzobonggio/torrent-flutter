import 'package:torrent_media/features/torrents/domain/entities/torrent.dart';

class TorrentModel extends Torrent {
  TorrentModel({
    String name,
    double percentage,
  }) : super(name: name, percentage: percentage);
}
