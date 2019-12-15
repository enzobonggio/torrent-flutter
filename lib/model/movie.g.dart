// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) {
  return Movie(
    title: json['title'] as String,
    year: json['year'] as int,
    image: json['image'] as String,
    torrents: (json['torrents'] as List)
        ?.map((e) =>
            e == null ? null : MovieTorrent.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'title': instance.title,
      'year': instance.year,
      'image': instance.image,
      'torrents': instance.torrents,
    };

MovieTorrent _$MovieTorrentFromJson(Map<String, dynamic> json) {
  return MovieTorrent(
    url: json['url'] as String,
    quality: json['quality'] as String,
  );
}

Map<String, dynamic> _$MovieTorrentToJson(MovieTorrent instance) =>
    <String, dynamic>{
      'url': instance.url,
      'quality': instance.quality,
    };
