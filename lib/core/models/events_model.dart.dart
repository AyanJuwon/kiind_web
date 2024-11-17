// // To parse this JSON data, do
// //
// //     final Event = EventFromMap(jsonString);

// import 'dart:convert';
// import 'dart:developer';

// import 'package:jiffy/jiffy.dart';
// import 'package:kiind/core/models/media_model.dart';
// import 'package:kiind/core/util/extensions/string_extensions.dart';

// class Event {
//   Event({
//     this.id,
//     this.title,
//     this.details,
//     this.createdAt,
//     this.campaignId,
//     this.ticket,
//     this.userId,
//     this.file,
//     this.ip,
//     this.status,
//     this.updatedAt,
//     this.mediaFiles,
//   });

//   final int? id;
//   final String? title;
//   final String? details;
//   final DateTime? createdAt;
//   final int? campaignId;
//   final int? userId;
//   final dynamic file;
//   final String? ip;
//   final String? ticket;
//   final int? status;
//   final DateTime? updatedAt;
//   final List<MediaFile>? mediaFiles;

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

//   Event copyWith({
//     int? id,
//     String? title,
//     String? details,
//     String? date,
//     String? time,
//     String? location,
//     DateTime? createdAt,
//     int? campaignId,
//     String? ticket,
//     int? userId,
//     dynamic file,
//     String? ip,
//     int? status,
//     DateTime? updatedAt,
//     List<MediaFile>? mediaFiles,
//   }) =>
//       Event(
//         id: id ?? this.id,
//         title: title ?? this.title,
//         details: details ?? this.details,
//         createdAt: createdAt ?? this.createdAt,
//         campaignId: campaignId ?? this.campaignId,
//         userId: userId ?? this.userId,
//         file: file ?? this.file,
//         ip: ip ?? this.ip,
//         ticket: ticket ?? this.ticket,
//         status: status ?? this.status,
//         updatedAt: updatedAt ?? this.updatedAt,
//         mediaFiles: mediaFiles ?? this.mediaFiles,
//       );

//   factory Event.fromJson(String str) => Event.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory Event.fromMap(Map<String, dynamic> json) => Event(
//         id: json["id"],
//         title: json["title"],
//         details: json["details"],
//         campaignId: json["campaign_id"],
//         userId: json["user_id"],
//         file: json["file"],
//         ip: json["ip"],
//         ticket: json["ticket"],
//         status: json["status"],
//         createdAt: DateTime.tryParse(json["created_at"] ?? ''),
//         updatedAt: DateTime.tryParse(json["updated_at"] ?? ''),
//         mediaFiles: json["media_files"] == null
//             ? null
//             : List<MediaFile>.from(
//                 json["media_files"].map(
//                   (x) => MediaFile.fromMap(x),
//                 ),
//               ),
//       );

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "title": title,
//         "details": details,
//         "campaign_id": campaignId,
//         "user_id": userId,
//         "file": file,
//         "ip": ip,
//         "ticket": ticket,
//         "status": status,
//         "created_at": createdAt?.toIso8601String(),
//         "updated_at": updatedAt?.toIso8601String(),
//         "media_files": mediaFiles == null
//             ? null
//             : List<dynamic>.from(
//                 (mediaFiles ?? []).map(
//                   (x) => x.toMap(),
//                 ),
//               ),
//       };
// }
