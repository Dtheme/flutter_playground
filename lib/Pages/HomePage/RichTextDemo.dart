import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wefriend_flutter/Util/global.dart';
import 'package:wefriend_flutter/Pages/Basepages/BaiscPage.dart'; // 确保导入 BasicPageController
import 'package:wefriend_flutter/Pages/HomePage/rich_text_subpage.dart'; // 导入新页面

// 定义控制器
final BasicPageController controller = Get.put(BasicPageController());

class RichTextDemo extends StatelessWidget {
  RichTextDemo({super.key});

  // 添加一个状态管理的控制器
  final TextEditingController _controller = TextEditingController();
  final RxString _displayText = ''.obs; // 用于存储显示的文本

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: [
          addCarousel(width, height), // 传递 width 和 height
          // 显示拼接后的文本
          Obx(() => Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  _displayText.value.isEmpty
                      ? '这是一个富文本示例，您可以在这里添加更多内容。'
                      : _displayText.value,
                  style: TextStyle(fontSize: 20),
                ),
              )),
          // 添加 emoji 输入框
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '输入您的 emoji...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // 处理发送按钮的逻辑
                    if (_controller.text.isNotEmpty) {
                      _displayText.value += '${_controller.text} '; // 拼接文本
                      _controller.clear(); // 清空输入框
                    }
                  },
                ),
              ],
            ),
          ),
          // 下面增加一个文本内容
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '''
    当前页面是展示一个普通的flutter原生富文本内容demo。
    dart是一种由谷歌开发的编程语言，适用于构建移动、桌面、服务器和网络应用程序。它支持面向对象编程，拥有静态类型和并发编程特性。与 Flutter 框架结合使用时，可以高效地创建跨平台的用户界面。
              ''',
              style: TextStyle(fontSize: 20),
            ),
          ),
          // 下面增加一行icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  // 处理添加按钮的逻辑
                },
              ),
              IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    // 处理删除按钮的逻辑
                  }),
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: () {
                  // 处理添加文件按钮的逻辑
                },
              ),
              IconButton(
                icon: const Icon(Icons.add_location),
                onPressed: () {
                  // 处理添加位置按钮的逻辑
                },
              ),
            ],
          ),
          //'https://img95.699pic.com/photo/40250/7485.jpg_wh300.jpg',下面增加一张图片,平铺在屏幕下面，左右距离16像素
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Image.network(
              'https://img95.699pic.com/photo/40250/7485.jpg_wh300.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // 下面增加一个按钮，点击跳转到新的页面
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                // 处理点击按钮的逻辑
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RichTextSubpage()), // 导航到新页面
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      '富文本结束，点击跳转新页面',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stack addCarousel(double width, double height) {
    final List<String> imagePaths = [
      'https://img95.699pic.com/photo/40250/7483.jpg_wh300.jpg',
      'https://pic.mac89.com/pic/202208/04151220_8a5d5583bf.jpeg',
      'https://static.fotor.com.cn/assets/projects/pages/0cb64de0-ac2d-11e8-9361-c9ab091bf1d0_54d99a89-f0f6-4eba-a8c0-069d0139d073_thumb.jpg',
      'https://img95.699pic.com/photo/40250/7481.jpg_wh300.jpg',
      'https://img95.699pic.com/photo/40250/7483.jpg_wh300.jpg',
      'https://img95.699pic.com/photo/40250/7484.jpg_wh300.jpg',
      'https://img95.699pic.com/photo/40250/7485.jpg_wh300.jpg',
      'https://img95.699pic.com/photo/40250/7486.jpg_wh300.jpg',
      'https://img95.699pic.com/photo/40250/7480.jpg_wh300.jpg',
    ];

    return Stack(alignment: Alignment.bottomCenter, children: [
      CarouselSlider(
        items: imagePaths.map((imagePath) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: width,
                height: height,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: const BoxDecoration(
                  color: Colors.amber,
                ),
                child: Image.network(
                  imagePath,
                  fit: BoxFit.fill,
                ),
              );
            },
          );
        }).toList(),
        options: CarouselOptions(
          height: 200.0,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          viewportFraction: 0.95,
          onPageChanged: (index, reason) {
            controller.currentIndex.value = index;
            if (controller.currentIndex.value == 1) {
              logger.t('轮播新的一轮循环开始：${controller.currentIndex.value}');
            }
          },
        ),
      ),
      Positioned(
        bottom: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < imagePaths.length; i++) buildDot(index: i),
          ],
        ),
      ),
    ]);
  }

  Widget buildDot({required int index}) {
    return Obx(() => Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: controller.currentIndex.value == index ? 16 : 8,
          height: controller.currentIndex.value == index ? 16 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: controller.currentIndex.value == index
                ? Colors.amber
                : Colors.grey,
          ),
        ));
  }
}
