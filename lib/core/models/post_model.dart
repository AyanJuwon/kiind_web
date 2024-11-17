// To parse this JSON data, do
//
//     final post = postFromMap(jsonString);

// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:jiffy/jiffy.dart';
import 'package:kiind_web/core/models/campaign_model.dart';
import 'package:kiind_web/core/models/comment_model.dart';
import 'package:kiind_web/core/models/media_model.dart';
import 'package:kiind_web/core/models/user_model.dart';
import 'package:kiind_web/core/router/route_paths.dart';
import 'package:kiind_web/core/util/extensions/string_extensions.dart';

import 'group_model.dart';

class Post {
  Post(
      {this.id,
      this.title,
      this.details,
      this.liked,
      this.userId,
      this.groupId,
      this.campaignId,
      this.file,
      this.image,
      this.embedCode,
      this.slug,
      this.likes,
      this.views,
      this.featured,
      this.published,
      this.postCategoryId,
      this.ip,
      this.createdAt,
      this.updatedAt,
      this.totalComments,
      this.user,
      this.group,
      this.postCategory,
      this.campaign,
      this.featuredImage,
      this.mediaFiles,
      this.comments,
      this.charity,
      this.charityImage});

  final int? id;
  final String? title;
  final String? details;
  final int? userId;
  final String? groupId;
  final dynamic campaignId;
  final dynamic file;
  final int? image;
  final String? embedCode;
  final String? slug;
  int? likes;
  final int? views;
  bool? liked;
  final String? featured;
  final String? published;
  final int? postCategoryId;
  final String? ip;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  int? totalComments;
  bool isStreamingLive = false;
  final User? user;
  final Group? group;
  final String? postCategory;
  final dynamic campaign;
  final String? featuredImage;
  final Map<int, MediaFile>? mediaFiles;
  final Map<int, Comment>? comments;
  final String? charityImage;
  final String? charity;

  LinkedHashMap<int, Comment> get sortedComments {
    Map<int, Comment> _comments = comments ?? {};

    var sortedKeys = _comments.keys.toList(growable: false)
      ..sort((k1, k2) => _comments[k2]!.compareTo(_comments[k1]));

    LinkedHashMap<int, Comment> sortedMap = LinkedHashMap.fromIterable(
      sortedKeys,
      key: (k) => k,
      value: (k) => _comments[k]!,
    );

    return sortedMap;
  }

  Jiffy? get createdAtJiffy {
    Jiffy? _j;

    try {
      _j = createdAt.isNotNullOrEmpty ? Jiffy.parse(createdAt as String) : null;
    } catch (e) {
      log(e.toString());
    }

    return _j;
  }

  Jiffy? get updatedAtJiffy {
    Jiffy? _j;

    try {
      _j = updatedAt.isNotNullOrEmpty ? Jiffy.parse(updatedAt as String) : null;
    } catch (e) {
      log(e.toString());
    }

    return _j;
  }

  String get videoUrl {
    String url = '';

    List<String> components = (embedCode ?? '').split('"');

    log(embedCode ?? '');

    for (var i = 0; i < components.length; i++) {
      String component = components[i].trim();

      if (component == "src=") {
        try {
          url = components[i + 1];
        } on Exception catch (e) {
          log("$e: src value doesn't seem to have been provided");
        }
        break;
      }
    }

    return url;
  }

  String get detailRoute => postCategoryId == 1
      ? RoutePaths.newsDetailsScreen
      : postCategoryId == 2
          ? RoutePaths.videoScreen
          : postCategoryId == 3
              ? RoutePaths.podcastScreen
              : RoutePaths.videoScreen; //liveScreen

  bool get isOther => false; //just for Kiind Pay

  bool get isNews => detailRoute == RoutePaths.newsDetailsScreen;
  bool get isPodcast => detailRoute == RoutePaths.podcastScreen;
  bool get isVideo => detailRoute == RoutePaths.videoScreen;
  bool get isLive => postCategoryId == 4;

  // bool get isStreamingLive => isLive && file == null;
  String get liveSrc =>
      // "https://cph-p2p-msl.akamaized.net/hls/live/2000341/test/master.m3u8";
      'https://live.trivoh.com:8443/live/$slug.m3u8';

  bool get isYoutubeVideo => videoUrl.contains("youtube");
  String? get ytId => videoUrl.youtubeId;

  Map<String, dynamic> get sharePayload => {
        'id': id,
        'title': title ?? 'This should be a good title',
        'user_id': userId,
        'group_id': groupId,
        'post_category_id': postCategoryId,
        'embed_code': embedCode,
        'slug': slug,
        'campaign_id': campaignId,
        'featured_image': featuredImage ?? '',
        '__route': detailRoute,
      };

  Post copyWith(
          {int? id,
          String? title,
          String? details,
          int? userId,
          String? groupId,
          dynamic campaignId,
          dynamic file,
          int? image,
          dynamic embedCode,
          String? slug,
          int? likes,
          int? views,
          bool? liked,
          String? featured,
          String? published,
          int? postCategoryId,
          String? ip,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? totalComments,
          User? user,
          Group? group,
          String? postCategory,
          dynamic campaign,
          String? featuredImage,
          Map<int, MediaFile>? mediaFiles,
          Map<int, Comment>? comments,
          String? charity,
          String? charityImage}) =>
      Post(
          id: id ?? this.id,
          title: title ?? this.title,
          details: details ?? this.details,
          userId: userId ?? this.userId,
          groupId: groupId ?? this.groupId,
          campaignId: campaignId ?? this.campaignId,
          file: file ?? this.file,
          image: image ?? this.image,
          embedCode: embedCode ?? this.embedCode,
          slug: slug ?? this.slug,
          likes: likes ?? this.likes,
          views: views ?? this.views,
          featured: featured ?? this.featured,
          published: published ?? this.published,
          postCategoryId: postCategoryId ?? this.postCategoryId,
          ip: ip ?? this.ip,
          createdAt: createdAt ?? this.createdAt,
          updatedAt: updatedAt ?? this.updatedAt,
          totalComments: totalComments ?? this.totalComments,
          user: user ?? this.user,
          group: group ?? this.group,
          postCategory: postCategory ?? this.postCategory,
          campaign: campaign ?? this.campaign,
          featuredImage: featuredImage ?? this.featuredImage,
          mediaFiles: mediaFiles ?? this.mediaFiles,
          comments: comments ?? this.comments,
          charity: charity ?? this.charity,
          charityImage: charityImage ?? this.charityImage);

  factory Post.fromJson(String str) => Post.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Post.fromMap(Map<String, dynamic> json) => Post(
      id: json["id"] is int ? json["id"] : int.tryParse('${json["id"]}'),
      title: json["title"],
      details: json["details"],
      userId: json["user_id"] is int
          ? json["user_id"]
          : int.tryParse('${json["user_id"]}'),
      groupId: json["group_id"],
      campaignId: json["campaign_id"],
      file: json["file"],
      image: json["image"],
      embedCode: json["embed_code"],
      slug: json["slug"],
      likes: json["likes"],
      liked: json["liked"],
      views: json["views"],
      featured: json["featured"],
      published: json["published"],
      postCategoryId: int.tryParse('${json["post_category_id"]}'),
      ip: json["ip"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ''),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ''),
      totalComments: json["total_comments"],
      user: User.fromMap(json["user"] ?? {}),
      group: Group.fromMap(json["group"] ?? {}),
      postCategory:
          json["post_category"] != null ? json['post_category'] : json['type'],
      campaign: json["campaign"] == null
          ? null
          : (json["campaign"] is bool)
              ? json["campaign"]
              : Campaign.fromMap(json["campaign"]),
      featuredImage: json["featured_image"],
      mediaFiles: {
        for (var _map in json["media_files"] ?? [])
          _map['id']: MediaFile.fromMap(_map)
      },
      // comments: {
      //   for (var _map in json["comments"] ?? [])
      //     _map['id']: Comment.fromMap(_map)
      // },
      comments: {
        for (var _map in json["comments"] ?? [])
          _map['id']: Comment.fromMap(_map)
      },
      charity: json['charity'] != null ? json['charity']['title'] : null,
      charityImage: json['charity'] != null ? json['charity']['image'] : null);

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "details": details,
        "user_id": userId,
        "group_id": groupId,
        "campaign_id": campaignId,
        "file": file,
        "image": image,
        "embed_code": embedCode,
        "slug": slug,
        "likes": likes,
        "liked": liked,
        "views": views,
        "featured": featured,
        "published": published,
        "post_category_id": postCategoryId,
        "ip": ip,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "total_comments": totalComments,
        "user": user?.toMap(),
        "group": group?.toMap(),
        "post_category": postCategory,
        "campaign": campaign == null
            ? null
            : campaign is bool
                ? campaign
                : (campaign as Campaign).toMap(),
        "featured_image": featuredImage,
        "media_files":
            (mediaFiles ?? {}).values.map((file) => file.toMap()).toList(),
        "comments": (comments ?? {})
            .values
            .map((_comment) => _comment.toMap())
            .toList(),
        "charity": {"image": charityImage, "title": charity}
      };

  preview() async {
    if (isLive && file == null && slug != null) {
      await Dio()
          .get(liveSrc)
          .then(
            (Response res) => isStreamingLive = (res.statusCode ?? 500) < 300,
          )
          .catchError(
        (e) {
          log('$e');
          return false;
        },
      );
    }
  }
}
