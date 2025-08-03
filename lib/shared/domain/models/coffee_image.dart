import 'package:flutter/foundation.dart';

/// Domain Model for a Coffee Image
///
/// Note: This class could be split with an base type with Bytes and SourceUrl
/// only used for fetching and an inherited type with ID and SavedAt to be
/// used for storage.
@immutable
class CoffeeImage {
  const CoffeeImage({
    required this.bytes,
    required this.sourceUrl,
    this.id,
    this.savedAt,
  });

  /// The actual image data bytes.
  final Uint8List bytes;
  /// The original URL used to fetch that image.
  final String sourceUrl;
  /// Unique ID assigned when stored
  final String? id;
  /// Date and Time set when stored
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
