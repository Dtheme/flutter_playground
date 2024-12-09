import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'im_message.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class ImComplexController extends GetxController {
  // 消息列表
  final messages = <ImMessage>[].obs;

  // 图片相关状态
  final imageLoadingStates = <String, RxBool>{};
  final imageLoadErrors = <String, RxBool>{};
  final imageSizes = RxMap<String, Rx<Size>>();
  final calculatedSizes = <String, Size>{};

  // 音频相关状态
  final isRecording = false.obs;
  final recordedAudioPath = RxString('');
  final showAudioOptions = false.obs;
  final currentPlayingAudioId = ''.obs;
  final isPlaying = false.obs;
  final recordingProgress = 0.0.obs;

  // 输入相关状态
  final isVoiceMode = false.obs;
  final inputText = ''.obs;

  // 消息发送状态
  final messageSendingStates = <String, RxBool>{};
  final messageFailedStates = <String, RxBool>{};

  // 初始化图片状态
  void initImageState(String messageId) {
    if (!imageLoadingStates.containsKey(messageId)) {
      imageLoadingStates[messageId] = false.obs;
      imageLoadErrors[messageId] = false.obs;
      imageSizes[messageId] = const Size(200, 150).obs;
    }
  }

  // 更新图片尺寸
  void updateImageSize(String messageId, Size size) {
    if (!imageLoadingStates.containsKey(messageId)) {
      return;
    }

    if (size.width <= 0 || size.height <= 0) {
      imageLoadingStates[messageId]?.value = false;
      imageLoadErrors[messageId]?.value = true;
      return;
    }

    try {
      final displaySize = _calculateDisplaySize(size);
      imageSizes[messageId] = displaySize.obs;
      imageLoadingStates[messageId]?.value = false;
      imageLoadErrors[messageId]?.value = false;
    } catch (e) {
      debugPrint('❌ [Controller] Error updating image size: $e');
      imageLoadingStates[messageId]?.value = false;
      imageLoadErrors[messageId]?.value = true;
    }
  }

  // 获取图片显示尺寸
  Size getDisplaySize(String messageId, BuildContext context) {
    if (imageSizes.containsKey(messageId) && imageSizes[messageId] != null) {
      return imageSizes[messageId]!.value;
    }
    // 默认尺寸
    return const Size(200, 150);
  }

  // 加载图片尺寸
  Future<void> loadImageSize(String messageId, String imagePath) async {
    if (imageLoadingStates.containsKey(messageId)) return;

    imageLoadingStates[messageId] = true.obs;
    imageLoadErrors[messageId] = false.obs;

    try {
      final image = await _loadImage(imagePath);
      if (image != null) {
        final size = Size(image.width.toDouble(), image.height.toDouble());
        updateImageSize(messageId, size);
      }
      imageLoadingStates[messageId]?.value = false;
    } catch (e) {
      debugPrint('❌ Error loading image size: $e');
      imageLoadErrors[messageId]?.value = true;
      imageLoadingStates[messageId]?.value = false;
    }
  }

  // 计算图片显示尺寸
  Size _calculateDisplaySize(Size originalSize) {
    double width = originalSize.width;
    double height = originalSize.height;
    final aspectRatio = width / height;

    // 基础尺寸限制
    const baseMaxWidth = 240.0;
    const baseMaxHeight = 320.0;
    const minWidth = 120.0;
    const minHeight = 120.0;

    // 根据图片方向调整尺寸
    if (aspectRatio > 1) {
      // 横向图片：以宽度为基准进行缩放，并限制高度不小于最小高度
      if (width > baseMaxWidth) {
        width = baseMaxWidth;
        height = width / aspectRatio;
      }
      // 如果高度小于最小高度，以最小高度为基准重新计算
      if (height < minHeight) {
        height = minHeight;
        width = height * aspectRatio;
        // 如果调整后宽度超过最大宽度，再次调整
        if (width > baseMaxWidth) {
          width = baseMaxWidth;
          height = width / aspectRatio;
        }
      }
    } else {
      // 竖向图片：以高度为基准进行缩放
      if (height > baseMaxHeight) {
        height = baseMaxHeight;
        width = height * aspectRatio;
      }
      // 对于竖图，额外限制最大宽度
      if (width > baseMaxWidth * 0.75) {
        width = baseMaxWidth * 0.75;
        height = width / aspectRatio;
      }
    }

    // 处理异常情况
    if (width.isNaN || height.isNaN || width <= 0 || height <= 0) {
      width = minWidth;
      height = minHeight;
    }

    return Size(width, height);
  }

  // 加载图片
  Future<ui.Image?> _loadImage(String imagePath) async {
    try {
      if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
        final response = await http.get(Uri.parse(imagePath));
        final bytes = response.bodyBytes;
        final codec = await ui.instantiateImageCodec(bytes);
        final frame = await codec.getNextFrame();
        return frame.image;
      } else {
        final bytes = await rootBundle.load(imagePath);
        final codec = await ui.instantiateImageCodec(bytes.buffer.asUint8List());
        final frame = await codec.getNextFrame();
        return frame.image;
      }
    } catch (e) {
      debugPrint('❌ Error loading image: $e');
      return null;
    }
  }

  // 切换语音模式
  void toggleVoiceMode() {
    isVoiceMode.value = !isVoiceMode.value;
  }

  // 开始录音
  void startRecording() {
    isRecording.value = true;
    showAudioOptions.value = false;
  }

  // 停止录音
  void stopRecording(String audioPath) {
    isRecording.value = false;
    recordedAudioPath.value = audioPath;
    showAudioOptions.value = true;
  }

  // 取消录音
  void cancelRecording() {
    isRecording.value = false;
    recordedAudioPath.value = '';
    showAudioOptions.value = false;
  }

  // 重置录音状态
  void resetRecording() {
    recordedAudioPath.value = '';
    showAudioOptions.value = false;
    isRecording.value = false;
  }

  // 播放音频
  void playAudio(String messageId) {
    if (currentPlayingAudioId.value != messageId) {
      stopAudio(); // 确保停止其他正在播放的音频
    }
    currentPlayingAudioId.value = messageId;
    isPlaying.value = true;
    recordingProgress.value = 0.0;
  }

  // 暂停音频
  void pauseAudio() {
    isPlaying.value = false;
  }

  // 停止音频
  void stopAudio() {
    if (currentPlayingAudioId.value.isNotEmpty) {
      currentPlayingAudioId.value = '';
      isPlaying.value = false;
      recordingProgress.value = 0.0;
    }
  }

  // 更新播放进度
  void updatePlayProgress(double progress) {
    if (progress >= 0 && progress <= 1) {
      recordingProgress.value = progress;
      if (progress >= 1) {
        stopAudio();
      }
    }
  }

  // 初始化消息状态
  void initMessageState(String messageId) {
    if (!messageSendingStates.containsKey(messageId)) {
      messageSendingStates[messageId] = false.obs;
      messageFailedStates[messageId] = false.obs;
    }
  }

  // 发送文本消息
  Future<void> sendTextMessage(String text) async {
    if (text.trim().isEmpty) return;

    final message = ImMessage(
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now().millisecondsSinceEpoch,
      userId: 'dzw',
      userType: 'owner',
      sender: '我',
      content: text,
      type: ImMessageType.text,
    );

    await _sendMessage(message);
  }

  // 发送语音消息
  Future<void> sendAudioMessage(String audioPath) async {
    if (audioPath.isEmpty) return;

    final message = ImMessage(
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now().millisecondsSinceEpoch,
      userId: 'dzw',
      userType: 'owner',
      sender: '我',
      content: audioPath,
      type: ImMessageType.audio,
    );

    await _sendMessage(message);
    resetRecording();
  }

  // 发送图片消息
  Future<void> sendImageMessage(String imagePath) async {
    if (imagePath.isEmpty) return;

    final message = ImMessage(
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now().millisecondsSinceEpoch,
      userId: 'dzw',
      userType: 'owner',
      sender: '我',
      content: imagePath,
      type: ImMessageType.image,
    );

    await _sendMessage(message);
  }

  // 统一的消息发送逻辑
  Future<void> _sendMessage(ImMessage message) async {
    initMessageState(message.messageId);
    messages.add(message);

    try {
      messageSendingStates[message.messageId]?.value = true;

      // TODO: 实际的消息发送逻辑
      await Future.delayed(const Duration(seconds: 1)); // 模拟网络延迟

      messageSendingStates[message.messageId]?.value = false;
      messageFailedStates[message.messageId]?.value = false;
    } catch (e) {
      debugPrint('❌ Error sending message: $e');
      messageSendingStates[message.messageId]?.value = false;
      messageFailedStates[message.messageId]?.value = true;
    }
  }

  // 重发消息
  Future<void> resendMessage(String messageId) async {
    final message = messages.firstWhere((msg) => msg.messageId == messageId);
    await _sendMessage(message);
  }

  // 撤回消息
  void recallMessage(String messageId) {
    final index = messages.indexWhere((msg) => msg.messageId == messageId);
    if (index != -1) {
      final originalMessage = messages[index];
      
      // 如果是图片消息，先清理相关状态
      if (originalMessage.type == ImMessageType.image) {
        imageLoadingStates.remove(messageId);
        imageLoadErrors.remove(messageId);
        imageSizes.remove(messageId);
        calculatedSizes.remove(messageId);
      }

      // 创建新的撤回消息，保持原始消息的所有属性
      final newMessage = ImMessage(
        messageId: originalMessage.messageId,
        timestamp: originalMessage.timestamp,  // 保持原始时间戳
        userId: originalMessage.userId,
        userType: originalMessage.userType,
        sender: originalMessage.sender,
        content: originalMessage.content,  // 保持原始内容，但不会显示
        type: originalMessage.type,  // 保持原始消息类型
        isRecalled: true,
      );

      // 更新消息并强制刷新列表
      messages[index] = newMessage;
      
      // 使用 assignAll 来强制刷新列表，确保视图更新
      final currentMessages = List<ImMessage>.from(messages);
      messages.assignAll(currentMessages);
      
      // 延迟一帧后再次刷新，确保图片状态被正确清理
      WidgetsBinding.instance.addPostFrameCallback((_) {
        messages.refresh();
      });
    }
  }

  // 清理资源
  @override
  void onClose() {
    // 清理图片相关资源
    imageLoadingStates.clear();
    imageLoadErrors.clear();
    imageSizes.clear();
    calculatedSizes.clear();

    // 清理音频相关资源
    stopAudio();

    // 清理消息状态
    messageSendingStates.clear();
    messageFailedStates.clear();
    messages.clear();

    super.onClose();
  }
}
