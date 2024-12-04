import 'package:flutter/material.dart';
import 'podcast_model.dart';

class PodcastItem extends StatelessWidget {
  final PodcastModel podcast;
  final String feedUrl; // 添加 feedUrl 属性
  final VoidCallback? itemOnTap; // 点击回调

  const PodcastItem({
    super.key,
    required this.podcast,
    required this.feedUrl, // 接收 feedUrl
    this.itemOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          podcast.artworkUrl600,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 60,
            height: 60,
            color: Colors.grey.shade300,
            child: Icon(Icons.broken_image, color: Colors.grey.shade600),
          ),
        ),
      ),
      title: Text(
        podcast.collectionName,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "作者: ${podcast.artistName}",
              style: const TextStyle(fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "类型: ${podcast.primaryGenreName}",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "曲目数: ${podcast.trackCount}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: itemOnTap, // 使用传递的点击回调
    );
  }
}
