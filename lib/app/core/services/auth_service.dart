import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twokong/app/data/models/user_model.dart';
import 'package:twokong/app/routes/app_pages.dart';
import 'package:twokong/app/modules/auth/exceptions/custom_auth_exception.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    _auth.signOut().then((_) {
      _auth.authStateChanges().listen((User? u) {
        user.value = u;
        debugPrint('사용자 상태 변경: ${u?.uid}');
        if (u != null && Get.currentRoute == AppRoutes.auth) {
          Get.offAllNamed(AppRoutes.home);
        }
      });
    });
  }

  Future<void> signUp(String email, String password) async {
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

      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      debugPrint('회원가입 실패: $e');
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
      final authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (authResult.user == null) throw CustomAuthException('로그인 실패');

      await _firestore.collection('users').doc(authResult.user!.uid).update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });

      Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase 로그인 오류: ${e.code}');
      switch (e.code) {
        case 'user-not-found':
          throw CustomAuthException('존재하지 않는 계정입니다');
        case 'wrong-password':
          throw CustomAuthException('비밀번호가 일치하지 않습니다');
        case 'user-disabled':
          throw CustomAuthException('비활성화된 계정입니다');
        case 'invalid-email':
          throw CustomAuthException('올바르지 않은 이메일 형식입니다');
        default:
          throw CustomAuthException('로그인 중 오류가 발생했습니다');
      }
    } catch (e) {
      debugPrint('로그인 실패: $e');
      rethrow;
    }
  }
}
