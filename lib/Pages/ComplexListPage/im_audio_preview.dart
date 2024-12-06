import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ImAudioPreview extends StatefulWidget {
  final String audioPath;
  final VoidCallback? onDelete;
  final Function(String)? onSend;

  const ImAudioPreview({
    super.key,
    required this.audioPath,
    this.onDelete,
    this.onSend,
  });

  @override
  _ImAudioPreviewState createState() => _ImAudioPreviewState();
}

class _ImAudioPreviewState extends State<ImAudioPreview> {
  final _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isCompleted = false;
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
      
      _player.positionStream.listen((position) {
        if (mounted) {
          setState(() {
            _position = position;
            if (_position >= _duration) {
              _isCompleted = true;
              _isPlaying = false;
            }
          });
        }
      });

      _player.playerStateStream.listen((state) {
        if (!mounted) return;
        
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            _isPlaying = false;
            _isCompleted = true;
            _position = _duration;
          });
          _player.stop();
        } else {
          setState(() {
            _isPlaying = state.playing;
            if (state.playing) {
              _isCompleted = false;
            }
          });
        }
      });
    } catch (e) {
      debugPrint('Error initializing player: $e');
    }
  }

  Future<void> _togglePlay() async {
    try {
      if (_isPlaying) {
        await _player.pause();
      } else {
        if (_isCompleted || _position >= _duration) {
          await _player.seek(Duration.zero);
          setState(() {
            _isCompleted = false;
            _position = Duration.zero;
          });
        }
        await _player.play();
      }
    } catch (e) {
      debugPrint('Error toggling play: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                _formatDuration(_position),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2.0,
                    thumbShape: SliderComponentShape.noThumb,
                    overlayShape: SliderComponentShape.noOverlay,
                    activeTrackColor: Colors.blue[300],
                    inactiveTrackColor: Colors.grey[300],
                  ),
                  child: Slider(
                    value: _position.inSeconds.toDouble(),
                    max: _duration.inSeconds.toDouble(),
                    onChanged: null,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDuration(_duration),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  size: 40,
                  color: Colors.blue,
                ),
                onPressed: _togglePlay,
              ),
              IconButton(
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 32,
                  color: Colors.grey,
                ),
                onPressed: () {
                  _player.stop();
                  widget.onDelete?.call();
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.send_rounded,
                  size: 32,
                  color: Colors.green,
                ),
                onPressed: () {
                  _player.stop();
                  widget.onSend?.call(widget.audioPath);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
} 