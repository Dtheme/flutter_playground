import 'package:dio/dio.dart';

/// 请求管理类
class RequestManager {
  static Dio? _dio;

  /// 获取 Dio 实例
  static Dio getInstance() {
    _dio ??= Dio()..options.connectTimeout = const Duration(milliseconds: 3000);
    // ..interceptors.add(DynamicBaseUrlInterceptor(
    // defaultBaseUrl: GlobalConfig.defaultBaseUrl));
    return _dio!;
  }
}
