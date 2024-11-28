
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wefriend_flutter/Util/global.dart';

// 屏幕等分色块
class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  @override
  Widget build(BuildContext context) {
    int rowcount = 4;
    int columncount = 8;
    double boxWidth = MediaQuery.of(context).size.width / rowcount;
    List<Widget> children = [];
    for (int i = 0; i < rowcount; i++) {
      List<Widget> columnChildren = [];
      for (int j = 0; j < columncount; j++) {
        var boxColor = randomColor();
        bool isDark = boxColor.red + boxColor.green + boxColor.blue < 382;
        columnChildren.add(Expanded(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                width: boxWidth,
                height: boxWidth,
                child: Container(
                  color: boxColor,
                  child: Center(
                    child: Text(
                      'i:($i,$j)\nc:(${randomColor().red},${randomColor().green},${randomColor().blue},${randomColor().alpha})',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Positioned(
                  child: TextButton(
                onPressed: () {
                  if (Get.isSnackbarOpen) Get.closeAllSnackbars();
                  Get.snackbar("当前点击颜色", "R:${boxColor.red} G:${boxColor.green} B:${boxColor.blue} A:${boxColor.alpha}",
                      backgroundColor: boxColor,
                      titleText: Text(
                        "当前点击的方块颜色",
                        style: TextStyle(color: (isDark == true? Colors.white:Colors.black)),
                      ),
                      );
                  
                },
                //去掉水波纹
                style: ButtonStyle(
                    overlayColor:
                        WidgetStateProperty.all(Colors.transparent)),
                child: const Text(''),
              )),
            ],
            //   保留原来的代码
            //   Expanded(
            //     child: ColoredBox(
            //   color: randomColor(),
            //   child: Center(
            //     child: Text(
            //       'i:($i,$j)\nc:(${randomColor().red},${randomColor().green},${randomColor().blue},${randomColor().alpha})',
            //       style: const TextStyle(
            //           color: Colors.white,
            //           fontSize: 10.0,
            //           fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ))
          ),
        ));
      }
      children.add(Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: columnChildren,
      )));
    }
    return
        // SingleChildScrollView(
        //   scrollDirection: Axis.vertical,
        // child:
        Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
    // );
  }
    
}

