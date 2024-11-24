import '../../data/models/policy_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FirebaseService extends GetxService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<bool> isPolicyFavorite(String policyId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return false;

    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(policyId)
        .get();

    return doc.exists;
  }

  Future<void> removeFromFavorites(String policyId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(policyId)
        .delete();
  }

  Future<void> savePolicyToFavorites(Policy policy) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore.runTransaction((transaction) async {
      final userDoc =
          await transaction.get(_firestore.collection('users').doc(userId));

      if (!userDoc.exists) {
        transaction.set(_firestore.collection('users').doc(userId), {
          'createdAt': FieldValue.serverTimestamp(),
          'favoritePolicies': [policy.id],
        });
      }

      transaction.set(
          _firestore
              .collection('users')
              .doc(userId)
              .collection('favorites')
              .doc(policy.id),
          {
            'addedAt': FieldValue.serverTimestamp(),
            'policyId': policy.id,
          });
    });
  }

  Stream<List<Policy>> getFavoritePolicies() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .asyncMap((snapshot) async {
      final policies = <Policy>[];
      for (var doc in snapshot.docs) {
        final policyDoc =
            await _firestore.collection('policies').doc(doc['policyId']).get();
        if (policyDoc.exists) {
          policies.add(Policy.fromFirestore(policyDoc));
        }
      }
      return policies;
    });
  }

  Future<void> initializePolicyCollection() async {
    final policyCollection = await _firestore.collection('policies').get();

    if (policyCollection.docs.isEmpty) {
      final initialPolicies = [
        {
          'title': '청년도약계좌',
          'description': '청년의 자산형성 지원을 위한 저축 장려 정책',
          'target': '청년',
          'category': '자산형성',
          'benefit': '매월 적립금 최대 100만원',
          'eligibility': '만 19-34세 청년',
          'howToApply': '온라인 신청',
          'link': 'https://example.com/policy1',
          'organization': '금융위원회',
          'tags': ['경제', '자산형성', '미래불안'],
          'deadline':
              Timestamp.fromDate(DateTime.now().add(const Duration(days: 30))),
        },
        {
          'title': '직장인 마음건강 지원',
          'description': '직장인 스트레스 관리 및 상담 지원 프로그램',
          'target': '회사원',
          'category': '정신건강',
          'benefit': '상담비 지원 월 20만원',
          'eligibility': '만 19세 이상 직장인',
          'howToApply': '온라인/모바일 신청',
          'link': 'https://example.com/policy2',
          'organization': '고용노동부',
          'tags': ['직장내 갈등', '대인관계', '업무과중'],
          'deadline': null,
        },
        {
          'title': '프리랜서 건강검진',
          'description': '프리랜서 대상 정신건강 검진 지원',
          'target': '프리랜서',
          'category': '건강',
          'benefit': '검진비 전액 지원',
          'eligibility': '프리랜서 및 특수고용직',
          'howToApply': '온라인 신청',
          'link': 'https://example.com/policy3',
          'organization': '보건복지부',
          'tags': ['건강문제', '업무 성과', '미래불안'],
          'deadline':
              Timestamp.fromDate(DateTime.now().add(const Duration(days: 60))),
        },
      ];

      final batch = _firestore.batch();
      for (var policy in initialPolicies) {
        final docRef = _firestore.collection('policies').doc();
        batch.set(docRef, policy);
      }
      await batch.commit();
    }
  }
}
