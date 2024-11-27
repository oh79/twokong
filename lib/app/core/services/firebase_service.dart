import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../firebase_options.dart';
import '../../data/models/policy_model.dart';

class FirebaseService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<FirebaseService> init() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint('Firebase 초기화 성공');
    } catch (e) {
      debugPrint('Firebase 초기화 실패: $e');
    }
    return FirebaseService();
  }

  // 정책 목록 가져오기
  Stream<List<Policy>> getPolicies() {
    return _firestore.collection('policies').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Policy.fromFirestore(doc)).toList());
  }

  // 정책 즐겨찾기 확인
  Future<bool> isPolicyFavorite(String userId, String policyId) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(policyId)
        .get();
    return doc.exists;
  }

  // 즐겨찾기에서 제거
  Future<void> removeFromFavorites(String userId, String policyId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(policyId)
        .delete();
  }

  // 즐겨찾기에 추가
  Future<void> savePolicyToFavorites(String userId, String policyId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(policyId)
        .set({
      'addedAt': FieldValue.serverTimestamp(),
    });
  }
}
