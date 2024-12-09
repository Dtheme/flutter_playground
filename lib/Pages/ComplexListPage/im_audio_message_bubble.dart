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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        child: Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 8.0, top: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  image: const DecorationImage(
                    image: AssetImage('lib/data_resource/friend_h.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Flexible(
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
                    margin: EdgeInsets.only(
                      left: !isMe ? 8.0 : 0,
                      right: isMe ? 8.0 : 0,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.65,
                      minWidth: 120.0,
                    ),
                    decoration: BoxDecoration(
                      color: isMe 
                          ? Colors.blue[100]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isMe ? 16.0 : 4.0),
                        topRight: Radius.circular(isMe ? 4.0 : 16.0),
                        bottomLeft: const Radius.circular(16.0),
                        bottomRight: const Radius.circular(16.0),
                      ),
                    ),
                    child: message.isRecalled
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 10.0),
                            child: const Text(
                              '[此消息已被撤回]',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          )
                        : ImAudioPlayerView(
                            audioPath: message.content,
                            messageId: message.messageId,
                            isMe: isMe,
                          ),
                  ),
                ],
              ),
            ),
            if (isMe)
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(left: 8.0, top: 4.0),
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
