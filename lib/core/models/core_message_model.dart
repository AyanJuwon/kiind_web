// // To parse this JSON data, do
// //
// //     final coreMessage = coreMessageFromMap(jsonString);

// import 'dart:convert';
// import 'dart:developer';

// import 'package:jiffy/jiffy.dart';
// import 'package:kiind/core/models/user_model.dart';
// import 'package:kiind/core/util/extensions/string_extensions.dart';

// class CoreMessage {
//   CoreMessage({
//     this.id,
//     this.senderId,
//     this.message,
//     this.seen,
//     this.conversationId,
//     this.ip,
//     this.createdAt,
//     this.updatedAt,
//     this.senderUser,
//   });

//   final int? id;
//   final int? senderId;
//   final String? message;
//   final int? seen;
//   final int? conversationId;
//   final String? ip;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final User? senderUser;

//   CoreMessage copyWith({
//     int? id,
//     int? senderId,
//     String? message,
//     int? seen,
//     int? conversationId,
//     String? ip,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//     User? senderUser,
//   }) =>
//       CoreMessage(
//         id: id ?? this.id,
//         senderId: senderId ?? this.senderId,
//         message: message ?? this.message,
//         seen: seen ?? this.seen,
//         conversationId: conversationId ?? this.conversationId,
//         ip: ip ?? this.ip,
//         createdAt: createdAt ?? this.createdAt,
//         updatedAt: updatedAt ?? this.updatedAt,
//         senderUser: senderUser ?? this.senderUser,
//       );

//   factory CoreMessage.fromJson(String str) =>
//       CoreMessage.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   bool isMine(int? userId) => senderId == userId;

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

//   factory CoreMessage.fromMap(Map<String, dynamic> json) => CoreMessage(
//         id: json["id"],
//         senderId: json["sender_id"],
//         message: json["message"],
//         seen: json["seen"],
//         conversationId: json["conversation_id"],
//         ip: json["ip"],
//         createdAt: json["created_at"] == null
//             ? null
//             : DateTime.tryParse(json["created_at"] ?? ''),
//         updatedAt: json["updated_at"] == null
//             ? null
//             : DateTime.tryParse(json["updated_at"] ?? ''),
//         senderUser: json["sender_user"] == null
//             ? null
//             : User.fromMap(json["sender_user"]),
//       );

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "sender_id": senderId,
//         "message": message,
//         "seen": seen,
//         "conversation_id": conversationId,
//         "ip": ip,
//         "created_at": createdAt?.toIso8601String(),
//         "updated_at": updatedAt?.toIso8601String(),
//         "sender_user": senderUser?.toMap(),
//       };
// }
