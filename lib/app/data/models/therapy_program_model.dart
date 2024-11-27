import 'package:cloud_firestore/cloud_firestore.dart';

class TherapyProgram {
  final String id;
  final String title;
  final String description;
  final String type;
  final int duration;
  final String imageUrl;
  final List<String> tags;

  TherapyProgram({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.duration,
    required this.imageUrl,
    required this.tags,
  });

  factory TherapyProgram.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TherapyProgram(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      type: data['type'] ?? '',
      duration: data['duration'] ?? 0,
      imageUrl: data['imageUrl'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
    );
  }
}
