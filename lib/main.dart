import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'dart:io';
import 'app/routes/app_pages.dart';
import 'app/core/theme/theme.dart';
import 'app/core/bindings/initial_binding.dart';
import 'firebase_options.dart';
import 'app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (Platform.isAndroid) {
      await GoogleApiAvailability.instance.makeGooglePlayServicesAvailable();
    }
  } catch (e) {
    debugPrint('초기화 오류: $e');
  }

  final initialBinding = InitialBinding();
  await initialBinding.dependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '마음피움',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.auth,
      getPages: AppPages.routes,
      defaultTransition: Transition.fade,
      debugShowCheckedModeBanner: false,
    );
  }
}
