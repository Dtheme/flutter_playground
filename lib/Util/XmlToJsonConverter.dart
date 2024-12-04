import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

class XmlToJsonConverter {
  /// 将 XML 字符串转换为 JSON 对象
  static Map<String, dynamic> convert(String xmlString) {
    try {
      final document = XmlDocument.parse(xmlString);
      return _convertXmlElementToMap(document.rootElement);
    } catch (e) {
      throw Exception('XML 解析失败: $e');
    }
  }

  /// 将 JSON 对象转换为 JSON 字符串
  static String convertToJsonString(String xmlString) {
    final jsonObject = convert(xmlString);
    return jsonEncode(jsonObject);
  }

  /// 递归转换 XML 节点为 Map
  static Map<String, dynamic> _convertXmlElementToMap(XmlElement element) {
    final Map<String, dynamic> result = {};

    // 打印当前处理的 XML 元素
    debugPrint('Processing element: ${element.name.local}');

    // 处理属性
    if (element.attributes.isNotEmpty) {
      result['@attributes'] = {
        for (final attribute in element.attributes)
          attribute.name.local: attribute.value,
      };
    }

    // 处理子节点
    if (element.children.isNotEmpty) {
      for (final child in element.children) {
        if (child is XmlElement) {
          final key = child.name.local;
          final value = _convertXmlElementToMap(child);

          // 打印子节点的键和值
          debugPrint('Child element key: $key, value: $value');

          if (result.containsKey(key)) {
            if (result[key] is List) {
              (result[key] as List).add(value);
            } else {
              result[key] = [result[key], value];
            }
          } else {
            result[key] = value;
          }
        } else if (child is XmlText && child.text.trim().isNotEmpty) {
          final textValue = child.text.trim();
          if (result.containsKey('#text')) {
            result['#text'] = '${result['#text']} $textValue';
          } else {
            result['#text'] = textValue;
          }
        } else if (child is XmlCDATA) {
          result['#cdata'] = child.text.trim();
        }
      }
    }

    return _cleanEmptyFields(result);
  }

  /// 清理空字段（{} 或 []）
  static Map<String, dynamic> _cleanEmptyFields(Map<String, dynamic> result) {
    result.removeWhere((key, value) =>
        value is Map && value.isEmpty || value is List && value.isEmpty);

    // 处理特殊字段，如果有必要可以自定义处理逻辑
    if (result.containsKey('title') && result['title'] is List) {
      // title 字段可能是空的 List
      result['title'] = result['title'].isEmpty ? '无标题' : result['title'][0]['#text'] ?? '无标题';
    }

    if (result.containsKey('description') && result['description'] is List) {
      // description 字段可能是空的 List
      result['description'] = result['description'].isEmpty ? '无描述' : result['description'][0]['#text'] ?? '无描述';
    }

    // 在 item 数组中处理每个元素
    if (result.containsKey('item') && result['item'] is List) {
      for (var item in result['item']) {
        if (item is Map) {
          if (item.containsKey('title') && item['title'] is List) {
            item['title'] = item['title'].isEmpty ? '无标题' : item['title'][0]['#text'] ?? '无标题';
          }

          if (item.containsKey('description') && item['description'] is List) {
            item['description'] = item['description'].isEmpty ? '无描述' : item['description'][0]['#text'] ?? '无描述';
          }

          if (item.containsKey('enclosure') && item['enclosure'] is Map) {
            final enclosure = item['enclosure'];
            if (enclosure.containsKey('@attributes') && enclosure['@attributes'] is Map) {
              item['audioUrl'] = enclosure['@attributes']['url'];
            }
          }
        }
      }
    }

    return result;
  }
}
