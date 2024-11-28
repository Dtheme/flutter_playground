import 'dart:ui';
import 'package:flutter/material.dart';

class MediaModel {
  final int id;
  final String title;
  final String description;
  final String library;
  final List<Tag> tags;
  final Consumption consumption;
  final String resourceType;
  final String category;
  final Author author;
  final Cover cover;
  final String playUrl;
  final int duration;
  final WebUrl webUrl;
  final int releaseTime;
  final String providerName;
  final String providerIcon;

  MediaModel({
    required this.id,
    required this.title,
    required this.description,
    required this.library,
    required this.tags,
    required this.consumption,
    required this.resourceType,
    required this.category,
    required this.author,
    required this.cover,
    required this.playUrl,
    required this.duration,
    required this.webUrl,
    required this.releaseTime,
    required this.providerName,
    required this.providerIcon,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      library: json['library'],
      tags: (json['tags'] as List).map((tag) => Tag.fromJson(tag)).toList(),
      consumption: Consumption.fromJson(json['consumption']),
      resourceType: json['resourceType'],
      category: json['category'],
      author: Author.fromJson(json['author']),
      cover: Cover.fromJson(json['cover']),
      playUrl: json['playUrl'],
      duration: json['duration'],
      webUrl: WebUrl.fromJson(json['webUrl']),
      releaseTime: json['releaseTime'],
      providerName: json['provider']['name'],
      providerIcon: json['provider']['icon'],
    );
  }
}

class Tag {
  final int id;
  final String name;
  final String? actionUrl;
  final String bgPicture;
  final String headerImage;

  Tag({
    required this.id,
    required this.name,
    this.actionUrl,
    required this.bgPicture,
    required this.headerImage,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
      actionUrl: json['actionUrl'],
      bgPicture: json['bgPicture'],
      headerImage: json['headerImage'],
    );
  }
}

class Consumption {
  final int collectionCount;
  final int shareCount;
  final int replyCount;

  Consumption({
    required this.collectionCount,
    required this.shareCount,
    required this.replyCount,
  });

  factory Consumption.fromJson(Map<String, dynamic> json) {
    return Consumption(
      collectionCount: json['collectionCount'],
      shareCount: json['shareCount'],
      replyCount: json['replyCount'],
    );
  }
}

class Author {
  final int id;
  final String icon;
  final String name;
  final String description;
  final int videoNum;

  Author({
    required this.id,
    required this.icon,
    required this.name,
    required this.description,
    required this.videoNum,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      icon: json['icon'],
      name: json['name'],
      description: json['description'],
      videoNum: json['videoNum'],
    );
  }
}

class Cover {
  final String feed;
  final String detail;
  final String? blurred;

  Cover({
    required this.feed,
    required this.detail,
    this.blurred,
  });

  factory Cover.fromJson(Map<String, dynamic> json) {
    return Cover(
      feed: json['feed'],
      detail: json['detail'],
      blurred: json['blurred'],
    );
  }
}

class WebUrl {
  final String raw;
  final String forWeibo;

  WebUrl({
    required this.raw,
    required this.forWeibo,
  });

  factory WebUrl.fromJson(Map<String, dynamic> json) {
    return WebUrl(
      raw: json['raw'],
      forWeibo: json['forWeibo'],
    );
  }
}
