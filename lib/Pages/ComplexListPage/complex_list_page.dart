import 'package:flutter/material.dart';
import 'package:wefriend_flutter/Pages/HomePage/art_list_page.dart';
import 'package:wefriend_flutter/Pages/DrawerPage/area_list_page.dart';
import 'package:wefriend_flutter/Pages/HomePage/waterfall_detail_page.dart';
import 'im_chat_ui_page.dart';

class ComplexListPage extends StatelessWidget {
  const ComplexListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2, // 每行两个方块
        children: [
          _buildGridItem(context, '单层列表', Icons.art_track, ArtListPage()),
          _buildGridItem(
              context, '双层列表', Icons.location_city, AreaListPage()),
          _buildGridItem(context, '瀑布流列表', Icons.waterfall_chart,
              DetailWaterfallPage()),
          _buildGridItem(context, 'IM列表', Icons.chat_rounded,
              ImChatUIPage()),
        ],
      ),
    );
  }

  Widget _buildGridItem(
      BuildContext context, String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50.0),
              const SizedBox(height: 10.0),
              Text(title, style: const TextStyle(fontSize: 16.0)),
            ],
          ),
        ),
      ),
    );
  }
}
