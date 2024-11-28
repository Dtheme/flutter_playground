import 'package:get/get.dart';

class GlobalService extends GetxService {
  // 你的服务逻辑
  RxString data = ''.obs;

  void updateData(String newData) {
    data.value = newData;
  }
}
