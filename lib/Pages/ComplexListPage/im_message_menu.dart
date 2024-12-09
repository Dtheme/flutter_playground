import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'im_complex_controller.dart';
import 'im_message.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

class ImMessageMenu extends StatelessWidget {
  final ImMessage message;
  final Widget child;
  final bool isMe;

  const ImMessageMenu({
    super.key,
    required this.message,
    required this.child,
    required this.isMe,
  });

  Future<void> _saveImage(String imagePath) async {
    debugPrint('📸 [MessageMenu] Starting to save image: $imagePath');
    try {
      // 1. 检查权限
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (!ps.hasAccess) {
        debugPrint('❌ [MessageMenu] No permission to access gallery');
        Get.dialog(
          AlertDialog(
            title: const Text('需要相册权限'),
            content: const Text('请在系统设置中允许访问相册，以保存图片到相册中。'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  PhotoManager.openSetting();
                },
                child: const Text('去设置'),
              ),
            ],
          ),
        );
        return;
      }

      late Uint8List imageBytes;
      
      // 2. 获取图片数据
      try {
        if (imagePath.startsWith('http')) {
          debugPrint('🌐 [MessageMenu] Loading network image...');
          final response = await http.get(Uri.parse(imagePath));
          if (response.statusCode != 200) {
            throw Exception('Failed to load network image: ${response.statusCode}');
          }
          imageBytes = response.bodyBytes;
        } else if (imagePath.startsWith('lib/')) {
          debugPrint('📦 [MessageMenu] Loading asset image...');
          final ByteData data = await rootBundle.load(imagePath);
          imageBytes = data.buffer.asUint8List();
        } else {
          debugPrint('📁 [MessageMenu] Loading local image...');
          final file = File(imagePath);
          if (!await file.exists()) {
            throw Exception('Image file not found');
          }
          imageBytes = await file.readAsBytes();
        }
        debugPrint('✅ [MessageMenu] Image loaded, size: ${imageBytes.length} bytes');

        // 3. 保存到相册
        final String title = 'image_${DateTime.now().millisecondsSinceEpoch}';
        final AssetEntity? result = await PhotoManager.editor.saveImage(
          imageBytes,
          title: title,
          filename: title,
          relativePath: 'Pictures/WeFriend',
        );

        if (result != null) {
          Get.snackbar(
            '',
            '',
            titleText: Container(),
            messageText: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 20, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    '已保存到相册',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.black87.withOpacity(0.8),
            borderRadius: 8,
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 1),
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          throw Exception('Failed to save image');
        }
      } catch (e) {
        debugPrint('❌ [MessageMenu] Error handling image: $e');
        Get.snackbar(
          '保存失败',
          '图片处理失败，请重试',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          duration: const Duration(seconds: 2),
        );
        return;
      }
    } catch (e) {
      debugPrint('❌ [MessageMenu] Error saving image: $e');
      Get.snackbar(
        '保存失败',
        '请重试',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _showMenu(BuildContext context) {
    final controller = Get.find<ImComplexController>();
    final RenderBox button = context.findRenderObject() as RenderBox;
    final offset = button.localToGlobal(Offset.zero);
    final size = button.size;

    // 计算菜单位置
    final menuTop = offset.dy - 15;
    final menuLeft = offset.dx + (size.width / 2) - (isMe ? 120 : 60);

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              top: menuTop - 36,
              left: menuLeft,
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (message.type == ImMessageType.text)
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                Clipboard.setData(
                                    ClipboardData(text: message.content));
                                _showCopySuccessToast();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: const Row(
                                  children: [
                                    Icon(Icons.copy_rounded,
                                        size: 18, color: Colors.white),
                                    SizedBox(width: 4),
                                    Text(
                                      '复制',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (message.type == ImMessageType.image)
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                _saveImage(message.content);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: const Row(
                                  children: [
                                    Icon(Icons.save_alt_rounded,
                                        size: 18, color: Colors.white),
                                    SizedBox(width: 4),
                                    Text(
                                      '保存',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if ((message.type == ImMessageType.text ||
                                  message.type == ImMessageType.image) &&
                              isMe)
                            Container(
                              width: 1,
                              height: 20,
                              color: Colors.white.withOpacity(0.2),
                            ),
                          if (isMe)
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                _showRecallConfirmDialog(controller);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: const Row(
                                  children: [
                                    Icon(Icons.delete_outline_rounded,
                                        size: 18, color: Colors.white),
                                    SizedBox(width: 4),
                                    Text(
                                      '撤回',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    CustomPaint(
                      size: const Size(12, 6),
                      painter: TrianglePainter(
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCopySuccessToast() {
    Get.snackbar(
      '',
      '',
      titleText: Container(),
      messageText: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 20, color: Colors.white),
            SizedBox(width: 8),
            Text(
              '已复制',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black87.withOpacity(0.8),
      borderRadius: 8,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 1),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showRecallConfirmDialog(ImComplexController controller) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 280,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              const Text(
                '撤回消息',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  '确定要撤回这条消息吗？',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black54,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('取消', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 24,
                      color: Colors.grey[200],
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                          controller.recallMessage(message.messageId);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('确定', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.4),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPressStart: (details) => _showMenu(context),
      child: child,
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
