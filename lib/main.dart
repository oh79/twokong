import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/core/theme/theme.dart';
import 'app/core/bindings/initial_binding.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화 완료 후 앱 실행
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      initialBinding: InitialBinding(),
      defaultTransition: Transition.fade,
      debugShowCheckedModeBanner: false,
    );
  }
}
