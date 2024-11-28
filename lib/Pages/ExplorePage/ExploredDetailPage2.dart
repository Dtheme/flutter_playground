import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wefriend_flutter/Pages/HomePage/home_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ExploredDetailPage2 extends StatefulWidget {
  const ExploredDetailPage2({super.key});

  @override
  _ExploredDetailPage2State createState() => _ExploredDetailPage2State();
}

class _ExploredDetailPage2State extends State<ExploredDetailPage2> {
  final RefreshController _refreshController = RefreshController();

  // 模拟数据
  List<String> data = List.generate(20, (index) => 'Item $index');

  // 模拟刷新操作
  void _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    _refreshController.refreshCompleted();
    setState(() {
      data = List.generate(20, (index) => 'Refreshed Item $index');
    });
  }

  // 模拟加载更多操作
  void _onLoading() async {
    await Future.delayed(const Duration(seconds: 1));
    _refreshController.loadComplete();
    setState(() {
      data.addAll(
          List.generate(10, (index) => 'New Item ${data.length + index}'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Navigation',
              onPressed: (() => {
                Get.off(const HomePage()),
              })),
        ],
        title: const Text('ExploredDetailPage2'),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        header: const ClassicHeader(),
        footer: const ClassicFooter(),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(data[index]),
            );
          },
        ),
      ),
    );
  }
}
