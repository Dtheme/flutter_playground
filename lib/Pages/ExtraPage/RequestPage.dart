import 'package:flutter/material.dart';
// import 'package:flutter_nb_net/flutter_net.dart';
import 'package:wefriend_flutter/Network/RequestManager.dart';
import 'package:wefriend_flutter/Util/global.dart';
import 'package:wefriend_flutter/NativeInteraction/PlatformChannel.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/Network/bussiness_api.dart';

class RequestPage extends StatefulWidget {
  // 使用UniqueKey()来避免widget在树中的位置发生变化时，会被认为是同一个widget
  const RequestPage({required Key key}) : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  String _savedValue = '';

  RequestManager requestManager = RequestManager();
  List<String> listTitles = [
    "测试网络请求",
    "测试跳转原生页面",
    "测试调用原生代码-系统弹窗",
    "测试flutter自定义snakebar",
    "测试flutter自定义Dialog",
    "测试flutter持久化：存数据",
    "测试flutter持久化：读数据"
  ];
  List<String> buttonTitles = [
    "发网络请求",
    "跳转原生页面",
    "iOS系统弹窗",
    "flutter自定义snakebar",
    "flutter自定义Dialog",
    "持久化:存数据",
    "持久化:读数据",
  ];

  // 加载之前保存的值
  Future<String> _loadSavedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedValue = prefs.getString('we_cache_key') ?? '';
    logger.t('RequestPage print _savedValue: $savedValue');
    return savedValue;
  }

  // 保存值
  _saveValue(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('we_cache_key', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Page'),
      ),
      body: ListView.builder(
        itemCount: listTitles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('chapter $index'),
            subtitle: Text(listTitles[index]),
            trailing: ElevatedButton(
              onPressed: () {
                if (index == 0) {
                  // RequestManager().;
                  requestGet2();
                } else if (index == 1) {
                  PlatformChannel.openNativePage();
                } else if (index == 2) {
                  String message = 'This is a message from Flutter page!';
                  PlatformChannel.showSystemAlert(
                    'Alert Title',
                    message,
                    () {
                      Get.rawSnackbar(
                        messageText: Text(
                          ('点击iOS系统弹窗点确定之后弹出信息： $message'),
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: const Color.fromRGBO(0, 0, 255, 0.3),
                        duration: const Duration(seconds: 3),
                      );
                      logger.t('RequestPage print User tapped OK');
                      logger.i(message);
                    },
                    () {
                      logger.t('RequestPage print User tapped Cancel');
                    },
                  );
                } else if (index == 3) {
                  String message = 'This is a message from Flutter page!';
                  Get.snackbar(
                    'snackbar1',
                    '这是第一个snackbar，标记信息的来源+$message',
                    backgroundColor: const Color.fromRGBO(0, 0, 255, 0.3),
                    colorText: Colors.white,
                  );
                  Get.snackbar(
                    'snackbar2',
                    '这是第二个snackbar，标记信息的来源+$message',
                    backgroundColor: const Color.fromRGBO(0, 0, 255, 0.3),
                    colorText: Colors.white,
                  );
                } else if (index == 4) {
                  Get.dialog(
                    Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                            const Center(
                              child: Text(
                                'Dialog Content',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (index == 5) {
                  // 保存值
                  // 实现一个diolog包含一个输入框和一个按钮 点击按钮执行保存操作并关闭dialog
                  setState(() async {
                    var savedValue = await _loadSavedValue();
                    Get.defaultDialog(
                      titlePadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                      title: '测试数据持久化',
                      titleStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      content: TextField(
                        controller: TextEditingController(text: savedValue),
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: '请输入要保存的值',
                        ),
                        onChanged: (value) {
                          _savedValue = value;
                        },
                      ),
                      // textConfirm: '保存',
                      // textCancel: '取消',
                      confirm: ElevatedButton(
                        onPressed: () {
                          if (_savedValue.isEmpty) {
                            showToast('输入不能为空!');
                            return;
                          }
                          _saveValue(_savedValue);
                          Get.back();
                        },
                        child: const Text('保存'),
                      ),
                      cancel: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('取消'),
                      ),
                      confirmTextColor: Colors.white,
                    );
                  });
                } else if (index == 6) {
                  // 加载值
                  // 实现一个dialog包含一个Text显示保存的值和一个按钮 点击按钮关闭dialog
                  setState(() async {
                    var savedValue = await _loadSavedValue();
                    logger.t('获取_savedValue: $savedValue');
                    // 弹窗显示
                    Get.defaultDialog(
                      title: '持久化',
                      content: Text(savedValue),
                      textConfirm: '关闭',
                      onConfirm: () {
                        Get.back();
                      },
                    );
                  });
                }
              },
              child: Text(buttonTitles[index]),
            ),
          );
        },
      ),
    );
  }
}
