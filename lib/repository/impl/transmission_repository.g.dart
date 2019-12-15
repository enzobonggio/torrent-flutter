// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transmission_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransmissionRequest _$TransmissionRequestFromJson(Map<String, dynamic> json) {
  return TransmissionRequest(
    json['arguments'] as Map<String, dynamic>,
    json['method'] as String,
    json['tag'] as int,
  );
}

Map<String, dynamic> _$TransmissionRequestToJson(
        TransmissionRequest instance) =>
    <String, dynamic>{
      'arguments': instance.arguments,
      'method': instance.method,
      'tag': instance.tag,
    };

TransmissionResponse _$TransmissionResponseFromJson(Map<String, dynamic> json) {
  return TransmissionResponse(
    arguments: json['arguments'] as Map<String, dynamic>,
    result: json['result'] as String,
    tag: json['tag'] as int,
  );
}

Map<String, dynamic> _$TransmissionResponseToJson(
        TransmissionResponse instance) =>
    <String, dynamic>{
      'arguments': instance.arguments,
      'result': instance.result,
      'tag': instance.tag,
    };

TransmissionTorrent _$TransmissionTorrentFromJson(Map<String, dynamic> json) {
  return TransmissionTorrent(
    name: json['name'] as String,
    files: (json['files'] as List)
        ?.map((e) => e == null
            ? null
            : TransmissionFile.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$TransmissionTorrentToJson(
        TransmissionTorrent instance) =>
    <String, dynamic>{
      'name': instance.name,
      'files': instance.files?.map((e) => e?.toJson())?.toList(),
    };

TransmissionFile _$TransmissionFileFromJson(Map<String, dynamic> json) {
  return TransmissionFile(
    bytesCompleted: json['bytesCompleted'] as int,
    length: json['length'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$TransmissionFileToJson(TransmissionFile instance) =>
    <String, dynamic>{
      'bytesCompleted': instance.bytesCompleted,
      'length': instance.length,
      'name': instance.name,
    };
