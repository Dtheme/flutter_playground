import 'package:flutter/material.dart';

class ArtItem extends StatelessWidget {
  final String imageUrl;
  final String artistTitle;
  final String dateDisplay;
  final List<String> classificationTitles;
  final Map<String, dynamic>? colorData; // JSON 中的 color 字段
  final double colorfulness; // 色彩饱和度
  final VoidCallback onTap;

  const ArtItem({
    super.key,
    required this.imageUrl,
    required this.artistTitle,
    required this.dateDisplay,
    required this.classificationTitles,
    required this.colorData, // 直接传入 color 字段
    required this.colorfulness,
    required this.onTap,
  });

  // 从 colorData 获取颜色
  Color getColorFromData() {
    if (colorData == null) {
      return Colors.grey; // 如果没有颜色信息，显示灰色
    }
    final h = (colorData?['h'] ?? 0).toDouble(); // 色相 (Hue)
    final l = (colorData?['l'] ?? 50).toDouble() / 100; // 明度 (Lightness)
    final s = (colorData?['s'] ?? 100).toDouble() / 100; // 饱和度 (Saturation)
    return HSLColor.fromAHSL(1.0, h, s, l).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final colorBlock = getColorFromData(); // 动态获取色块颜色

    return GestureDetector(
      onTap: onTap, // 绑定点击事件
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片部分
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                'https://www.artic.edu/iiif/2/$imageUrl/full/400,/0/default.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child:
                        Icon(Icons.broken_image, size: 60, color: Colors.grey),
                  ),
                ),
              ),
            ),

            // 文本内容部分
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 艺术家标题
                  Text(
                    artistTitle.isNotEmpty ? artistTitle : '未知艺术家',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 日期
                  Text(
                    dateDisplay.isNotEmpty ? dateDisplay : '暂无日期信息',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 分类
                  Text(
                    classificationTitles.isNotEmpty
                        ? classificationTitles.join(', ')
                        : '暂无分类信息',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 色块和色彩饱和度
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '主色调：',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          // 色块
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: colorBlock,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // 色彩饱和度
                        ],
                      ),
                      Container(
                        //text左对齐
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '色彩饱和度: ${colorfulness.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),

                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
