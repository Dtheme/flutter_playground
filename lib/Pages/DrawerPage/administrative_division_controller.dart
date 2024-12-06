import 'package:get/get.dart';
import 'package:wefriend_flutter/Models/administrative_division.dart';
import 'package:wefriend_flutter/Network/bussiness_api.dart';

class AdministrativeDivisionController extends GetxController {
  final provinces = <Area>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAdministrativeDivisions(
      onSuccess: (divisions) {
        provinces.value = divisions;
        isLoading.value = false;
      },
      onFailure: (error) {
        errorMessage.value = error;
        isLoading.value = false;
      },
    );
  }
} 