import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:parceiro_assistencial/core/config/app_config.dart';
import 'package:parceiro_assistencial/core/network/notification_service.dart';
import 'package:parceiro_assistencial/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set Config for Production
  AppConfig.setConfig(AppConfig(
    environment: AppEnvironment.production,
    apiBaseUrl: 'https://api.parceiroassistencial.com.br',
    useMocks: false,
  ));

  // Initialize Firebase for Production
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(NotificationService.backgroundHandler);
  await NotificationService().initialize();

  runApp(const ParceiroAssistencialApp());
}
