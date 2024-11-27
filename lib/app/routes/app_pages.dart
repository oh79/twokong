import 'package:get/get.dart';
import 'package:twokong/app/modules/cbt_history/bindings/cbt_history_binding.dart';
import 'package:twokong/app/modules/cbt_history/views/cbt_history_view.dart';
import 'package:twokong/app/modules/policy_detail/views/policy_detail_view.dart';
import 'app_routes.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/therapy/bindings/therapy_binding.dart';
import '../modules/therapy/views/therapy_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/survey/bindings/survey_binding.dart';
import '../modules/survey/views/survey_view.dart';
import '../modules/policy_detail/bindings/policy_detail_binding.dart';
import '../modules/cbt/views/cbt_view.dart';
import '../modules/cbt/bindings/cbt_binding.dart';
import '../modules/favorite_policy/views/favorite_policy_view.dart';
import '../modules/favorite_policy/bindings/favorite_policy_binding.dart';

class Routes {
  static const cbtHistory = '/cbt-history';
  static const favoritePolicy = '/favorite-policy';
}

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.cbtHistory,
      page: () => const CBTHistoryView(),
      binding: CBTHistoryBinding(),
    ),
    GetPage(
      name: Routes.favoritePolicy,
      page: () => const FavoritePolicyView(),
      binding: FavoritePolicyBinding(),
    ),
    GetPage(
      name: AppRoutes.auth,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.therapy,
      page: () => const TherapyView(),
      binding: TherapyBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.policyDetail,
      page: () => const PolicyDetailView(),
      binding: PolicyDetailBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.survey,
      page: () => const SurveyView(),
      binding: SurveyBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.cbt,
      page: () => const CBTView(),
      binding: CBTBinding(),
    ),
  ];
}
