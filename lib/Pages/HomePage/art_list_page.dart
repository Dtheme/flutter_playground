import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:wefriend_flutter/Network/RequestManager.dart';
import 'package:wefriend_flutter/Pages/HomePage/art_detail_page.dart';
import 'package:wefriend_flutter/Pages/HomePage/art_row_item.dart';
import 'package:wefriend_flutter/Pages/HomePage/image_viewer.dart';
import 'package:wefriend_flutter/Pages/HomePage/art_work.dart';
import 'waterfall_detail_page.dart';
import 'package:wefriend_flutter/Network/bussiness_api.dart';

class ArtListPage extends StatefulWidget {
  const ArtListPage({super.key});

  @override
  _ArtListPageState createState() => _ArtListPageState();
}

class _ArtListPageState extends State<ArtListPage> {
  final Dio dio = RequestManager.getInstance();
  final Logger logger = Logger();
  List<Artwork> artworks = [];
  bool isDisposed = false;
  bool isLoading = true; // 加载状态

  @override
  void initState() {
    super.initState();
    fetchArtworks();
  }

  @override
  void dispose() {
    isDisposed = true; // 标记页面已销毁
    super.dispose();
  }

  /// 请求艺术作品数据
  Future<void> fetchArtworks() async {
    try {
      await requestArtworks2(
        onSuccess: (List<Artwork> fetchedArtworks) {
          if (!isDisposed && mounted) {
            setState(() {
              artworks = fetchedArtworks;
              isLoading = false;
            });
            logger.i("请求成功: ${artworks.length} 个艺术作品");
          }
        },
        onFailure: (String errorMessage) {
          if (!isDisposed && mounted) {
            setState(() {
              isLoading = false;
            });
            logger.e("请求失败：$errorMessage");
          }
        },
      );
    } catch (e) {
      if (!isDisposed && mounted) {
        setState(() {
          isLoading = false;
        });
        logger.e("请求出错：$e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 悬浮按钮，点击跳转到瀑布流页面
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DetailWaterfallPage(),
            ),
          );
        },
        child: const Icon(Icons.line_style),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : artworks.isEmpty
              ? const Center(child: Text('没有找到任何艺术作品'))
              : ListView.builder(
                  itemCount: artworks.length,
                  itemBuilder: (context, index) {
                    var artwork = artworks[index];

                    return DRowItem(
                      image: artwork.getImageUrl(),
                      title: artwork.artistTitle ?? '无艺术家',
                      subTitle:
                          '${artwork.departmentTitle ?? '_'} • ${artwork.mediumDisplay ?? '_'} • ${artwork.dateDisplay ?? ''}',
                      onTapBtn1: () {
                        // 跳转到详情页
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
                      onImageTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (_, __, ___) =>
                                ImageViewer(imageUrl: artwork.getImageUrl()),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
