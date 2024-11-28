import 'package:flutter/material.dart';
import 'package:wefriend_flutter/Util/global.dart';

class HeroPage1 extends StatelessWidget {
  const HeroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero Page 1'),
      ),
      body: Material(
          child: Align(
              alignment: Alignment.topLeft,
              
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HeroPage2()),
                        );
                      },
                      child: Hero(
                        tag: 'heroAnimateTag',
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          pushWithAnimation(const HeroPage2()),
                        );
                      },
                      child: const Text('go 2 heroPage2'),
                    ),
                  ),
                  Image.network(
                      'https://img2.baidu.com/it/u=673003775,1191479950&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500'),
                ],
              ))),
    );
  }

  PageRouteBuilder<dynamic> pushWithAnimation(Widget targetWidget) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => targetWidget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}

class HeroPage2 extends StatelessWidget {
  const HeroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Hero Page 2'),
        ),
        body: Material(
            child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Positioned(
              child: Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(
                      context,
                    );
                    logger.t('back 2 heroPage1');
                  },
                  child: Hero(
                    tag: 'heroAnimateTag',
                    child: Container(
                      width: 200,
                      height: 200,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ),
            //一个没有阴影的按钮
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  // logger.t('back 2 heroPage1'),
                );
              },
              child: const Text('back 2 heroPage1'),
            ),
          ],
        )));
  }
}
