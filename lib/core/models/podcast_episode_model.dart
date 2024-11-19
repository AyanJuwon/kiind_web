// import 'dart:convert';
// import 'dart:developer';

// import 'package:jiffy/jiffy.dart';
// import 'package:kiind_web/core/models/comment_model.dart';
// import 'package:kiind_web/core/util/extensions/string_extensions.dart';

// class PodcastEpisode {
//   PodcastEpisode({
//     this.id,
//     this.title,
//     this.details,
//     this.likes,
//     this.liked,
//     this.file,
//     this.fileUrl,
//     this.size,
//     this.mime,
//     this.ext,
//     this.views,
//     this.comments,
//     this.totalComments,
//     this.createdAt,
//     this.updatedAt,
//     this.podcastTitle,
//     this.podcastImage,
//   });

//   final int? id;
//   final String? title;
//   final int? views;
//   final String? details;
//   final int? likes;
//   final String? file;
//   final String? size;
//   final String? mime;
//   final String? ext;
//   final int? totalComments;
//   bool? liked;
//   final List<Comment>? comments;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final String? fileUrl;
//   final String? podcastTitle;
//   final String? podcastImage;

//   Jiffy? get createdAtJiffy {
//     Jiffy? _j;

//     try {
//       _j = createdAt.isNotNullOrEmpty ? Jiffy(createdAt) : null;
//     } catch (e) {
//       log(e.toString());
//     }

//     return _j;
//   }

//   Jiffy? get updatedAtJiffy {
//     Jiffy? _j;

//     try {
//       _j = updatedAt.isNotNullOrEmpty ? Jiffy(updatedAt) : null;
//     } catch (e) {
//       log(e.toString());
//     }

//     return _j;
//   }

//   PodcastEpisode copyWith(
//           {int? id,
//           String? title,
//           int? views,
//           String? details,
//           int? likes,
//           String? file,
//           String? size,
//           String? mime,
//           String? ext,
//           int? totalComments,
//           bool? liked,
//           List<Comment>? comments,
//           String? fileUrl,
//           DateTime? createdAt,
//           DateTime? updatedAt,
//           String? podcastTitle,
//           String? podcastImage}) =>
//       PodcastEpisode(
//           id: id ?? this.id,
//           title: title ?? this.title,
//           views: views ?? this.views,
//           likes: likes ?? this.likes,
//           comments: comments ?? this.comments,
//           file: file ?? this.file,
//           size: size ?? this.size,
//           mime: mime ?? this.mime,
//           ext: ext ?? this.ext,
//           liked: liked ?? this.liked,
//           totalComments: totalComments ?? this.totalComments,
//           details: details ?? this.details,
//           createdAt: createdAt ?? this.createdAt,
//           updatedAt: updatedAt ?? this.updatedAt,
//           fileUrl: fileUrl ?? this.fileUrl,
//           podcastTitle: podcastTitle ?? this.podcastTitle,
//           podcastImage: podcastImage ?? this.podcastImage);

//   factory PodcastEpisode.fromJson(String str) =>
//       PodcastEpisode.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory PodcastEpisode.fromMap(Map<String, dynamic> json) => PodcastEpisode(
//         id: json["id"],
//         title: json["title"],
//         details: json["details"],
//         comments: ((json["comments"] ?? []) as List<dynamic>)
//             .map((e) => Comment.fromMap(e))
//             .toList(),
//         totalComments: json["total_comments"],
//         file: json["media"]["file"],
//         size: json["media"]["size"],
//         mime: json["media"]["mime"],
//         ext: json["media"]["ext"],
//         likes: json["likes"],
//         liked: json["liked"],
//         views: json["views"],
//         createdAt: json["created_at"] == null
//             ? null
//             : DateTime.tryParse(json["media"]["created_at"] ?? ''),
//         updatedAt: json["updated_at"] == null
//             ? null
//             : DateTime.tryParse(json["media"]["updated_at"] ?? ''),
//         fileUrl: json["media"]["file_url"] ?? '',
//         podcastTitle: json['podcast']['title'],
//         podcastImage: json['podcast']['featured_image'],
//       );

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "title": title,
//         "views": views,
//         "likes": likes,
//         "liked": liked,
//         "file": file,
//         "size": size,
//         "mime": mime,
//         "ext": ext,
//         "comments": comments,
//         "total_comments": totalComments,
//         "details": details,
//         "created_at": createdAt?.toIso8601String(),
//         "updated_at": updatedAt?.toIso8601String(),
//         "file_url": fileUrl,
//         'podcast_title': podcastTitle,
//         'featured_image': podcastImage
//       };
// }
