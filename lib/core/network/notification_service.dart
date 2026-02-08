import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permissions for iOS
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('🔔 Permissão de notificação concedida');
      }
    }

    // Get FCM Token and PRINT IT clearly
    String? token = await _fcm.getToken();
    if (kDebugMode) {
      print('\n🚀 ==========================================');
      print('🔥 SEU FCM TOKEN PARA TESTES:');
      print('$token');
      print('========================================== 🚀\n');
    }

    // Handle Foreground Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('📩 Mensagem recebida em foreground: ${message.notification?.title}');
      }
    });

    // Handle background click
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('🖱️ Clique na notificação detectado!');
      }
    });
  }

  static Future<void> backgroundHandler(RemoteMessage message) async {
    if (kDebugMode) {
      print('💤 Mensagem recebida em background: ${message.messageId}');
    }
  }
}
