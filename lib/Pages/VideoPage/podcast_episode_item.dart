import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'podcast_episode.dart';

class PodcastEpisodeItem extends StatelessWidget {
  final PodcastEpisode episode;
  final VoidCallback onPlay;
  final VoidCallback onExpand;
  final bool isPlaying;
  final bool isExpanded;

  const PodcastEpisodeItem({
    Key? key,
    required this.episode,
    required this.onPlay,
    required this.onExpand,
    this.isPlaying = false,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Theme(
        data: Theme.of(context)
            .copyWith(dividerColor: Colors.transparent), // 去掉分割线
        child: ListTileTheme(
          contentPadding: EdgeInsets.zero,
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
            initiallyExpanded: isExpanded,
            onExpansionChanged: (expanded) {
              if (expanded) {
                onExpand();
              }
            },
            title: Text(
              episode.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              episode.pubDate,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            trailing: IconButton(
              icon: Icon(
                isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                color: isPlaying ? Colors.red : Colors.green,
              ),
              onPressed: onPlay,
            ),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Html(
                  data: episode.description ?? '<p>无描述信息</p>',
                  style: {
                    "body": Style(
                      backgroundColor: Colors.transparent,
                    ),
                    "p": Style(
                      fontSize: FontSize(16.0),
                      lineHeight: const LineHeight(1.5),
                      color: Colors.black87, // 设置段落文字为深灰色
                    ),
                    "a": Style(
                      color: Colors.blue, // 设置链接文字为蓝色
                      textDecoration: TextDecoration.underline,
                    ),
                    "h1": Style(
                      fontSize: FontSize(24.0),
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // 设置标题文字为黑色
                    ),
                    "h2": Style(
                      fontSize: FontSize(22.0),
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // 设置标题文字为黑色
                    ),
                    "h3": Style(
                      fontSize: FontSize(20.0),
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // 设置标题文字为黑色
                    ),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
