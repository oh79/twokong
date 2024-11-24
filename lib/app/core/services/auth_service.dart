import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twokong/app/routes/app_pages.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }

  // 익명 로그인
  Future<void> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      if (userCredential.user != null) {
        await saveUserData(userCredential.user!);
        await Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      Get.snackbar('오류', '익명 로그인에 실패했습니다');
      rethrow;
    }
  }

  // 이메일 회원가입
  Future<void> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await saveUserData(userCredential.user!);
        await Get.offAllNamed(AppRoutes.home);
      }
    } on FirebaseAuthException catch (e) {
      String message = '회원가입에 실패했습니다';
      if (e.code == 'email-already-in-use') {
        message = '이미 사용 중인 이메일입니다';
      }
      Get.snackbar('오류', message);
      rethrow;
    }
  }

  // 이메일 로그인
  Future<void> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await updateLastLoginTime(userCredential.user!);
        await Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      Get.snackbar('오류', '로그인에 실패했습니다');
      rethrow;
    }
  }

  // 사용자 정보 저장
  Future<void> saveUserData(User user) async {
    try {
      final userData = {
        'email': user.email ?? '',
        'displayName': user.displayName ?? '',
        'photoURL': user.photoURL ?? '',
        'phoneNumber': user.phoneNumber ?? '',
        'authProvider': user.isAnonymous ? 'anonymous' : 'email',
        'jobInfo': const {},
        'stressFactors': const <String>[],
        'favoritePolicies': const <String>[],
      };

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userData, SetOptions(merge: true));
    } catch (e) {
      debugPrint('사용자 정보 저장 실패: $e');
      Get.snackbar('오류', '사용자 정보 저장에 실패했습니다');
      rethrow;
    }
  }

  // 마지막 로그인 시간 업데이트
  Future<void> updateLastLoginTime(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('마지막 로그인 시간 업데이트 실패: $e');
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.offAllNamed(AppRoutes.auth);
    } catch (e) {
      Get.snackbar('오류', '로그아웃에 실패했습니다');
      rethrow;
    }
  }

  // 사용자의 스트레스 요인 업데이트
  Future<void> updateUserStressFactors(
      String uid, List<String> stressFactors) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'stressFactors': stressFactors,
      });
    } catch (e) {
      debugPrint('스트레스 요인 업데이�� 실패: $e');
      rethrow;
    }
  }
}
