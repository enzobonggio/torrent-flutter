class TorrentRequest {
  final String url;
  final String path;

  TorrentRequest({this.url, this.path});
}

abstract class TorrentResponse {
  String get name;

  double get percentage;
}
