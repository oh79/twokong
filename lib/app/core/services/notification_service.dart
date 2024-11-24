import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationService extends GetxService {
  static NotificationService get to => Get.find();

  // 알림 채널 키 상수 정의
  static const String basicChannelKey = 'basic_channel';
  static const String policyChannelKey = 'policy_reminders';

  @override
  void onInit() {
    super.onInit();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      await AwesomeNotifications().initialize(
        null,
        [
          _createBasicChannel(),
          _createPolicyChannel(),
        ],
      );

      await _requestPermission();
    } catch (e) {
      debugPrint('알림 초기화 실패: $e');
    }
  }

  NotificationChannel _createBasicChannel() {
    return NotificationChannel(
      channelKey: basicChannelKey,
      channelName: '기본 알림',
      channelDescription: '기본 알림 채널',
      defaultColor: Colors.blue,
      importance: NotificationImportance.High,
      enableVibration: true,
    );
  }

  NotificationChannel _createPolicyChannel() {
    return NotificationChannel(
      channelKey: policyChannelKey,
      channelName: '정책 알림',
      channelDescription: '정책 마감일 알림',
      defaultColor: const Color(0xFF9D50DD),
      importance: NotificationImportance.High,
      defaultRingtoneType: DefaultRingtoneType.Notification,
    );
  }

  Future<void> _requestPermission() async {
    try {
      final isAllowed = await AwesomeNotifications().isNotificationAllowed();
      if (!isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    } catch (e) {
      debugPrint('알림 권한 요청 실패: $e');
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String channelKey = basicChannelKey,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: channelKey,
        title: title,
        body: body,
      ),
    );
  }

  Future<void> showPolicyNotification({
    required String title,
    required String body,
    DateTime? scheduleTime,
  }) async {
    final notification = NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: policyChannelKey,
      title: title,
      body: body,
    );

    if (scheduleTime != null) {
      await AwesomeNotifications().createNotification(
        content: notification,
        schedule: NotificationCalendar.fromDate(date: scheduleTime),
      );
    } else {
      await AwesomeNotifications().createNotification(
        content: notification,
      );
    }
  }
}
