import 'package:flutter/material.dart';
import 'im_message.dart';
import 'im_message_menu.dart';

class ImTextMessageBubble extends StatelessWidget {
  final ImMessage message;
  final bool isMe;

  const ImTextMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return ImMessageMenu(
      message: message,
      isMe: isMe,
      child: Padding(
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  image: const DecorationImage(
                    image: AssetImage('lib/data_resource/friend_h.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Flexible(
              child: Container(
                margin: EdgeInsets.only(
                  left: !isMe ? 8.0 : 0,
                  right: isMe ? 8.0 : 0,
                ),
                child: Column(
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
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.65,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isMe ? 16.0 : 4.0),
                          topRight: Radius.circular(isMe ? 4.0 : 16.0),
                          bottomLeft: const Radius.circular(16.0),
                          bottomRight: const Radius.circular(16.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        message.isRecalled ? '此消息已被撤回' : message.content,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isMe)
              Container(
                width: 40,
                height: 40,
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
