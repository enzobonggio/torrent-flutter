import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:torrent_media/core/error/exceptions.dart';
import 'package:torrent_media/features/torrents/data/models/transmission/transmission_model.dart';

abstract class TransmissionRemoteDataSource {
  Future<Iterable<TransmissionTorrent>> get();

  Future create(String url);
}

class TransmissionRemoteDataSourceImpl extends TransmissionRemoteDataSource {
  String sessionId;

  final http.Client client;

  TransmissionRemoteDataSourceImpl({this.client});

  @override
  Future<TransmissionTorrent> create(String url) {
    final arguments = {"filename": url};
    return _genericCall(
        transmissionRequest: TransmissionRequest(arguments, "torrent-add", 2),
        mapper: (args) {
          if (args.containsKey('torrent-duplicate')) {
            return TransmissionTorrent.fromJson(args['torrent-duplicate']);
          } else if (args.containsKey('torrent-added')) {
            return TransmissionTorrent.fromJson(args['torrent-added']);
          } else {
            throw ServerException();
          }
        });
  }

  @override
  Future<Iterable<TransmissionTorrent>> get() {
    final arguments = {
      "fields": ["name", "files"]
    };
    return _genericCall(
        transmissionRequest: TransmissionRequest(arguments, "torrent-get", 1),
        mapper: (args) {
          List torrents = args['torrents'] as List;
          return torrents
              .map((torrent) => TransmissionTorrent.fromJson(torrent));
        });
  }

  Future<T> _genericCall<T>(
      {TransmissionRequest transmissionRequest,
      T mapper(Map<String, dynamic> body),
      int retries = 0}) async {
    final response = await client.post(
        "http://Enzos-MBP:9091/transmission/rpc",
        headers: {"X-Transmission-Session-Id": sessionId},
        body: json.encode(transmissionRequest.toJson()));

    if (response.statusCode == 409 && retries < 5) {
      sessionId = response.headers['x-transmission-session-id'];
      return _genericCall(
          transmissionRequest: transmissionRequest,
          mapper: mapper,
          retries: retries + 1);
    }

    switch (response.statusCode) {
      case 200:
        final body = json.decode(response.body);
        final transmissionResponse = TransmissionResponse.fromJson(body);
        return mapper(transmissionResponse.arguments);
      default:
        throw ServerException(
            detail: "Error on generic call ${response.statusCode}");
    }
  }
}
