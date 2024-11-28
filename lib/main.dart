import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wefriend_flutter/Pages/HomePage/home_page.dart';
import 'Pages/HomePage/color_page.dart';
import "Util/GlobalService.dart";
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_nb_net/flutter_net.dart';

 
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NetOptions.instance
      // header
      .addHeaders({"test": 'test header'})
      // .setBaseUrl("https://www.wanandroid.com/")
      // 代理/https
      // .setHttpClientAdapter(IOHttpClientAdapter()  
      //   ..onHttpClientCreate = (client) {
      //     client.findProxy = (uri) {
      //       return 'PROXY 192.168.20.43:8888';
      //     };
      //     client.badCertificateCallback =
      //         (X509Certificate cert, String host, int port) => true;
      //     return client;
      //   })
      // cookie
      // .addInterceptor(CookieManager(CookieJar()))
      // dio_http_cache
      // .addInterceptor(DioCacheManager(CacheConfig(
        // baseUrl: "https://www.wanandroid.com/",
      // )).interceptor)
      // dio_cache_interceptor
      .addInterceptor(DioCacheInterceptor(
          options: CacheOptions(
        store: MemCacheStore(),
        policy: CachePolicy.forceCache,
        hitCacheOnErrorExcept: [401, 403],
        maxStale: const Duration(days: 7),
        priority: CachePriority.normal,
        cipher: null,
        keyBuilder: CacheOptions.defaultCacheKeyBuilder,
        allowPostMethod: false,
      )))
      //  全局解析器
      // .setHttpDecoder(MyHttpDecoder.getInstance())
      //  超时时间
      .setConnectTimeout(const Duration(milliseconds: 3000))
      // 允许打印log，默认未 true
      .enableLogger(true)
      .create();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // 注册 MyService
    final GlobalService myService = Get.put(GlobalService());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // showPerformanceOverlay: true, 
      home: const HomePage(),
      theme: ThemeData(
        primaryColor: ConfigPage.primaryColor,
        primarySwatch: ConfigPage.primarySwatchColor,
        highlightColor: const Color.fromRGBO(255, 255, 255, 0.5),
      ),
    );
  }
}
