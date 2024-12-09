import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'im_message.dart';
import 'im_complex_controller.dart';
import 'im_message_menu.dart';
import '/widgets/ImagePopup.dart';

class ImImageMessageBubble extends StatelessWidget {
  final ImMessage message;
  final bool isMe;
  final controller = Get.find<ImComplexController>();

  ImImageMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  }) {
    controller.initImageState(message.messageId);
    controller.loadImageSize(message.messageId, message.content);
  }

  Widget _buildImage(BuildContext context) {
    return Obx(() {
      final displaySize = controller.getDisplaySize(message.messageId, context);

      Widget imageContent;
      if (controller.imageLoadingStates[message.messageId]?.value ?? true) {
        imageContent = Container(
          width: displaySize.width,
          height: displaySize.height,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMe ? 16.0 : 4.0),
              topRight: Radius.circular(isMe ? 4.0 : 16.0),
              bottomLeft: const Radius.circular(16.0),
              bottomRight: const Radius.circular(16.0),
            ),
          ),
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          ),
        );
      } else if (controller.imageLoadErrors[message.messageId]?.value ?? false) {
        imageContent = _buildErrorWidget(displaySize);
      } else {
        try {
          if (message.content.startsWith('http://') ||
              message.content.startsWith('https://')) {
            imageContent = Hero(
              tag: 'image_${message.messageId}',
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierColor: Colors.black87,
                    builder: (BuildContext context) {
                      return ImagePopup(imagePath: message.content);
                    },
                  );
                },
                child: Image.network(
                  message.content,
                  width: displaySize.width,
                  height: displaySize.height,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      if (!controller.imageSizes.containsKey(message.messageId)) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          final imageProvider = NetworkImage(message.content);
                          imageProvider
                              .resolve(ImageConfiguration.empty)
                              .addListener(
                            ImageStreamListener(
                              (ImageInfo info, bool _) {
                                final size = Size(
                                  info.image.width.toDouble(),
                                  info.image.height.toDouble(),
                                );
                                controller.updateImageSize(message.messageId, size);
                              },
                            ),
                          );
                        });
                      }
                      return child;
                    }
                    return Container(
                      width: displaySize.width,
                      height: displaySize.height,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isMe ? 16.0 : 4.0),
                          topRight: Radius.circular(isMe ? 4.0 : 16.0),
                          bottomLeft: const Radius.circular(16.0),
                          bottomRight: const Radius.circular(16.0),
                        ),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('❌ [ImageBubble] Network image error: $error');
                    return _buildErrorWidget(displaySize);
                  },
                ),
              ),
            );
          } else {
            imageContent = Hero(
              tag: 'image_${message.messageId}',
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierColor: Colors.black87,
                    builder: (BuildContext context) {
                      return ImagePopup(imagePath: message.content);
                    },
                  );
                },
                child: Image.asset(
                  message.content,
                  width: displaySize.width,
                  height: displaySize.height,
                  fit: BoxFit.contain,
                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    if (frame != null) {
                      if (!controller.imageSizes.containsKey(message.messageId)) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          final imageProvider = AssetImage(message.content);
                          imageProvider
                              .resolve(ImageConfiguration.empty)
                              .addListener(
                            ImageStreamListener(
                              (ImageInfo info, bool _) {
                                final size = Size(
                                  info.image.width.toDouble(),
                                  info.image.height.toDouble(),
                                );
                                controller.updateImageSize(message.messageId, size);
                              },
                            ),
                          );
                        });
                      }
                      return child;
                    }
                    return Container(
                      width: displaySize.width,
                      height: displaySize.height,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isMe ? 16.0 : 4.0),
                          topRight: Radius.circular(isMe ? 4.0 : 16.0),
                          bottomLeft: const Radius.circular(16.0),
                          bottomRight: const Radius.circular(16.0),
                        ),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('❌ [ImageBubble] Local image error: $error');
                    return _buildErrorWidget(displaySize);
                  },
                ),
              ),
            );
          }
        } catch (e) {
          debugPrint('❌ [ImageBubble] Error loading image: $e');
          imageContent = _buildErrorWidget(displaySize);
        }
      }

      return Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.6,
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: Container(
          width: displaySize.width,
          height: displaySize.height,
          decoration: BoxDecoration(
            color: Colors.grey[50],
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
            child: Container(
              color: Colors.transparent,
              child: imageContent,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildErrorWidget(Size size) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isMe ? 16.0 : 4.0),
          topRight: Radius.circular(isMe ? 4.0 : 16.0),
          bottomLeft: const Radius.circular(16.0),
          bottomRight: const Radius.circular(16.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_rounded,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            '图片加载失败',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
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
              ImMessageMenu(
                message: message,
                isMe: isMe,
                child: Stack(
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
                        child: _buildImage(context),
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
