import 'package:flutter/material.dart';
import 'podcast_item.dart'; // PodcastItem 文件路径
import '/Network/bussiness_api.dart'; 
import 'podcast_model.dart';
import 'podcast_detail_page.dart'; // PodcastDetailPage 文件路径

class PodcastHomePage extends StatefulWidget {
  const PodcastHomePage({super.key});

  @override
  _PodcastHomePageState createState() => _PodcastHomePageState();
}

class _PodcastHomePageState extends State<PodcastHomePage> {
  bool hasData = false;
  bool isSearchExpanded = false;
  bool isLoading = false; // 加载状态
  String errorMessage = ''; // 错误信息
  List<PodcastModel> searchResults = [];
  TextEditingController searchController = TextEditingController();

  /// 执行搜索逻辑
  void performSearch(String keyword) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    await requestPodcasts(
      keyword: keyword,
      onSuccess: (results) {
        setState(() {
          searchResults = results
              .map((item) {
                if (item is Map<String, dynamic>) {
                  return PodcastModel.fromJson(item);
                }
                return null;
              })
              .where((item) => item != null)
              .cast<PodcastModel>()
              .toList();
          hasData = searchResults.isNotEmpty;
          isLoading = false;
        });
      },
      onFailure: (error) {
        setState(() {
          searchResults = [];
          hasData = false;
          isLoading = false;
          errorMessage = error;
        });
        print("搜索失败：$error");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        // 点击空白区域收起搜索框
        onTap: () {
          if (isSearchExpanded) {
            setState(() {
              isSearchExpanded = false;
            });
            // 关闭键盘
            FocusScope.of(context).requestFocus(FocusNode());
          }
        },
        child: Stack(
          children: [
            // 显示加载状态
            if (isLoading)
              const Center(child: CircularProgressIndicator()), // 显示加载动画
            // 显示错误信息
            if (!isLoading && errorMessage.isNotEmpty)
              Center(
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            // 显示搜索结果
            if (!isLoading && hasData)
              ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final PodcastModel item = searchResults[index];
                  return PodcastItem(
                    podcast: item,
                    feedUrl: item.feedUrl, // 传递 feedUrl
                    itemOnTap: () {
                      debugPrint('点击了第 $index 个播客: ${item.feedUrl}');
                      if (!isSearchExpanded) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PodcastDetailPage(feedUrl: item.feedUrl),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            // 如果没有数据，显示占位符
            if (!isLoading && !hasData && errorMessage.isEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.podcasts,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '搜索你感兴趣的播客',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            // 搜索框展示
            if (isSearchExpanded)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Material(
                  color: Colors.white.withOpacity(0), // 半透明背景
                  child: Column(
                    children: [
                      // 透明背景的 Container
                      Container(
                        color: Colors.white.withOpacity(0), // 透明背景的搜索框
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          style: const TextStyle(color: Colors.black), // 文字颜色黑色
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: '搜索感兴趣的播客',
                            hintStyle: TextStyle(color: Colors.grey), // 提示文字颜色
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                searchController.clear();
                                setState(() {
                                  isSearchExpanded = false;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.white, // TextField背景颜色为白色
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              performSearch(value); // 执行搜索逻辑
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isSearchExpanded = !isSearchExpanded;
          });
        },
        child: Icon(isSearchExpanded ? Icons.close : Icons.search),
      ),
    );
  }
}
