import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wefriend_flutter/Pages/ExtraPage/TimerPage.dart';

// 定义控制器
class BloCDemoController extends GetxController {
  final TextEditingController usernameController =
      TextEditingController(text: '123');
  final TextEditingController passwordController =
      TextEditingController(text: '123');
  final RxBool isLoggedIn = false.obs;

  void loginButtonPressed() {
    final username = usernameController.text;
    final password = passwordController.text;

    isLoggedIn.value = (username == '123' && password == '123');
    if (isLoggedIn.value) {
      Get.to(() => TimerPage());
    } else {
      Get.snackbar('提示', '账号或密码错误');
    }
  }
}

// 定义BloCDemoPage
class BloCDemoPage extends StatelessWidget {
  final BloCDemoController controller = Get.put(BloCDemoController());
  BloCDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 点击空白处收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BLoC Demo'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Hero(
                  tag: 'transitionsTAG',
                  child: Icon(Icons.timeline_rounded, weight: 100, size: 100)),
              TextField(
                controller: controller.usernameController,
                decoration: const InputDecoration(
                  labelText: '用户名',
                ),
              ),
              TextField(
                controller: controller.passwordController,
                decoration: const InputDecoration(
                  labelText: '密码',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  controller.loginButtonPressed();
                },
                child: const Text('登录'),
              ),
            ],
          ),
        ),
      ),
    );
  }
 }
