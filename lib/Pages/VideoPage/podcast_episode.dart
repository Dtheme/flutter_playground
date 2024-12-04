import 'package:flutter/material.dart';

class PodcastEpisode {
  final String title;
  final String description;
  final String audioUrl;
  final String pubDate;
  final String duration;
  final String imageUrl;

  PodcastEpisode({
    required this.title,
    required this.description,
    required this.audioUrl,
    required this.pubDate,
    required this.duration,
    required this.imageUrl,
  });

  factory PodcastEpisode.fromJson(Map<String, dynamic> json) {
    debugPrint('Parsing PodcastEpisode from JSON: $json');

    final title = _extractString(json, 'title');
    final description = _extractString(json, 'description');
    final pubDate = _extractString(json, 'pubDate');

    debugPrint('Parsed title: $title');
    debugPrint('Parsed description: $description');
    debugPrint('Parsed pubDate: $pubDate');

    return PodcastEpisode(
      title: title ?? '无标题',
      description: description ?? '无描述',
      audioUrl: json['enclosure']?['@attributes']?['url'] ?? '',
      pubDate: pubDate ?? '',
      duration: json['itunes:duration'] ?? '',
      imageUrl: json['itunes:image']?['@attributes']?['href'] ?? '',
    );
  }

  static String? _extractString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is String) {
      return value;
    } else if (value is Map) {
      if (value.containsKey('#text')) {
        return value['#text'] as String?;
      } else if (value.containsKey('#cdata')) {
        return value['#cdata'] as String?;
      }
    }
    debugPrint('Unable to parse $key: $value');
    return null;
  }
}
