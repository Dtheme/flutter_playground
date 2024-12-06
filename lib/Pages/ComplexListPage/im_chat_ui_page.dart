import 'package:flutter/material.dart';
import 'im_message.dart';
import 'im_text_message_bubble.dart';
import 'im_audio_message_bubble.dart';
import 'im_image_message_bubble.dart';
import 'im_message_input.dart';
import '../../Network/bussiness_api.dart';
import 'package:get/get.dart';
import 'im_complex_controller.dart';

class ImChatUIPage extends StatefulWidget {
  const ImChatUIPage({super.key});

  @override
  _ImChatUIPageState createState() => _ImChatUIPageState();
}

class _ImChatUIPageState extends State<ImChatUIPage> {
  final controller = Get.put(ImComplexController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMockMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMockMessages() async {
    try {
      debugPrint('🔄 [Chat UI] Loading mock messages...');
      final mockMessages = await BusinessApi.getMockMessages();
      debugPrint('📥 [Chat UI] Received ${mockMessages.length} messages');

      controller.messages.value = mockMessages
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      debugPrint('📊 [Chat UI] Messages sorted by timestamp');

      // 滚动到最新消息
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
          debugPrint('📜 [Chat UI] Scrolled to latest message');
        }
      });
    } catch (e) {
      debugPrint('❌ [Chat UI] Error loading mock messages: $e');
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendTextMessage(String text) {
    controller.sendTextMessage(text);
    _scrollToBottom();
  }

  void _sendAudioMessage(String audioPath) {
    controller.sendAudioMessage(audioPath);
    _scrollToBottom();
  }

  Widget _buildMessageBubble(ImMessage message) {
    final isMe = message.isOwner;

    switch (message.type) {
      case ImMessageType.text:
        return ImTextMessageBubble(
          message: message,
          isMe: isMe,
        );
      case ImMessageType.audio:
        return ImAudioMessageBubble(
          message: message,
          isMe: isMe,
        );
      case ImMessageType.image:
        return ImImageMessageBubble(
          message: message,
          isMe: isMe,
        );
      case ImMessageType.video:
        // TODO: 实现视频消息气泡
        return ImTextMessageBubble(
          message: message,
          isMe: isMe,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('聊天'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageBubble(controller.messages[index]);
                  },
                )),
          ),
          ImMessageInput(
            onSendText: _sendTextMessage,
            onSendAudio: _sendAudioMessage,
          ),
        ],
      ),
    );
  }
}
