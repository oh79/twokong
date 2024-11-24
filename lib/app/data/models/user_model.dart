class UserModel {
  final String id;
  final String? nickname;
  final Map<String, dynamic> jobInfo;
  final List<String> stressFactors;
  final List<String> favoritePolicies;
  final DateTime createdAt;

  UserModel({
    required this.id,
    this.nickname,
    required this.jobInfo,
    required this.stressFactors,
    required this.favoritePolicies,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    nickname: json['nickname'],
    jobInfo: json['jobInfo'],
    stressFactors: List<String>.from(json['stressFactors']),
    favoritePolicies: List<String>.from(json['favoritePolicies']),
    createdAt: DateTime.parse(json['createdAt']),
  );
} 