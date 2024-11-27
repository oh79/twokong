import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twokong/app/data/models/user_model.dart';
import 'package:twokong/app/routes/app_routes.dart';
import 'package:twokong/app/modules/auth/exceptions/custom_auth_exception.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Rx<User?> user = Rx<User?>(null);
  bool _isHandlingAuth = false;

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((User? u) {
      user.value = u;
      debugPrint('사용자 상태 변경: ${u?.uid}');

      if (!_isHandlingAuth && u != null && Get.currentRoute == AppRoutes.auth) {
        Get.offAllNamed(AppRoutes.home);
      }
    });
  }

  Future<User?> signUp(String email, String password) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (authResult.user == null) throw CustomAuthException('계정 생성 실패');

      final userModel = UserModel(
        uid: authResult.user!.uid,
        email: email,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(authResult.user!.uid)
          .set(userModel.toFirestore());

      return authResult.user;
    } catch (e) {
      debugPrint('회원가입 실패: $e');
      rethrow;
    }
  }

  Future<void> updateUserSurvey(
    String uid, {
    required String nickname,
    required int age,
    required String occupation,
    required List<String> stressFactors,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'nickname': nickname,
        'age': age,
        'occupation': occupation,
        'stressFactors': stressFactors,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('사용자 설문 정보 업데이트 실패: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.offAllNamed(AppRoutes.auth);
    } catch (e) {
      debugPrint('로그아웃 실패: $e');
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      _isHandlingAuth = true;

      final authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (authResult.user == null) throw CustomAuthException('로그인 실패');

      await _firestore.collection('users').doc(authResult.user!.uid).update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });

      await Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      debugPrint('로그인 실패: $e');
      rethrow;
    } finally {
      _isHandlingAuth = false;
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      debugPrint('사용자 데이터 가져오기 실패: $e');
      return null;
    }
  }
}
