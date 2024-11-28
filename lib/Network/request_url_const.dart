
// 全局配置类
class GlobalConfig {
  static String testBaseUrl = 'https://www.wanandroid.com/';
  static String artEduUrl = 'https://api.artic.edu/';
}


//mark 定义请求URL
String bannerJsonUrl = "${GlobalConfig.testBaseUrl}banner/json";
String userLoginUrl = "${GlobalConfig.testBaseUrl}user/login";
String kTestUrl = "${GlobalConfig.testBaseUrl}lg/collect/list/0/json";
String artWorkListUrl = "${GlobalConfig.artEduUrl}api/v1/artworks";

