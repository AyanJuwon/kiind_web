import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

extension Environment on String {
  String get env => dotenv.get(this, fallback: '');
}

extension HexColorExt on String {
  Color get asColorFromHex {
    String raw = this;

    if (raw.length == 4) {
      raw = '';

      for (var i = 1; i < length; i++) {
        raw += '${this[i]}${this[i]}';
      }
    }

    final buffer = StringBuffer();
    if (length == 6 || length == 7 || raw.length == 6) {
      buffer.write('ff');
    }

    buffer.write(raw.replaceFirst('#', ''));

    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension NullOrEmpty on Object? {
  bool get isNullOrEmpty =>
      this == null || false == this || "" == this || this == [] || this == {};
  bool get isNotNullOrEmpty => !isNullOrEmpty;
}

extension YouTube on String {
  String? get youtubeId {
    if (contains(' ')) {
      return null;
    }

    late final Uri uri;
    try {
      uri = Uri.parse(this);
    } catch (e) {
      return null;
    }

    if (!['https', 'http'].contains(uri.scheme)) {
      return null;
    }

    // youtube.com/watch?v=xxxxxxxxxxx
    if (['youtube.com', 'www.youtube.com', 'm.youtube.com']
            .contains(uri.host) &&
        uri.pathSegments.isNotEmpty &&
        uri.pathSegments.first == 'watch' &&
        uri.queryParameters.containsKey('v')) {
      final videoId = uri.queryParameters['v']!;
      return _isValidId(videoId) ? videoId : null;
    }

    // youtube.com/embed/xxxxxxxxxxx
    if (['youtube.com', 'www.youtube.com', 'm.youtube.com']
            .contains(uri.host) &&
        uri.pathSegments.isNotEmpty &&
        uri.pathSegments.first == 'embed' &&
        uri.pathSegments.length > 1) {
      final videoId = uri.pathSegments[1];
      return _isValidId(videoId) ? videoId : null;
    }

    // youtu.be/xxxxxxxxxxx
    if (uri.host == 'youtu.be' && uri.pathSegments.isNotEmpty) {
      final videoId = uri.pathSegments.first;
      return _isValidId(videoId) ? videoId : null;
    }

    return null;
  }

  bool _isValidId(String id) => RegExp(r'^[_\-a-zA-Z0-9]{11}$').hasMatch(id);
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
