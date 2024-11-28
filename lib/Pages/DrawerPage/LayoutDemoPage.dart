import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wefriend_flutter/widgets/ImagePopup.dart';
import 'package:wefriend_flutter/Util/global.dart';

class LayoutDemoPage extends StatelessWidget {
  // Logger logger = Logger();
  final String imageUrl =
      "https://r.sinaimg.cn/large/tc/mmbiz_qpic_cn/6ba2d701702556fcb09c01704cdcc411.jpg";

  const LayoutDemoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LayoutWidgetsPage'),
      ),
      body: Material(
        child: Center(
          child: Stack(
            alignment: Alignment.bottomCenter,
            fit: StackFit.expand, //未定位widget占满Stack整个空间
            children: <Widget>[
              //一个带缓存的图片组件
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 30,
                child: CachedNetworkImage(
                  // color: Colors.orange,
                  imageUrl: imageUrl,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 30,
                height: 44,
                child: Row(
                  children: [
                    Expanded(
                        flex: randomNum(10),
                        child: Container(
                          color: randomColor(),
                        )),
                    Expanded(
                        flex: randomNum(10),
                        child: Container(
                          color: randomColor(),
                        )),
                    Expanded(
                        flex: randomNum(10),
                        child: Container(
                          color: randomColor(),
                        )),
                    Expanded(
                        flex: randomNum(10),
                        child: Container(
                          color: randomColor(),
                        )),
                    Expanded(
                        flex: randomNum(10),
                        child: Container(
                          color: randomColor(),
                        )),
                    Expanded(
                        flex: randomNum(10),
                        child: Container(
                          color: randomColor(),
                        )),
                    Expanded(
                        flex: randomNum(10),
                        child: Container(
                          color: randomColor(),
                        )),
                  ],
                ),
              ),
              const Positioned(
                //在海报左上角添加一个背景透明，文字随机颜色的标题
                left: 10,
                top: 30,
                height: 44,
                right: 10,
                child: Text(
                  "这是一个海报标题",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: 'Roboto',
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              Positioned(
                  //在海报右上角生成一个电影icon的按钮
                  right: 30,
                  top: 10,
                  child: TextButton(
                    onPressed: () {
                      logger.i('点击了电影icon');
                      ImagePopup(imagePath: imageUrl)
                          .showImagePopup(context, imageUrl);
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // 设置圆角半径
                      ),
                      backgroundColor: Colors.orange,
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.movie,
                          color: Colors.black,
                          size: 30,
                        ),
                        Text('查看电影海报'),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
