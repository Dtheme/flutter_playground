import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wefriend_flutter/Util/global.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  // const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String version = '';

  @override
  void initState() {
    super.initState();
    _getVersion();
  }

  Future<void> _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    logger.i(packageInfo.version);
    logger.i(packageInfo.buildNumber);
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('关于我们'),
            onTap: () {
              // 打开系统浏览器打开链接"www.baidu.com"
              logger.i("打开系统浏览器打开链接www.baidu.com");
              goURL("https://www.baidu.com");
            },
          ),
          ListTile(
            title: const Text('用户协议'),
            onTap: () {
              // TODO: 打开用户协议页面
            },
          ),
          ListTile(
            title: const Text('隐私政策'),
            onTap: () {
              // TODO: 打开隐私政策页面
            },
          ),
          ListTile(
            title: const Text('版本号'),
            subtitle: Text(version),
          ),
          ListTile(
            title: const Text('退出登录'),
            onTap: () {
              // TODO: 执行退出登录操作
              showToast("退出登录成功:)");
            },
          ),
        ],
      ),
    );
  }

  void goURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
