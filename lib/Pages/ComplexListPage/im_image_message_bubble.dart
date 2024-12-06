import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'im_message.dart';
import 'im_complex_controller.dart';

class ImImageMessageBubble extends StatelessWidget {
  final ImMessage message;
  final bool isMe;
  final controller = Get.find<ImComplexController>();

  ImImageMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  }) {
    controller.loadImageSize(message.messageId, message.content);
  }

  Widget _buildImage(Size displaySize) {
    return Obx(() {
      if (controller.imageLoadingStates[message.messageId]?.value ?? true) {
        return Container(
          width: displaySize.width,
          height: displaySize.height,
          color: Colors.grey[100],
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ),
        );
      }

      if (controller.imageLoadErrors[message.messageId]?.value ?? false) {
        return _buildErrorWidget(displaySize);
      }

      try {
        if (message.content.startsWith('http://') ||
            message.content.startsWith('https://')) {
          return Container(
            width: displaySize.width,
            height: displaySize.height,
            color: Colors.black.withOpacity(0.03),
            child: Image.network(
              message.content,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                debugPrint('❌ [ImageBubble] Network image error: $error');
                return _buildErrorWidget(displaySize);
              },
            ),
          );
        } else {
          return Container(
            width: displaySize.width,
            height: displaySize.height,
            color: Colors.black.withOpacity(0.03),
            child: Image.file(
              File(message.content),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('❌ [ImageBubble] Local image error: $error');
                return _buildErrorWidget(displaySize);
              },
            ),
          );
        }
      } catch (e) {
        debugPrint('❌ [ImageBubble] Error loading image: $e');
        return _buildErrorWidget(displaySize);
      }
    });
  }

  Widget _buildErrorWidget(Size size) {
    return Container(
      width: size.width,
      height: size.height,
      color: Colors.grey[100],
      child: const Center(
        child: Image(
          image: AssetImage('lib/data_resource/image_placeholder.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                image: const DecorationImage(
                  image: AssetImage('lib/data_resource/friend_h.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (!isMe)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                  child: Text(
                    message.sender,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: !isMe ? 8.0 : 0,
                      right: isMe ? 8.0 : 0,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isMe ? 16.0 : 4.0),
                        topRight: Radius.circular(isMe ? 4.0 : 16.0),
                        bottomLeft: const Radius.circular(16.0),
                        bottomRight: const Radius.circular(16.0),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isMe ? 16.0 : 4.0),
                        topRight: Radius.circular(isMe ? 4.0 : 16.0),
                        bottomLeft: const Radius.circular(16.0),
                        bottomRight: const Radius.circular(16.0),
                      ),
                      child: _buildImage(controller.getDisplaySize(
                          message.messageId, context)),
                    ),
                  ),
                  if (!isMe)
                    Positioned(
                      left: 0,
                      top: 10,
                      child: CustomPaint(
                        size: const Size(8, 12),
                        painter: TrianglePainter(color: Colors.grey[200]!),
                      ),
                    ),
                ],
              ),
            ],
          ),
          if (isMe)
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(left: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                image: const DecorationImage(
                  image: AssetImage('lib/data_resource/owner_h.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
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
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
