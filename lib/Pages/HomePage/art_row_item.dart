import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DRowItem extends StatelessWidget {
  // 构造函数
  const DRowItem({
    super.key,
    required this.image, // 图片URL
    required this.title, // 主标题
    required this.subTitle, // 副标题
    required this.onTapBtn1, // 按钮点击事件
    required this.onImageTap, // 图片点击事件
  });

  final String image; // 图片URL
  final String title; // 主标题
  final String subTitle; // 副标题
  final VoidCallback onTapBtn1; // 按钮点击事件
  final VoidCallback onImageTap; // 图片点击事件

  static final Logger _logger = Logger(); // 静态 Logger

  // 添加带阴影的按钮
  Container addShadowButton(BuildContext context, Widget button) {
    return Container(
      height: 44,
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: Colors.white, // 按钮背景颜色
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 1),
            spreadRadius: 2,
            color: Color.fromARGB(255, 187, 217, 231), // 阴影颜色
          ),
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      child: button,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 左对齐
          children: [
            // 图片加载与点击
            GestureDetector(
              onTap: () {
                _logger.i("Image tapped: $image");
                onImageTap(); // 触发图片点击事件
              },
              child: Container(
                width: double.infinity, // 宽度铺满
                height: 200, // 固定高度
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(image),
                    fit: BoxFit.cover, // 图片填充方式
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10), // 间距
            // 主标题
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black, // 主标题颜色
              ),
            ),
            const SizedBox(height: 5), // 间距
            // 副标题
            Text(
              subTitle,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: Colors.grey, // 副标题颜色
              ),
            ),
            const SizedBox(height: 10), // 间距
            // 按钮
            addShadowButton(
              context,
              TextButton(
                onPressed: () {
                  _logger.i("Button tapped: $title");
                  onTapBtn1(); // 触发按钮点击事件
                },
                child: const Text("查看详情"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
