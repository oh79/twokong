import 'package:get/get.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/policy_detail/views/policy_detail_view.dart';
import '../modules/policy_detail/bindings/policy_detail_binding.dart';
import '../modules/survey/views/survey_view.dart';
import '../modules/survey/bindings/survey_binding.dart';

abstract class AppRoutes {
  static const home = '/home';
  static const auth = '/auth';
  static const survey = '/survey';
  static const policyDetail = '/policy-detail';
}

class AppPages {
  static const initial = AppRoutes.home;

  static final routes = [
    GetPage(
      name: AppRoutes.auth,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.survey,
      page: () => const SurveyView(),
      binding: SurveyBinding(),
    ),
    GetPage(
      name: AppRoutes.policyDetail,
      page: () => const PolicyDetailView(),
      binding: PolicyDetailBinding(),
    ),
  ];
}
