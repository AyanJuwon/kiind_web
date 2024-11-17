// // To parse this JSON data, do
// //
// //     final message = messageFromMap(jsonString);

// import 'dart:convert';
// import 'dart:developer';

// import 'package:jiffy/jiffy.dart';
// import 'package:kiind/core/util/extensions/string_extensions.dart';

// class Message {
//   Message({
//     this.id,
//     this.campaignId,
//     this.campaignName,
//     this.groupId,
//     this.fromId,
//     this.toId,
//     this.subject,
//     this.lastMessage,
//     this.group,
//     this.ip,
//     this.liked,
//     this.createdAt,
//     this.updatedAt,
//     this.message,
//     this.sender,
//   });

//   final int? id;
//   final int? campaignId;
//   final String? campaignName;
//   final int? groupId;
//   final int? fromId;
//   final int? toId;
//   final String? subject;
//   final String? lastMessage;
//   final String? group;
//   final String? ip;
//   final int? liked;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final dynamic message;
//   final dynamic sender;

//   Message copyWith({
//     int? id,
//     int? campaignId,
//     String? campaignName,
//     int? groupId,
//     int? fromId,
//     int? toId,
//     String? subject,
//     String? lastMessage,
//     String? group,
//     String? ip,
//     int? liked,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//     dynamic message,
//     dynamic sender,
//   }) =>
//       Message(
//         id: id ?? this.id,
//         campaignId: campaignId ?? this.campaignId,
//         campaignName: campaignName ?? this.campaignName,
//         groupId: groupId ?? this.groupId,
//         fromId: fromId ?? this.fromId,
//         toId: toId ?? this.toId,
//         subject: subject ?? this.subject,
//         lastMessage: lastMessage ?? this.lastMessage,
//         group: group ?? this.group,
//         ip: ip ?? this.ip,
//         liked: liked ?? this.liked,
//         createdAt: createdAt ?? this.createdAt,
//         updatedAt: updatedAt ?? this.updatedAt,
//         message: message ?? this.message,
//         sender: sender ?? this.sender,
//       );

//   String get value => (message is String) ? message : '';
//   bool isMine(int? userId) => fromId == userId;

//   bool get isLiked => liked != 0;

//   factory Message.fromJson(String str) => Message.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

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

//   factory Message.fromMap(Map<String, dynamic> json) => Message(
//       id: json["id"],
//       campaignId: json["campaign_id"],
//       campaignName: json["campaign_name"],
//       groupId: json["group_id"],
//       fromId: json["from_id"],
//       toId: json["to_id"],
//       subject: json["subject"],
//       ip: json["ip"],
//       liked: json["liked"],
//       createdAt: json["created_at"] == null
//           ? null
//           : DateTime.tryParse(json["created_at"] ?? ''),
//       updatedAt: json["updated_at"] == null
//           ? null
//           : DateTime.tryParse(json["updated_at"] ?? ''),
//       message: json["message"],
//       group: json["group"],
//       sender: json['sender']);

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "campaign_id": campaignId,
//         "campaign_name": campaignName,
//         "group_id": groupId,
//         "from_id": fromId,
//         "to_id": toId,
//         "subject": subject,
//         "last_message": lastMessage,
//         "ip": ip,
//         "liked": liked,
//         "created_at": createdAt?.toIso8601String(),
//         "updated_at": updatedAt?.toIso8601String(),
//         "message": message,
//         "group": group,
//         "sender": sender,
//       };
// }
