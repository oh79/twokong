import 'package:cloud_firestore/cloud_firestore.dart'; // FirebaseFirestore, FieldValue
import 'package:flutter/foundation.dart' show debugPrint; // debugPrint
import '../exceptions/custom_auth_exception.dart'; // CustomAuthException 클래스

class AuthService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore 인스턴스 선언

  Future<void> updateUserStressFactors(
      String uid, List<String> stressFactors) async {
    try {
      if (uid.isEmpty) {
        throw ArgumentError('uid는 비어있을 수 없습니다');
      }
      if (stressFactors.isEmpty) {
        throw ArgumentError('스트레스 요인은 최소 1개 이상이어야 합니다');
      }

      await _firestore.collection('users').doc(uid).update({
        'stressFactors': stressFactors,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('스트레스 요인 업데이트 실패: $e');
      if (e is FirebaseException) {
        throw CustomAuthException('Firebase 오류: ${e.message}');
      }
      rethrow;
    }
  }
}
