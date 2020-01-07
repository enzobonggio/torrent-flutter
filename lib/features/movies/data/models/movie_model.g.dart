// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieModel _$MovieModelFromJson(Map<String, dynamic> json) {
  return MovieModel(
    title: json['title'] as String,
    year: json['year'] as int,
    image: json['image'] as String,
    torrents: (json['torrents'] as List)
        ?.map((e) => e == null
            ? null
            : MovieTorrentModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$MovieModelToJson(MovieModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'year': instance.year,
      'image': instance.image,
      'torrents': instance.torrents,
    };

MovieTorrentModel _$MovieTorrentModelFromJson(Map<String, dynamic> json) {
  return MovieTorrentModel(
    url: json['url'] as String,
    quality: json['quality'] as String,
  );
}

Map<String, dynamic> _$MovieTorrentModelToJson(MovieTorrentModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'quality': instance.quality,
    };
