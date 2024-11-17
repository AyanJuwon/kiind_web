// To parse this JSON data, do
//
//     final clientResponse = clientResponseFromMap(jsonString);

import 'dart:convert';

import 'package:kiind_web/core/util/extensions/string_extensions.dart';

class ClientResponse {
  ClientResponse({
    this.status,
    this.message,
    this.data,
    this.messageString,
  });

  final String? status, messageString;
  final Map<String, dynamic>? message;
  final dynamic data;

  String? get token {
    String? token;

    String? rawToken = data?['token'];

    if (rawToken.isNotNullOrEmpty) {
      List<String> tokenSegments = rawToken!.split('|');
      if (tokenSegments.length == 2) token = tokenSegments.last;
    }

    return token;
  }

  bool get hasToken => (data is Map && data.containsKey('token'));

  factory ClientResponse.fromJson(String str) =>
      ClientResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClientResponse.fromMap(Map<String, dynamic> json) => ClientResponse(
        status: json["status"],
        message: json["message"] == null
            ? null
            : (json["message"] is Map)
                ? Map?.from(json["message"])
                : null,
        messageString: json["message"] == null
            ? null
            : (json["message"] is Map)
                ? null
                : json["message"],
        data: json["data"] == null
            ? null
            : (json["data"] is Map)
                ? Map?.from(json["data"])
                : (json["data"] is List)
                    ? json["data"]
                    : null,
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "message_string": messageString,
        "data": data,
      };
}
