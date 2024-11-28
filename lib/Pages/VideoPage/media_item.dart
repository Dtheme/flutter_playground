import 'package:flutter/material.dart';
import 'package:wefriend_flutter/Pages/VideoPage/media_model.dart';
import 'video_detail_page.dart';

class MediaItem extends StatelessWidget {
  final MediaModel media;

  const MediaItem({Key? key, required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoDetailPage(media: media),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        color: Colors.black, // 深色背景
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 封面图
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: Image.network(
                media.cover.feed,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // 标题和描述
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    media.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // 白色文字
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    media.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70, // 浅白色文字
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // 作者信息
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  // 作者头像
                  ClipOval(
                    child: Image.network(
                      media.author.icon,
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.account_circle, size: 40, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  // 作者名字
                  Text(
                    media.author.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white, // 白色文字
                    ),
                  ),
                ],
              ),
            ),
            // 标签部分
            if (media.tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: media.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[850], // 更深的灰色背景，与黑色过渡自然
                        borderRadius: BorderRadius.circular(15.0), // 圆角设计
                      ),
                      child: Text(
                        tag.name,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70, // 浅白色文字
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
