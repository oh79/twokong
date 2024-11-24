import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/policy_model.dart';

class PolicyRepository extends GetxService {
  final _firestore = FirebaseFirestore.instance;

  Future<List<Policy>> getAllPolicies() async {
    final snapshot = await _firestore.collection('policies').get();
    return snapshot.docs.map((doc) => Policy.fromFirestore(doc)).toList();
  }

  Future<List<Policy>> getRecommendedPolicies({
    required int age,
    required String occupation,
    required List<String> stressFactors,
  }) async {
    final querySnapshot = await _firestore
        .collection('policies')
        .where('tags', arrayContainsAny: stressFactors)
        .get();

    return querySnapshot.docs.map((doc) => Policy.fromFirestore(doc)).toList();
  }
}
