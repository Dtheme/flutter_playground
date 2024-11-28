import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimerController extends GetxController {
  // 声明一个RxInt类型的变量duration
  RxInt duration = 0.obs;
  // 声明一个Timer类型的变量timer
  Timer? timer;

  // 开始计时
  void startTimer() {
    // 如果timer不为空，则取消timer
    timer?.cancel();
    // 创建一个定时器，每隔1秒，duration的值加1
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      duration.value++;
    });
  }

  // 暂停计时
  void pauseTimer() {
    // 如果timer不为空，则取消timer
    timer?.cancel();
  }

  // 重置计时
  void resetTimer() {
    // 如果timer不为空，则取消timer
    timer?.cancel();
    // duration的值设置为0
    duration.value = 0;
  }

  // 关闭控制器时，取消timer
  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}

class TimerPage extends StatelessWidget {
  // 将TimerController实例放入Get
  final TimerController _controller = Get.put(TimerController());

  TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
      ),
      body: Center(
        child: Column(
          children: [
            // 使用Hero组件，设置tag属性，并设置child属性
            const Hero(
              tag: 'transitionsTAG',
              child: Icon(
                Icons.timeline_rounded,
                weight: 300,
                size: 300,
              ),
            ),
            // 使用Obx组件，返回一个Text组件  注意：这是在一个stateless组件中
            Obx(() {
              return Text(
                '计时器：${_controller.duration.value}秒',
                style: const TextStyle(fontSize: 20),
              );
            }),
            Obx(
              () {
                // 获取duration的值
                final duration = _controller.duration.value;
                // 计算秒、分、时
                final seconds = duration % 60;
                final minutes = (duration ~/ 60) % 60;
                final hours = (duration ~/ 3600) % 24;
                // 返回一个Text组件，显示小时、分钟、秒
                return Text(
                  '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 48),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _controller.startTimer,
            child: const Icon(Icons.play_arrow),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _controller.pauseTimer,
            child: const Icon(Icons.pause),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _controller.resetTimer,
            child: const Icon(Icons.stop),
          ),
        ],
      ),
    );
  }
}
