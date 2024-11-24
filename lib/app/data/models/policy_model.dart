import 'package:cloud_firestore/cloud_firestore.dart';

class Policy {
  final String id;
  final String title;
  final String description;
  final String target;
  final String category;
  final String benefit;
  final String eligibility;
  final String howToApply;
  final String link;
  final String organization;
  final List<String> tags;
  final DateTime? deadline;

  Policy({
    required this.id,
    required this.title,
    required this.description,
    required this.target,
    required this.category,
    required this.benefit,
    required this.eligibility,
    required this.howToApply,
    required this.link,
    required this.organization,
    required this.tags,
    this.deadline,
  });

  factory Policy.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Policy(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      target: data['target'] ?? '',
      category: data['category'] ?? '',
      benefit: data['benefit'] ?? '',
      eligibility: data['eligibility'] ?? '',
      howToApply: data['howToApply'] ?? '',
      link: data['link'] ?? '',
      organization: data['organization'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      deadline: data['deadline'] != null
          ? (data['deadline'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'target': target,
        'category': category,
        'benefit': benefit,
        'eligibility': eligibility,
        'howToApply': howToApply,
        'link': link,
        'organization': organization,
        'tags': tags,
        'deadline': deadline != null ? Timestamp.fromDate(deadline!) : null,
      };
}
