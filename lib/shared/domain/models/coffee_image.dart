import 'dart:typed_data';

import 'package:flutter/foundation.dart';

@immutable
class CoffeeImage {
  const CoffeeImage({
    required this.bytes,
    required this.sourceUrl,
    this.id,
    this.savedAt,
  });

  final String? id;
  final Uint8List bytes;
  final String sourceUrl;
  final DateTime? savedAt;

  CoffeeImage copyWith({
    String? id,
    Uint8List? bytes,
    String? sourceUrl,
    DateTime? savedAt,
  }) {
    return CoffeeImage(
      id: id ?? this.id,
      bytes: bytes ?? this.bytes,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      savedAt: savedAt ?? this.savedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CoffeeImage &&
        other.id == id &&
        other.sourceUrl == sourceUrl;
  }

  @override
  int get hashCode => id.hashCode ^ sourceUrl.hashCode;
}
