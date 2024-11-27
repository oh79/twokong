import 'package:get/get.dart';
import '../../../data/models/therapy_program_model.dart';
import '../../../core/services/firebase_service.dart';

class TherapyController extends GetxController {
  final FirebaseService _firebaseService = Get.find();
  final programs = <TherapyProgram>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPrograms();
  }

  Future<void> loadPrograms() async {
    try {
      isLoading(true);
      final programList = await _firebaseService.getTherapyPrograms();
      programs.value = programList;
    } catch (e) {
      Get.snackbar('오류', '프로그램을 불러오는데 실패했습니다');
    } finally {
      isLoading(false);
    }
  }
}
