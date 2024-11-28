import 'package:flutter/material.dart';

class ImagePopup extends StatelessWidget {
  final String imagePath;

  const ImagePopup({super.key, required this.imagePath});
  //生成一个新的构造方法不需要传图片地址



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Image.network(imagePath),
        ),
      ),
    );
  }
  void showImagePopup(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImagePopup(imagePath: imagePath);
      },
    );
  }
}
