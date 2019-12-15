import 'package:torrent_media/model/torrent.dart';

abstract class TorrentRepository {
  Future<Iterable<TorrentResponse>> get();

  Future create(TorrentRequest torrentRequest);
}
