
import 'dart:typed_data';

class FarmNote {
  String id;
  String title;
  String cropName;
  String season;
  int growthDays;
  String description;
  String? sticker;
  Uint8List? photoBytes;
  DateTime createdAt;

  FarmNote({
    required this.id,
    required this.title,
    required this.cropName,
    required this.season,
    required this.growthDays,
    required this.description,
    this.sticker,
    this.photoBytes,
    required this.createdAt,
  });
}