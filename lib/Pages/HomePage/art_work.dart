import 'dart:ui';

import 'package:flutter/material.dart';

class Artwork {
  final String? artistTitle; // 艺术家名称
  final String? departmentTitle; // 部门标题
  final String? mediumDisplay; // 介质信息
  final String? dateDisplay; // 日期显示
  final String? imageId; // 图片 ID
  final String? apiLink; // API 链接
  final double? colorfulness; // 色彩饱和度
  final Map<String, dynamic>? color; // 色彩信息
  final List<String>? classificationTitles; // 分类标题
  final String? title; // 作品标题
  final String? dimensions; // 尺寸信息
  final String? description; // 作品描述
  final String? creditLine; // 致谢信息
  final List<Map<String, dynamic>>? dimensionsDetail; // 详细尺寸

  Artwork({
    this.artistTitle,
    this.departmentTitle,
    this.mediumDisplay,
    this.dateDisplay,
    this.imageId,
    this.apiLink,
    this.colorfulness,
    this.color,
    this.classificationTitles,
    this.title,
    this.dimensions,
    this.description,
    this.creditLine,
    this.dimensionsDetail,
  });

  // 从 JSON 创建对象
  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      artistTitle: json['artist_title'] as String?,
      departmentTitle: json['department_title'] as String?,
      mediumDisplay: json['medium_display'] as String?,
      dateDisplay: json['date_display'] as String?,
      imageId: json['image_id'] as String?,
      apiLink: json['api_link'] as String?,
      colorfulness: (json['colorfulness'] as num?)?.toDouble(),
      color: json['color'] as Map<String, dynamic>?,
      classificationTitles: (json['classification_titles'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList(),
      title: json['title'] as String?,
      dimensions: json['dimensions'] as String?,
      description: json['description'] as String?,
      creditLine: json['credit_line'] as String?,
      dimensionsDetail: (json['dimensions_detail'] as List<dynamic>?)
          ?.map((item) => item as Map<String, dynamic>)
          .toList(),
    );
  }

  // 将对象转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'artist_title': artistTitle,
      'department_title': departmentTitle,
      'medium_display': mediumDisplay,
      'date_display': dateDisplay,
      'image_id': imageId,
      'api_link': apiLink,
      'colorfulness': colorfulness,
      'color': color,
      'classification_titles': classificationTitles,
      'title': title,
      'dimensions': dimensions,
      'description': description,
      'credit_line': creditLine,
      'dimensions_detail': dimensionsDetail,
    };
  }

  // 获取图片完整 URL
  String getImageUrl() {
    if (imageId == null) {
      return ''; 
    }
    return "https://www.artic.edu/iiif/2/$imageId/full/843,/0/default.jpg";
  }

  // 获取色块颜色
  Color getColorBlock() {
    if (color == null) {
      return Colors.grey; // 默认色块
    }
    final h = (color?['h'] ?? 0).toDouble();
    final l = (color?['l'] ?? 0).toDouble() / 100;
    final s = (color?['s'] ?? 0).toDouble() / 100;
    return HSLColor.fromAHSL(1.0, h, s, l).toColor();
  }
}
