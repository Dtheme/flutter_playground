import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../Pages/VideoPage/podcast_episode.dart'; 

class AudioPlayerWidget extends StatefulWidget {
  final List<PodcastEpisode> playlist; // 更新类型为 PodcastEpisode
  final String backgroundImageUrl;
  final VoidCallback onClose;
  final int initialIndex;

  const AudioPlayerWidget({
    super.key,
    required this.playlist,
    required this.backgroundImageUrl,
    required this.onClose,
    this.initialIndex = 0,
  });

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  int _currentIndex = 0;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _currentIndex = widget.initialIndex;
    _initializePlayer();
  }

  void _initializePlayer() {
    _audioPlayer.durationStream.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration ?? Duration.zero;
        });
      }
    });

    _audioPlayer.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _playNext();
      }
    });

    if (widget.playlist.isNotEmpty) {
      _playAudio(widget.playlist[_currentIndex].audioUrl);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String url) async {
    if (url.isNotEmpty) {
      debugPrint('Playing audio from URL: $url');
      await _audioPlayer.stop();
      await _audioPlayer.setUrl(url);
      _audioPlayer.play();

      setState(() {
        _isPlaying = true;
      });
    }
  }

  Future<void> _playNext() async {
    if (widget.playlist.isNotEmpty) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.playlist.length;
      });

      await _playAudio(widget.playlist[_currentIndex].audioUrl);
    }
  }

  Future<void> _playPrevious() async {
    if (widget.playlist.isNotEmpty) {
      setState(() {
        _currentIndex = (_currentIndex - 1 + widget.playlist.length) %
            widget.playlist.length;
      });

      await _playAudio(widget.playlist[_currentIndex].audioUrl);
    }
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  Future<void> _seekForward() async {
    final newPosition = _position + const Duration(seconds: 10);
    if (newPosition < _duration) {
      _audioPlayer.seek(newPosition);
    } else {
      _audioPlayer.seek(_duration);
    }
  }

  Future<void> _seekBackward() async {
    final newPosition = _position - const Duration(seconds: 10);
    if (newPosition > Duration.zero) {
      _audioPlayer.seek(newPosition);
    } else {
      _audioPlayer.seek(Duration.zero);
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final currentTrack = widget.playlist.isNotEmpty
        ? widget.playlist[_currentIndex]
        : PodcastEpisode(
            title: '无音频',
            description: '',
            audioUrl: '',
            pubDate: '',
            duration: '',
            imageUrl: '',
          );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          if (widget.backgroundImageUrl.isNotEmpty)
            Positioned.fill(
              child: Stack(
                children: [
                  Image.network(
                    widget.backgroundImageUrl,
                    fit: BoxFit.cover,
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        currentTrack.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: widget.onClose,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbColor: Colors.white,
                          trackHeight: 2.0,
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.grey.withOpacity(0.7),
                        ),
                        child: Slider(
                          value: _position.inSeconds
                              .toDouble()
                              .clamp(0, _duration.inSeconds.toDouble()),
                          max: _duration.inSeconds.toDouble(),
                          onChanged: (value) {
                            _audioPlayer.seek(Duration(seconds: value.toInt()));
                          },
                        ),
                      ),
                    ),
                    Text(
                      _formatDuration(_duration),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous, color: Colors.white),
                      onPressed: _playPrevious,
                    ),
                    IconButton(
                      icon: const Icon(Icons.replay_10, color: Colors.white),
                      onPressed: _seekBackward,
                    ),
                    IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: _togglePlayPause,
                    ),
                    IconButton(
                      icon: const Icon(Icons.forward_10, color: Colors.white),
                      onPressed: _seekForward,
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white),
                      onPressed: _playNext,
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
