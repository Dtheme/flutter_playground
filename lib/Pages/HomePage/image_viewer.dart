import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  final String imageUrl;

  const ImageViewer({super.key, required this.imageUrl});

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  double _scale = 1.0; // 当前缩放比例

  @override
  Widget build(BuildContext context) {
    return
        Material(
        // backgroundColor:Colors.black,
        color:Colors.black.withOpacity(0.5),
        child:
        GestureDetector(
      onTap: () {
        Navigator.pop(context); // 点击图片时返回
      },
      onVerticalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dy > 0) {
          Navigator.pop(context); // 下拉手势关闭页面
        }
      },
      onDoubleTap: () {
        setState(() {
          _scale = _scale == 1.0 ? 2.0 : 1.0;
        });
      },
      child: InteractiveViewer(
        boundaryMargin: EdgeInsets.zero, // 边界设置为0以占满整个屏幕
        minScale: 0.1, // 最小缩放比例
        maxScale: 4.0, // 最大缩放比例
        scaleEnabled: true, // 启用缩放
        child: SizedBox.expand(
          // 使内容占满整个屏幕
          child: Transform.scale(
            scale: _scale,
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.contain, // 适应屏幕大小
            ),
          ),
        ),
      ),
    ),
    );
  }
}
