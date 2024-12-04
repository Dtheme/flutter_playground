import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wefriend_flutter/Pages/VideoPage/media_model.dart';

class VideoDetailPage extends StatefulWidget {
  final MediaModel media;

  const VideoDetailPage({required this.media, super.key});

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    // 检查 playUrl 是否存在，避免空值问题
    if (widget.media.playUrl.isEmpty) {
      throw Exception("视频播放 URL 为空！");
    }

    // 初始化 VideoPlayerController
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.media.playUrl))
      ..initialize().then((_) {
        setState(() {}); // 确保初始化完成后刷新界面
      });

    // 监听播放状态变化
    _controller.addListener(() {
      final isPlaying = _controller.value.isPlaying;
      final isEnded = _controller.value.position >= _controller.value.duration;

      if (isPlaying != _isPlaying || isEnded) {
        setState(() {
          _isPlaying = isPlaying && !isEnded;
        });

        // 如果播放结束，重置播放器
        if (isEnded) {
          _controller.pause();
          _controller.seekTo(Duration.zero);
        }
      }
    });
  }

  @override
  void dispose() {
    // 确保释放资源
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _isPlaying ? '' : widget.media.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          // 背景图片
          Positioned.fill(
            child: widget.media.cover.blurred != null
                ? Image.network(
                    widget.media.cover.blurred!,
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.5),
                    colorBlendMode: BlendMode.darken,
                  )
                : Container(color: Colors.black), // 如果背景图为空，用纯黑色代替
          ),
          // 内容
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 播放器封面或视频
              GestureDetector(
                onTap: () {
                  if (_controller.value.isInitialized) {
                    setState(() {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                        _isPlaying = true;
                      }
                    });
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 视频播放器
                    _controller.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          )
                        : Image.network(
                            widget.media.cover.detail,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                    // 播放按钮
                    if (!_controller.value.isPlaying)
                      const Icon(
                        Icons.play_circle_fill,
                        size: 60,
                        color: Colors.white,
                      ),
                  ],
                ),
              ),
              // 视频标题
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  widget.media.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // 视频描述
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  widget.media.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              // 作者信息
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.network(
                        widget.media.author.icon,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.media.author.name,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            widget.media.author.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12.0),
              // 标签部分
              if (widget.media.tags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: widget.media.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Text(
                          tag.name,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
