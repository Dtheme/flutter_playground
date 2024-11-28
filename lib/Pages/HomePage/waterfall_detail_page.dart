import 'package:flutter/material.dart';
import 'art_item.dart';
import 'art_detail_page.dart';
import '/UIKit/waterfall/waterfall_flow_view.dart';
import '/Network/bussiness_api.dart';
import 'art_work.dart'; // Artwork 类所在的文件

class DetailWaterfallPage extends StatefulWidget {
  const DetailWaterfallPage({super.key});

  @override
  _DetailWaterfallPageState createState() => _DetailWaterfallPageState();
}

class _DetailWaterfallPageState extends State<DetailWaterfallPage> {
  List<Artwork> artworks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchArtworksData();
  }

  /// 使用封装的 requestArtworks2 请求数据
  void fetchArtworksData() {
    requestArtworks2(
      onSuccess: (List<Artwork> fetchedArtworks) {
        if (mounted) {
          setState(() {
            artworks = fetchedArtworks;
            isLoading = false;
          });
        }
      },
      onFailure: (String errorMessage) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          debugPrint("请求失败：$errorMessage");
        }
      },
    );
  }

  Color _getShadowColor(Map<String, dynamic>? color) {
    if (color == null) {
      return Colors.black12;
    }
    double opacity = 0.2; // 设置阴影的透明度为 0.2
    int red = (color['h'] ?? 0) * 2; // 模拟颜色值
    int green = (color['s'] ?? 0) * 2;
    int blue = (color['l'] ?? 0) * 2;
    return Color.fromRGBO(red, green, blue, opacity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('作品色彩')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : artworks.isEmpty
              ? const Center(child: Text('暂无数据'))
              : WaterfallFlowView(
                  children: artworks.map((artwork) {
                    Color shadowColor = _getShadowColor(artwork.color);

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ArtItem(
                        imageUrl: artwork.imageId ?? '',
                        artistTitle: artwork.artistTitle ?? '未知艺术家',
                        dateDisplay: artwork.dateDisplay ?? '无日期信息',
                        classificationTitles: artwork.classificationTitles ?? [],
                        colorData: artwork.color,
                        colorfulness: artwork.colorfulness ?? 0.0,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArtDetailPage(
                                pageTitle: artwork.artistTitle ?? '展览详情',
                                apiLink: artwork.apiLink ?? '',
                                artImageId: artwork.imageId ?? '',
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
    );
  }
}
