import 'package:flutter/material.dart';
import 'package:wefriend_flutter/Pages/VideoPage/media_model.dart';
import '/Network/bussiness_api.dart';
import 'media_item.dart';

class VideoHomePage extends StatefulWidget {
  const VideoHomePage({super.key});

  @override
  _VideoHomePageState createState() => _VideoHomePageState();
}

class _VideoHomePageState extends State<VideoHomePage> {
  List<MediaModel> _mediaList = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchSelectedTabs();
  }

  Future<void> _fetchSelectedTabs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    requestSelectedTabs(
      onSuccess: (List<MediaModel> mediaList) {
        if (mounted) {
          setState(() {
            _mediaList = mediaList;
            _isLoading = false;
          });
        }
      },
      onFailure: (String errorMessage, int errorCode) {
        if (mounted) {
          setState(() {
            _errorMessage = "$errorMessage (状态码: $errorCode)";
            _isLoading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _mediaList.isEmpty
                  ? const Center(child: Text('没有视频数据'))
                  : ListView.builder(
                      itemCount: _mediaList.length,
                      itemBuilder: (context, index) {
                        final media = _mediaList[index];
                        return MediaItem(media: media); // 使用封装的 MediaItem
                      },
                    ),
    );
  }
}
