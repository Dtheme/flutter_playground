import 'package:flutter/material.dart';
import 'im_message.dart';

class ImRecalledMessageBubble extends StatelessWidget {
  final ImMessage message;

  const ImRecalledMessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Text(
              message.isOwner ? "你撤回了一条消息" : "${message.sender}撤回了一条消息",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 