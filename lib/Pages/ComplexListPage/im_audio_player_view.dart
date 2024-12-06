import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'im_complex_controller.dart';

class ImAudioPlayerView extends StatefulWidget {
  final String audioPath;
  final String messageId;
  final bool isMe;

  const ImAudioPlayerView({
    super.key,
    required this.audioPath,
    required this.messageId,
    required this.isMe,
  });

  @override
  State<ImAudioPlayerView> createState() => _ImAudioPlayerViewState();
}

class _ImAudioPlayerViewState extends State<ImAudioPlayerView> {
  final _player = AudioPlayer();
  final _controller = Get.find<ImComplexController>();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      await _player.setFilePath(widget.audioPath);
      _duration = _player.duration ?? Duration.zero;
      setState(() {});

      // 监听播放位置变化
      _player.positionStream.listen((position) {
        if (mounted) {
          setState(() {
            _position = position;
          });
          // 更新进度
          if (_duration.inMilliseconds > 0) {
            _controller.updatePlayProgress(
                _position.inMilliseconds / _duration.inMilliseconds);
          }
        }
      });

      // 监听播放状态变化
      _player.playerStateStream.listen((state) {
        if (!mounted) return;

        // 更新播放状态
        if (_controller.currentPlayingAudioId.value == widget.messageId) {
          _controller.isPlaying.value = state.playing;
        }

        if (state.processingState == ProcessingState.completed) {
          _controller.stopAudio();
          _player.stop();
          setState(() {
            _position = _duration;
          });
        } else if (state.processingState == ProcessingState.ready) {
          if (!state.playing &&
              _controller.currentPlayingAudioId.value == widget.messageId) {
            _controller.stopAudio();
          }
        }
      });
    } catch (e) {
      debugPrint('Error initializing player: $e');
    }
  }

  Future<void> _togglePlay() async {
    try {
      final isCurrentPlaying =
          _controller.currentPlayingAudioId.value == widget.messageId &&
              _controller.isPlaying.value;

      if (isCurrentPlaying) {
        await _player.pause();
        _controller.pauseAudio();
      } else {
        // 如果正在播放其他音频，先停止
        if (_controller.currentPlayingAudioId.value != widget.messageId &&
            _controller.currentPlayingAudioId.value.isNotEmpty) {
          _controller.stopAudio();
        }

        // 如果是重新开始播放，先回到开始位置
        if (_position >= _duration) {
          await _player.seek(Duration.zero);
          setState(() {
            _position = Duration.zero;
          });
        }

        _controller.playAudio(widget.messageId);
        await _player.play();
      }
    } catch (e) {
      debugPrint('Error toggling play: $e');
      _controller.stopAudio();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    if (_controller.currentPlayingAudioId.value == widget.messageId) {
      _controller.stopAudio();
    }
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 定义颜色方案
    final Color primaryColor = widget.isMe ? const Color(0xFF1989FA) : const Color(0xFF1989FA);
    final Color backgroundColor = widget.isMe 
        ? const Color(0xFF1989FA).withOpacity(0.1)
        : const Color(0xFF1989FA).withOpacity(0.1);
    final Color timeColor = widget.isMe 
        ? Colors.black87
        : Colors.black87;
    final Color separatorColor = widget.isMe
        ? Colors.black38
        : Colors.black38;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      constraints: const BoxConstraints(
        minWidth: 120,
        maxWidth: 180,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            final isCurrentPlaying = _controller.currentPlayingAudioId.value == widget.messageId && 
                                   _controller.isPlaying.value;
            return IconButton(
              onPressed: _togglePlay,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              icon: Icon(
                isCurrentPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                size: 28,
                color: primaryColor,
              ),
            );
          }),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: _duration.inMilliseconds > 0
                        ? _position.inMilliseconds / _duration.inMilliseconds
                        : 0.0,
                    backgroundColor: backgroundColor,
                    valueColor: AlwaysStoppedAnimation(primaryColor),
                    minHeight: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: TextStyle(
                        fontSize: 10,
                        color: timeColor,
                      ),
                    ),
                    Text(
                      ' / ',
                      style: TextStyle(
                        fontSize: 10,
                        color: separatorColor,
                      ),
                    ),
                    Text(
                      _formatDuration(_duration),
                      style: TextStyle(
                        fontSize: 10,
                        color: timeColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
