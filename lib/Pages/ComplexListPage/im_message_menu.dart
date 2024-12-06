import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'im_complex_controller.dart';
import 'im_message.dart';

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

  void _showMenu(BuildContext context) {
    final controller = Get.find<ImComplexController>();
    final RenderBox button = context.findRenderObject() as RenderBox;
    final offset = button.localToGlobal(Offset.zero);
    final size = button.size;

    // 计算菜单位置
    final menuTop = offset.dy - 15; // 气泡上方距离
    final menuLeft = offset.dx + (size.width / 2) - (isMe ? 120 : 60);

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              top: menuTop - 36, // 菜单高度 + 箭头高度
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
                          if (message.type == ImMessageType.text && isMe)
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
