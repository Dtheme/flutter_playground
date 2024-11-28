
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';


//日志
final logger = Logger();

// toast 
void showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 3,
    backgroundColor: const Color(0xFF303030),
    textColor: const Color(0xFFFFFFFF),
    fontSize: 16.0,
  );
}


final Random random = Random();
Color randomColor({
  int limitA = 120,
  int limitR = 0,
  int limitG = 0,
  int limitB = 0,
  int a = 0,
  int r = 0,
  int g = 0,
  int b = 0,
}) {
  a = limitA + random.nextInt(256 - limitA); //透明度值
  r = limitR + random.nextInt(256 - limitR); //红值
  g = limitG + random.nextInt(256 - limitG); //绿值 
  b = limitB + random.nextInt(256 - limitB); //蓝值
  return Color.fromARGB(
      a.toInt(), r.toInt(), g.toInt(), b.toInt()); //生成argb模式的颜色
}

//传入一个数x 生成0-x的随机数
int randomNum(int x) {
  return random.nextInt(x);
}
