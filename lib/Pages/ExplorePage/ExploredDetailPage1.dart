import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wefriend_flutter/Pages/ExplorePage/ExploredDetailPage2.dart';
import 'package:wefriend_flutter/Util/global.dart';

class ExploredDetailPage1 extends StatelessWidget {
  const ExploredDetailPage1({super.key});

  // final String receivedData = '';

  String get receivedData {
    return Get.arguments ?? '无参数';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receivedData == null
            ? 'Explored Detail Page 1'
            : '前一个页面的传参$receivedData'),
      ),
      body: Center(
        child: Column(children: [
          ElevatedButton(
            child: const Text('跳转到ExploredDetailPage2'),
            onPressed: () {
              Get.to(const ExploredDetailPage2());
            },
          ),
          ElevatedButton(
            child: const Text('弹出snackbar'),
            onPressed: () {
              //  Get.to(ExploredDetailPage2());
              Get.snackbar('Title', receivedData,
                  backgroundColor: const Color.fromRGBO(0, 0, 255, 0.3),
                  colorText: Colors.white);
            },
          ),
          ElevatedButton(
            child: const Text('带参返回'),
            onPressed: () {
              String param = 'Hello from SecondPage';
              logger.i('前一个页面传过来的值，$receivedData 返回的参数：$param');
              //  Get.to(ExploredDetailPage2());
              Get.back(result: param);
            },
          ),
        ]),
      ),
    );
  }
}
