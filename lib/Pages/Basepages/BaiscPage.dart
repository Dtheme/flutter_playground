import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wefriend_flutter/Pages/HomePage/RichTextDemo.dart';

// 定义控制器
class BasicPageController extends GetxController {
  final RxInt currentIndex = 0.obs;
}

final BasicPageController controller = Get.put(BasicPageController());

class BasicPage extends StatelessWidget {
  final TextStyle _textStyle = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
  );

  const BasicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RichTextDemo();
  }
}
