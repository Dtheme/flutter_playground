import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wefriend_flutter/Pages/ExplorePage/ExploredDetailPage1.dart';
import 'package:wefriend_flutter/Pages/ExplorePage/ExploredDetailPage2.dart';
import 'package:wefriend_flutter/Util/global.dart';

class ExploreController extends GetxController {
  var exploreCount = 0.obs;
  void increment() {
    exploreCount++;
  }
}

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final ExploreController exploreController = Get.put(ExploreController());
  final TextEditingController _controller = TextEditingController();
  String _inputText = '';
  String exploreCallBack = '';

  @override
  Widget build(BuildContext context) {
    return Material(
      // color: Colors.orange,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() => Text(
                'Explore Count: ${exploreController.exploreCount}',
                style: const TextStyle(fontSize: 24),
              )),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              exploreController.increment();
            },
            child: const Text('Increment Explore Count'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.to(const ExploredDetailPage1());
            },
            child: const Text('测试getX：Get.to'),
          ),
          ElevatedButton(
            onPressed: () async {
              var result = await Get.to(const ExploredDetailPage1(),
                  arguments: '这是从外部传递的参数2');
              exploreCallBack = result;
              logger.t('这是等待返回的值,从explorePage2回传参数：$result');
            },
            child: const Text('测试getX：参数传递'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
                width: 20,
              ),
              Expanded(
                // flex: 1,
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      labelText: '输入文本',
                      hintText: '请输入文本',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0), // 圆角
                        borderSide: const BorderSide(
                            color: Colors.red, width: 2.0), // 边框颜色和宽度
                      )),
                  onChanged: (text) {
                    setState(() {
                      _inputText = text;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
                width: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  // $_inputText
                  Get.to(const ExploredDetailPage1(), arguments: _inputText);
                  logger.i('当前输入框的值：$_inputText');
                },
                child: const Text('输入的文本'),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Get.off(const ExploredDetailPage2());
            },
            child: const Text('测试getX：Get.off'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.dialog(
                const AlertDialog(
                  title: Text('Dialog Title'),
                  content: Text('This is a dialog'),
                ),
              );
              Get.snackbar('Title', 'This is a snackbar',
                  backgroundColor: const Color.fromRGBO(0, 0, 255, 0.3),
                  colorText: Colors.white);
            },
            child: const Text('测试Get Dialog'),
          ),
        ],
      ),
    );
  }
}
