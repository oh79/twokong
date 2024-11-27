import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/policy_model.dart';

class PolicyRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 정책 목록 가져오기
  Future<List<Policy>> getPolicies() async {
    final snapshot = await _firestore.collection('policies').get();
    return snapshot.docs.map((doc) => Policy.fromFirestore(doc)).toList();
  }

  // 정책 상세 정보 가져오기
  Future<Policy?> getPolicyById(String id) async {
    final doc = await _firestore.collection('policies').doc(id).get();
    if (!doc.exists) return null;
    return Policy.fromFirestore(doc);
  }
}
