import 'package:cloud_firestore/cloud_firestore.dart';

class CBTSession {
  final String id;
  final String userId;
  final String situation;
  final String thought;
  final String emotion;
  final String rationalThought;
  final String actionPlan;
  final DateTime createdAt;

  CBTSession({
    required this.id,
    required this.userId,
    required this.situation,
    required this.thought,
    required this.emotion,
    required this.rationalThought,
    required this.actionPlan,
    required this.createdAt,
  });

  factory CBTSession.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CBTSession(
      id: doc.id,
      userId: data['userId'] ?? '',
      situation: data['situation'] ?? '',
      thought: data['thought'] ?? '',
      emotion: data['emotion'] ?? '',
      rationalThought: data['rationalThought'] ?? '',
      actionPlan: data['actionPlan'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'situation': situation,
      'thought': thought,
      'emotion': emotion,
      'rationalThought': rationalThought,
      'actionPlan': actionPlan,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
