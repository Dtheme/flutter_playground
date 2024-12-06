import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'im_complex_controller.dart';

class ImMessageStatus extends StatelessWidget {
  final String messageId;
  final bool isMe;

  const ImMessageStatus({
    super.key,
    required this.messageId,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ImComplexController>();

    return Obx(() {
      final isSending = controller.messageSendingStates[messageId]?.value ?? false;
      final isFailed = controller.messageFailedStates[messageId]?.value ?? false;

      if (isSending) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
          ),
        );
      }

      if (isFailed) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.error_outline, color: Colors.red[400], size: 20),
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text('发送失败'),
                    content: const Text('是否重新发送该消息？'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('取消'),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                          controller.resendMessage(messageId);
                        },
                        child: const Text('重发'),
                      ),
                    ],
                  ),
                );
              },
              tooltip: '重新发送',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
            ),
            Text(
              '发送失败',
              style: TextStyle(
                color: Colors.red[400],
                fontSize: 12,
              ),
            ),
          ],
        );
      }

      return const SizedBox(width: 20);
    });
  }
} 