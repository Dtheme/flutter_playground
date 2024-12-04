import 'dart:async';
import 'dart:convert';
import 'package:flutter_nb_net/flutter_net.dart';
import '../Pages/VideoPage/media_model.dart';
import '/Pages/HomePage/art_work.dart';
import 'package:wefriend_flutter/Util/global.dart';
import 'BannerModel.dart';
import '/Network/request_url_const.dart';
import '/Util/XmlToJsonConverter.dart';
import '../Pages/VideoPage/podcast_episode.dart';

/// Banner 请求示例
void requestGet() async {
  var appResponse = await get(bannerJsonUrl);
  appResponse.when(success: (dynamic data) {
    logger.t("成功返回$data");
  }, failure: (String msg, int code) {
    logger.t("失败了：msg=$msg/code=$code");
  });
}
 
/// Banner 请求示例，完整的泛型
void requestGet2() async {
  var appResponse = await get<BannerModel, BannerModel>(
    bannerJsonUrl,
    decodeType: BannerModel(),
  );

  appResponse.when(success: (BannerModel model) {
    var size = model.data?.length;
    logger.t("成功返回$size条");
  }, failure: (String msg, int code) {
    //打印带上请求完整的 URL
    // logger.t("失败了：msg=$msg/code=$code");
  });
}

/// 获取艺术作品列表的 Get 请求，支持异步回调
Future<void> requestArtworks({
  required Function(List<Artwork> artworks) onSuccess,
  required Function(String errorMessage, int errorCode) onFailure,
}) async {
  const String artworkUrl = "api/v1/artworks";

  var appResponse = await get<List, List<Artwork>>(
    artworkUrl,
    options: Options(
      extra: {'baseUrl': GlobalConfig.artEduUrl}, // 使用动态 Base URL
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
    decodeType: [], // 指定返回类型为 List
  );

  appResponse.when(
    success: (List data) {
      try {
        List<Artwork> artworks =
            data.map((json) => Artwork.fromJson(json)).toList();
        onSuccess(artworks);
        logger.t("请求成功: ${artworks.length} 个艺术作品");
      } catch (e) {
        onFailure("数据解析错误：$e", 500);
        logger.t("数据解析失败：$e");
      }
    },
    failure: (String msg, int code) {
      onFailure(msg, code);
      logger.t("请求失败：msg=$msg/code=$code");
    },
  );
}

Future<void> requestArtworks2({
  required Function(List<Artwork>) onSuccess,
  required Function(String errorMessage) onFailure,
}) async {
  try {
    var appResponse = await get<Map<String, dynamic>, Map<String, dynamic>>(
      artWorkListUrl,
      decodeType: {}, // 指定返回类型为 Map<String, dynamic>
    );

    appResponse.when(
      success: (Map<String, dynamic> response) {
        try {
          var dataList = response['data'] as List<dynamic>;
          List<Artwork> artworks = dataList.map((item) {
            return Artwork.fromJson(item as Map<String, dynamic>);
          }).toList();
          onSuccess(artworks);
        } catch (e) {
          onFailure("数据解析失败：$e");
        }
      },
      failure: (String msg, int code) {
        onFailure("请求失败：msg=$msg/code=$code");
      },
    );
  } catch (e) {
    onFailure("请求发生异常：$e");
  }
}

Future<void> fetchArtworkDetail({
  required String apiLink, // API 链接，从外部传入
  required Function(
          Map<String, dynamic> artworkDetail, Map<String, dynamic> licenseInfo)
      onSuccess,
  required Function(String errorMessage) onFailure,
}) async {
  try {
    // 使用封装的 get 方法请求数据
    var appResponse = await get<Map<String, dynamic>, Map<String, dynamic>>(
      apiLink,
      options: Options(
        extra: {'baseUrl': GlobalConfig.testBaseUrl}, // 动态设置 Base URL
      ),
    );

    // 根据请求结果处理逻辑
    appResponse.when(
      success: (response) {
        try {
          // 提取数据并回调成功逻辑
          var data = response['data'] as Map<String, dynamic>;
          var info = response['info'] as Map<String, dynamic>;
          onSuccess(data, info);
        } catch (e) {
          onFailure("数据解析失败：$e");
        }
      },
      failure: (String msg, int code) {
        // 回调失败逻辑
        onFailure("请求失败：$msg，状态码：$code");
      },
    );
  } catch (e) {
    // 捕获异常并回调失败
    onFailure("请求异常：$e");
  }
}

/// 请求精选内容
Future<void> requestSelectedTabs({
  required Function(List<MediaModel> mediaList) onSuccess,
  required Function(String errorMessage, int errorCode) onFailure,
}) async {
  const String selectedTabsUrl =
      "http://baobab.kaiyanapp.com/api/v4/tabs/selected";

  var appResponse = await Dio().get<Map<String, dynamic>>(selectedTabsUrl,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));

  try {
    // 检查响应数据
    if (appResponse.statusCode == 200 && appResponse.data != null) {
      // 提取 JSON 中的内容部分，例如 "itemList" 是你感兴趣的内容数组
      final List<dynamic> items = appResponse.data!['itemList'] ?? [];

      // 使用 MediaModel 解析数据
      final List<MediaModel> mediaList = items
          .where((item) => item['type'] == 'video') // 过滤出视频类型的项目
          .map((item) => MediaModel.fromJson(item['data'])) // 解析数据
          .toList();

      // 调用成功回调并返回解析后的数据
      onSuccess(mediaList);
    } else {
      // 状态码不是 200 或数据为空时调用失败回调
      onFailure("请求失败：无效响应", appResponse.statusCode ?? 500);
    }
  } catch (e) {
    // 捕获解析错误并调用失败回调
    onFailure("数据解析失败：$e", 500);
  }
}

/// 请求 iTunes 播客数据
Future<void> requestPodcasts({
  required String keyword,
  required Function(List<dynamic> searchResults) onSuccess,
  required Function(String errorMessage) onFailure,
}) async {
  if (keyword.isEmpty) {
    onFailure("关键词不能为空");
    return;
  }

  final String searchUrl = "https://itunes.apple.com/search?term=${Uri.encodeComponent(keyword)}&media=podcast";

  try {
    // 使用封装的 get 方法请求数据
    var appResponse = await get<dynamic, dynamic>(
      searchUrl,
    );

    // 处理响应
    appResponse.when(
      success: (response) {
        try {
          // 如果响应是字符串，尝试将其解析为 JSON
          if (response is String) {
            final Map<String, dynamic> jsonResponse = json.decode(response);
            if (jsonResponse.containsKey('results') && jsonResponse['results'] is List) {
              onSuccess(jsonResponse['results']);
            } else {
              onFailure("响应中缺少 'results' 字段或数据格式不正确");
            }
          } else if (response is Map<String, dynamic>) {
            // 如果响应已经是 Map 类型，直接解析
            if (response.containsKey('results') && response['results'] is List) {
              onSuccess(response['results']);
            } else {
              onFailure("响应中缺少 'results' 字段或数据格式不正确");
            }
          } else {
            onFailure("未知的响应类型：${response.runtimeType}");
          }
        } catch (e) {
          onFailure("数据解析失败：$e");
        }
      },
      failure: (String msg, int code) {
        onFailure("请求失败：$msg，状态码：$code");
      },
    );
  } catch (e) {
    onFailure("请求发生异常：$e");
  }
}
// todo：未完成 请求播客详情
Future<void> fetchPodcastDetails2({
  required String podcastDetailUrl,
  required Function(List<PodcastEpisode> episodes) onSuccess,
  required Function(String errorMessage, int errorCode) onFailure,
}) async {
  try {
    var appResponse = await get<String, String>(
      podcastDetailUrl,
      options: Options(
        headers: {
          'Content-Type': 'application/xml',
          'Accept': 'application/xml',
        },
      ),
    );

    appResponse.when(
      success: (String responseBody) {
        final jsonData = XmlToJsonConverter.convert(responseBody);
        final episodes = _parseEpisodes(jsonData);
        onSuccess(episodes);
      },
      failure: (String msg, int code) {
        onFailure("请求失败：$msg", code);
      },
    );
  } catch (e) {
    onFailure("请求发生异常：$e", 500);
  }
}

List<PodcastEpisode> _parseEpisodes(Map<String, dynamic> data) {
  final items = data['channel']?['item'];
  if (items is List) {
    return items.map<PodcastEpisode>((item) {
      return PodcastEpisode.fromJson(item);
    }).toList();
  }
  return [];
}