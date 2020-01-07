import 'package:json_annotation/json_annotation.dart';

part 'transmission_model.g.dart';

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

@JsonSerializable()
class TransmissionTorrent {
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
