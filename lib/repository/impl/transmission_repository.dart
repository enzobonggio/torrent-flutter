import 'dart:convert';

import 'package:torrent_media/model/torrent.dart';
import 'package:torrent_media/repository/torrent_repository.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'transmission_repository.g.dart';

class TransmissionRepository extends TorrentRepository {
  String sessionId;

  @override
  Future<TorrentResponse> create(TorrentRequest torrentRequest) {
    final arguments = {"filename": torrentRequest.url};
    return genericCall(
        transmissionRequest: TransmissionRequest(arguments, "torrent-add", 2),
        mapper: (args) {
          if (args.containsKey('torrent-duplicate')) {
            return TransmissionTorrent.fromJson(args['torrent-duplicate']);
          } else if (args.containsKey('torrent-added')) {
            return TransmissionTorrent.fromJson(args['torrent-added']);
          } else {
            throw Exception("");
          }
        });
  }

  @override
  Future<Iterable<TorrentResponse>> get() {
    final arguments = {
      "fields": ["name", "files"]
    };
    return genericCall(
        transmissionRequest: TransmissionRequest(arguments, "torrent-get", 1),
        mapper: (args) {
          List torrents = args['torrents'] as List;
          return torrents
              .map((torrent) => TransmissionTorrent.fromJson(torrent));
        });
  }

  Future<T> genericCall<T>(
      {TransmissionRequest transmissionRequest,
      T mapper(Map<String, dynamic> body),
      int retries = 0}) async {
    final response = await http.post("http://localhost:9091/transmission/rpc",
        headers: {"X-Transmission-Session-Id": sessionId},
        body: json.encode(transmissionRequest));

    if (response.statusCode == 409 && retries < 5) {
      sessionId = response.headers['x-transmission-session-id'];
      return genericCall(
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
        throw Exception("Error on generic call ${response.statusCode}");
    }
  }
}

@JsonSerializable()
class TransmissionRequest {
  final Map<String, dynamic> arguments;
  final String method;
  final int tag;

  TransmissionRequest(this.arguments, this.method, this.tag);

  factory TransmissionRequest.fromJson(Map<String, dynamic> json) =>
      _$TransmissionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TransmissionRequestToJson(this);
}

@JsonSerializable()
class TransmissionResponse {
  final Map<String, dynamic> arguments;
  final String result;
  final int tag;

  TransmissionResponse({this.arguments, this.result, this.tag});

  factory TransmissionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransmissionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransmissionResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TransmissionTorrent extends TorrentResponse {
  final String name;
  final List<TransmissionFile> files;

  TransmissionTorrent({this.name, this.files});

  @override
  double get percentage {
    final file = files.reduce((e1, e2) => TransmissionFile(
        length: e1.length + e2.length,
        bytesCompleted: e1.bytesCompleted + e2.bytesCompleted));
    return file.bytesCompleted / file.length;
  }

  factory TransmissionTorrent.fromJson(Map<String, dynamic> json) =>
      _$TransmissionTorrentFromJson(json);

  Map<String, dynamic> toJson() => _$TransmissionTorrentToJson(this);
}

@JsonSerializable()
class TransmissionFile {
  final int bytesCompleted;
  final int length;
  final String name;

  TransmissionFile({this.bytesCompleted, this.length, this.name = ''});

  factory TransmissionFile.fromJson(Map<String, dynamic> json) =>
      _$TransmissionFileFromJson(json);

  Map<String, dynamic> toJson() => _$TransmissionFileToJson(this);
}
