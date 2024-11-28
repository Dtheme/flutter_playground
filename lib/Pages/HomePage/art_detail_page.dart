import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import '/Network/bussiness_api.dart';
import 'image_viewer.dart'; // 导入 ImageViewer 文件

class ArtDetailPage extends StatefulWidget {
  final String apiLink;
  final String pageTitle;
  final String artImageId;

  const ArtDetailPage({
    super.key,
    required this.apiLink,
    required this.pageTitle,
    required this.artImageId,
  });

  @override
  _ArtDetailPageState createState() => _ArtDetailPageState();
}

class _ArtDetailPageState extends State<ArtDetailPage> {
  Map<String, dynamic>? artworkDetail;
  Map<String, dynamic>? licenseInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // 请求详情数据
    fetchArtworkDetail(
      apiLink: widget.apiLink,
      onSuccess: (Map<String, dynamic> fetchedArtworkDetail,
          Map<String, dynamic> fetchedLicenseInfo) {
        if (mounted) {
          setState(() {
            artworkDetail = fetchedArtworkDetail;
            licenseInfo = fetchedLicenseInfo;
            isLoading = false; // 取消加载状态
          });
        }
      },
      onFailure: (String errorMessage) {
        if (mounted) {
          setState(() {
            isLoading = false; // 取消加载状态
          });
          debugPrint("请求失败：$errorMessage");
        }
      },
    );
  }

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("无法打开链接: $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : artworkDetail == null
              ? const Center(child: Text('加载失败，请重试'))
              : Stack(
                  children: [
                    // 背景图片
                    Positioned.fill(
                      child: Image.network(
                        "https://www.artic.edu/iiif/2/${widget.artImageId}/full/843,/0/default.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),

                    // 高斯模糊效果
                    Positioned.fill(
                      child: BackdropFilter(
                        filter:
                            ImageFilter.blur(sigmaX: 10, sigmaY: 10), // 高斯模糊参数
                        child: Container(
                          color: Colors.black.withOpacity(0.5), // 添加半透明遮罩
                        ),
                      ),
                    ),

                    // 内容区域
                    CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          expandedHeight: 300,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                            title: Text(widget.pageTitle),
                            background: GestureDetector(
                              onTap: () {
                                // 点击打开大图
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ImageViewer(
                                      imageUrl:
                                          "https://www.artic.edu/iiif/2/${widget.artImageId}/full/843,/0/default.jpg",
                                    ),
                                  ),
                                );
                              },
                              child: Image.network(
                                "https://www.artic.edu/iiif/2/${widget.artImageId}/full/843,/0/default.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  artworkDetail!['title'] ?? 'Untitled',
                                  style: const TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  artworkDetail!['artist_display'] ?? '暂无艺术家信息',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Place of Origin: ${artworkDetail!['place_of_origin'] ?? '无起源地'}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Html(
                                  data: artworkDetail!['description'] ??
                                      '<p>无描述信息</p>',
                                  style: {
                                    "p": Style(
                                      fontSize: FontSize(16.0),
                                      lineHeight: const LineHeight(1.5),
                                      color: Colors.white, // 设置段落文字为白色
                                    ),
                                    "a": Style(
                                      color: Colors.blueAccent, // 设置链接文字为蓝色
                                      textDecoration: TextDecoration.underline,
                                    ),
                                  },
                                  onAnchorTap: (url, attributes, element) {
                                    _launchUrl(url ?? "");
                                  },
                                ),
                                const SizedBox(height: 20),
                                if (licenseInfo != null) ...[
                                  const Divider(),
                                  Text(
                                    licenseInfo!['license_text'] ?? '无许可证信息',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 10.0,
                                    children: (licenseInfo!['license_links']
                                            as List<dynamic>)
                                        .map((link) => GestureDetector(
                                              onTap: () => _launchUrl(link),
                                              child: Text(
                                                link,
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Version: ${licenseInfo!['version'] ?? '未知'}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }
}
