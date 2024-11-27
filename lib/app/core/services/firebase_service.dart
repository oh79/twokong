import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:twokong/app/data/models/user_model.dart';
import '../../../firebase_options.dart';
import '../../data/models/policy_model.dart';
import '../../data/models/therapy_program_model.dart';

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

  Future<UserModel> getUserInfo(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return UserModel.fromFirestore(doc);
    } catch (e) {
      debugPrint('사용자 정보 조회 실패: $e');
      rethrow;
    }
  }

  Future<List<Policy>> getFavoritePolicies(String uid) async {
    try {
      final favoritesDoc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('favorites')
          .get();

      final policies = <Policy>[];
      for (var doc in favoritesDoc.docs) {
        final policyDoc =
            await _firestore.collection('policies').doc(doc.id).get();
        if (policyDoc.exists) {
          policies.add(Policy.fromFirestore(policyDoc));
        }
      }
      return policies;
    } catch (e) {
      debugPrint('즐겨찾기 정책 조회 실패: $e');
      rethrow;
    }
  }

  Future<List<TherapyProgram>> getTherapyPrograms() async {
    try {
      final snapshot = await _firestore.collection('therapy_programs').get();
      return snapshot.docs
          .map((doc) => TherapyProgram.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('치료 프로그램 조회 실패: $e');
      rethrow;
    }
  }
}
