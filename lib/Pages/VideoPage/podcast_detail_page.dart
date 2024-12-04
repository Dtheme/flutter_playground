import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import '/Util/XmlToJsonConverter.dart';
import '../../UIKit/AudioPlayer/audio_player_widget.dart';
import 'podcast_episode.dart';
import 'podcast_episode_item.dart';

class PodcastDetailPage extends StatefulWidget {
  final String feedUrl;

  const PodcastDetailPage({super.key, required this.feedUrl});

  @override
  _PodcastDetailPageState createState() => _PodcastDetailPageState();
}

class _PodcastDetailPageState extends State<PodcastDetailPage> {
  bool isLoading = true;
  String errorMessage = '';
  Map<String, dynamic>? podcastData;
  late AudioPlayer _audioPlayer;
  OverlayEntry? _playerOverlayEntry;
  int _currentPlayingIndex = -1;
  int _expandedIndex = -1; // 当前展开的索引

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    fetchPodcastDetails();
  }

  Future<void> fetchPodcastDetails() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(Uri.parse(widget.feedUrl));
      if (response.statusCode == 200) {
        final jsonData = XmlToJsonConverter.convert(response.body);
        setState(() {
          podcastData = jsonData;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'HTTP 错误：${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = '加载失败: $e';
        isLoading = false;
      });
    }
  }

  void _showPlayer(int index) {
    setState(() {
      _currentPlayingIndex = index;
      _expandedIndex = index; // 展开当前播放的集数
    });

    final episode = _getEpisodes()[index];
    final audioUrl = _getAudioUrlForEpisode(episode);

    if (audioUrl.isNotEmpty) {
      _audioPlayer.setUrl(audioUrl);
      _audioPlayer.play();

      if (_playerOverlayEntry != null) {
        _removePlayerOverlay();
      }

      _playerOverlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: AudioPlayerWidget(
              playlist: _getEpisodes()
                  .map((e) => PodcastEpisode.fromJson(e))
                  .toList(),
              backgroundImageUrl: _getImageUrl(),
              initialIndex: index,
              onClose: () {
                _audioPlayer.stop();
                _removePlayerOverlay();
                setState(() {
                  _currentPlayingIndex = -1; // 停止播放后重置
                });
              },
            ),
          ),
        ),
      );

      Overlay.of(context).insert(_playerOverlayEntry!);
    } else {
      debugPrint('没有找到音频链接');
    }
  }

  void _removePlayerOverlay() {
    _playerOverlayEntry?.remove();
    _playerOverlayEntry = null;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _removePlayerOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView(
                  children: [
                    // 播客标题
                    Text(
                      _getTitle(),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    // 播客封面图
                    Image.network(
                      _getImageUrl(),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10),

                    // 播客描述
                    Text(
                      _getDescription(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),

                    // 节目列表标题
                    const Text('节目列表', style: TextStyle(fontSize: 22)),
                    const SizedBox(height: 10),

                    // 显示节目列表
                    ...List.generate(
                      _getEpisodes().length,
                      (index) {
                        final episode = _getEpisodes()[index];
                        return PodcastEpisodeItem(
                          key: ValueKey(index), // 为每个项提供唯一的 Key
                          episode: PodcastEpisode.fromJson(episode),
                          isPlaying: _currentPlayingIndex == index,
                          isExpanded: _expandedIndex == index,
                          onPlay: () => _showPlayer(index),
                          onExpand: () {
                            setState(() {
                              _expandedIndex = index;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
    );
  }

  String _getTitle() {
    final title = podcastData?['channel']?['title'];
    if (title is Map && title.containsKey('#text')) {
      return title['#text'] ?? '无标题';
    }
    return '无标题';
  }

  String _getDescription() {
    final description = podcastData?['channel']?['description'];
    if (description is Map && description.containsKey('#text')) {
      return description['#text'] ?? '无描述';
    }
    return '无描述';
  }

  String _getImageUrl() {
    final image = podcastData?['channel']?['image']?['@attributes']?['href'];
    return image ?? '';
  }

  List<Map<String, dynamic>> _getEpisodes() {
    final items = podcastData?['channel']?['item'];
    if (items is List) {
      return List<Map<String, dynamic>>.from(items);
    }
    return [];
  }

  String _getTitleForEpisode(Map<String, dynamic> episode) {
    final title = episode['title'];
    if (title is Map) {
      if (title.containsKey('#text')) {
        return title['#text'] ?? '无标题';
      } else if (title.containsKey('#cdata')) {
        return title['#cdata'] ?? '无标题';
      }
    } else if (title is String) {
      return title;
    }
    return '无标题';
  }

  String _getDescriptionForEpisode(Map<String, dynamic> episode) {
    final description = episode['description'];
    if (description is Map) {
      if (description.containsKey('#text')) {
        return description['#text'] ?? '无描述';
      } else if (description.containsKey('#cdata')) {
        return description['#cdata'] ?? '无描述';
      }
    } else if (description is String) {
      return description;
    }
    return '无描述';
  }

  String _getAudioUrlForEpisode(Map<String, dynamic> episode) {
    final audioUrl = episode['enclosure']?['@attributes']?['url'];
    return audioUrl ?? '';
  }
}
