import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/theme/app_colors.dart';
import 'core/config/app_config.dart';
import 'core/network/notification_service.dart';

import 'features/auth/presentation/pages/splash_screen.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/home_page.dart';

// Entry point for Development
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set Config for Dev
  AppConfig.setConfig(AppConfig(
    environment: AppEnvironment.development,
    apiBaseUrl: 'https://dev-api.parceiroassistencial.com.br',
    useMocks: true,
  ));

  // Initialize Firebase (Files are now present)
  await Firebase.initializeApp();
  
  // Set background messaging handler
  FirebaseMessaging.onBackgroundMessage(NotificationService.backgroundHandler);
  
  // Initialize Local Notifications Service
  await NotificationService().initialize();

  runApp(const ParceiroAssistencialApp());
}

class ParceiroAssistencialApp extends StatelessWidget {
  const ParceiroAssistencialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parceiro Assistencial',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primaryOrange,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.outfitTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: AppColors.textBody,
                displayColor: AppColors.navyBlue,
              ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryOrange,
          primary: AppColors.primaryOrange,
          secondary: AppColors.navyBlue,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
