import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/routes/app_pages.dart';
import 'app/core/theme/theme.dart';
import 'app/core/bindings/initial_binding.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    runApp(const MyApp());
  } catch (e, stack) {
    debugPrint('=== 초기화 에러 ===\n$e\n$stack');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '직장인 정신건강 지원',
      theme: AppTheme.lightTheme,
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? AppRoutes.auth
          : AppPages.initial,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),
      defaultTransition: Transition.fade,
      debugShowCheckedModeBanner: false,
    );
  }
}
