import 'package:cloud_firestore/cloud_firestore.dart';

class Policy {
  final String id;
  final String benefit;
  final String category;
  final DateTime? deadline;
  final String description;
  final String eligibility;
  final String howToApply;
  final String link;
  final String organization;
  final List<String> tags;
  final String target;
  final String title;

  Policy({
    required this.id,
    required this.benefit,
    required this.category,
    this.deadline,
    required this.description,
    required this.eligibility,
    required this.howToApply,
    required this.link,
    required this.organization,
    required this.tags,
    required this.target,
    required this.title,
  });

  factory Policy.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Policy(
      id: doc.id,
      benefit: data['benefit'] ?? '',
      category: data['category'] ?? '',
      deadline: (data['deadline'] as Timestamp?)?.toDate(),
      description: data['description'] ?? '',
      eligibility: data['eligibility'] ?? '',
      howToApply: data['howToApply'] ?? '',
      link: data['link'] ?? '',
      organization: data['organization'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      target: data['target'] ?? '',
      title: data['title'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'benefit': benefit,
      'category': category,
      'deadline': deadline != null ? Timestamp.fromDate(deadline!) : null,
      'description': description,
      'eligibility': eligibility,
      'howToApply': howToApply,
      'link': link,
      'organization': organization,
      'tags': tags,
      'target': target,
      'title': title,
    };
  }

  factory Policy.fromMap(Map<String, dynamic> map) {
    return Policy(
      id: map['id'] as String,
      benefit: map['benefit'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      link: map['link'] as String,
      organization: map['organization'] as String,
      eligibility: '',
      howToApply: '',
      tags: [],
      target: '',
    );
  }
}
