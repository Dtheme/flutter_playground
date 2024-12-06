import 'package:flutter/material.dart';
import 'package:wefriend_flutter/Pages/Basepages/BaiscPage.dart';
import 'package:wefriend_flutter/Pages/VideoPage/podcast_home_page.dart';
import 'package:wefriend_flutter/Pages/VideoPage/video_home_page.dart';
import 'animate_page.dart';
import '../DrawerPage/DrawerPage.dart';
import '../DrawerPage/layoutDemo.dart';
import '../ExplorePage/ExplorePage.dart';
import '../ExtraPage/RequestPage.dart';
import 'particle_page.dart';
import 'package:wefriend_flutter/Pages/ComplexListPage/complex_list_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const HomeTabbar();
  }
}

class HomeTabbar extends StatefulWidget {
  const HomeTabbar({
    super.key,
  });

  @override
  State<HomeTabbar> createState() => _HomeTabbarState();
}

class _HomeTabbarState extends State<HomeTabbar> {
  final _pageController = PageController();
  int _tabCurrentIndex = 0;

  void _onTapHandle(int index) {
    setState(() {
      _tabCurrentIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 动态获取tabbarview的children和tabcontroller的length
    final List<Widget> homeBarViewChildren = [
      LayoutDemo(),
      BasicPage(),
      ComplexListPage(),
      AnimatePage(),
      ParticlePage(),
    ];

    return Scaffold(
      appBar: _getAppBar(),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          DefaultTabController(
            length: homeBarViewChildren.length,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('首页'),
                elevation: 0.0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.network_check_rounded),
                    tooltip: 'Network',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => RequestPage(
                            key: UniqueKey(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
                bottom: const TabBar(
                  unselectedLabelColor: Colors.black38,
                  indicatorColor: Colors.black38,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.sports_cricket_rounded),
                      text: 'playground',
                    ),
                    Tab(
                      icon: Icon(Icons.text_fields_rounded),
                      text: '富文本展示',
                    ),
                    Tab(
                      icon: Icon(Icons.list_alt_rounded),
                      text: '复杂列表',
                    ),
                    Tab(
                      icon: Icon(Icons.animation),
                      text: '动画',
                    ),
                    Tab(
                      icon: Icon(Icons.paragliding_outlined),
                      text: '粒子动画',
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: homeBarViewChildren,
              ),
            ),
          ),
          ExplorePage(),
          VideoHomePage(),
          PodcastHomePage(),
        ],
      ),
      drawer: _tabCurrentIndex == 0 ? const DrawerPage() : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabCurrentIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.black,
        onTap: _onTapHandle,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: '探索'),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_library), label: '开眼视频'),
          BottomNavigationBarItem(
              icon: Icon(Icons.podcasts), label: 'iTunes播客'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  PreferredSizeWidget? _getAppBar() {
    if (_tabCurrentIndex == 1) {
      return AppBar(
        title: const Text('探索页面'),
        elevation: 2.0,
        backgroundColor: Colors.green,
        centerTitle: true,
      );
    } else if (_tabCurrentIndex == 2) {
      return AppBar(
        title: const Text('每日视频'),
        elevation: 0.0,
        centerTitle: true,
      );
    } else if (_tabCurrentIndex == 3) {
      return AppBar(
        title: const Text('播客'),
        elevation: 0.0,
        centerTitle: true,
      );
    } else {
      return null;
    }
  }
}
