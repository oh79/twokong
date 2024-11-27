import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String? nickname;
  final int? age;
  final String? occupation;
  final List<String> stressFactors;
  final List<String> favoritePolicies;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  UserModel({
    required this.uid,
    required this.email,
    this.nickname,
    this.age,
    this.occupation,
    this.stressFactors = const [],
    this.favoritePolicies = const [],
    this.createdAt,
    this.lastLoginAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      nickname: data['nickname'],
      age: data['age'],
      occupation: data['occupation'],
      stressFactors: List<String>.from(data['stressFactors'] ?? []),
      favoritePolicies: List<String>.from(data['favoritePolicies'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      lastLoginAt: (data['lastLoginAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'nickname': nickname,
      'age': age,
      'occupation': occupation,
      'stressFactors': stressFactors,
      'favoritePolicies': favoritePolicies,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'lastLoginAt':
          lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String? ?? '',
      email: map['email'] as String? ?? '',
      nickname: map['nickname'] as String?,
      age: map['age'] as int?,
      occupation: map['occupation'] as String?,
      stressFactors:
          (map['stressFactors'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      lastLoginAt: (map['lastLoginAt'] as Timestamp?)?.toDate(),
    );
  }
}
