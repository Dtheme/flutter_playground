import 'package:flutter/material.dart';
import 'im_message.dart';
import 'im_message_menu.dart';
import 'im_audio_player_view.dart';

class ImAudioMessageBubble extends StatelessWidget {
  final ImMessage message;
  final bool isMe;

  const ImAudioMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return ImMessageMenu(
      message: message,
      isMe: isMe,
      child: Container(
        margin: EdgeInsets.only(
          left: isMe ? 60 : 12,
          right: isMe ? 12 : 60,
          bottom: 16,
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
            if (message.isRecalled)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isMe ? Colors.blue : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  '此消息已被撤回',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              )
            else
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.65,
                  minWidth: 120.0,
                ),
                decoration: BoxDecoration(
                  color: isMe 
                      ? Colors.blue[100]  // 使用与文字消息相同的背景色
                      : Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isMe ? 16.0 : 4.0),
                    topRight: Radius.circular(isMe ? 4.0 : 16.0),
                    bottomLeft: const Radius.circular(16.0),
                    bottomRight: const Radius.circular(16.0),
                  ),
                ),
                child: ImAudioPlayerView(
                  audioPath: message.content,
                  messageId: message.messageId,
                  isMe: isMe,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
