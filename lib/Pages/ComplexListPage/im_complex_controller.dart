import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'im_message.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:async';

class ImComplexController extends GetxController {
  // 消息列表
  final messages = <ImMessage>[].obs;

  // 图片相关状态
  final imageSizes = <String, Rx<Size?>>{}.obs;
  final imageLoadingStates = <String, RxBool>{}.obs;
  final imageLoadErrors = <String, RxBool>{}.obs;
  final calculatedSizes = <String, Rx<Size?>>{}.obs;

  // 音频相关状态
  final isRecording = false.obs;
  final recordedAudioPath = RxString('');
  final showAudioOptions = false.obs;
  final currentPlayingAudioId = RxString('');
  final isPlaying = false.obs;
  final playProgress = 0.0.obs;

  // 输入相关状态
  final isVoiceMode = false.obs;
  final inputText = ''.obs;

  // 消息发送状态
  final messageSendingStates = <String, RxBool>{}.obs;
  final messageFailedStates = <String, RxBool>{}.obs;

  // 初始化图片状态
  void initImageState(String messageId) {
    if (!imageSizes.containsKey(messageId)) {
      imageSizes[messageId] = Rx<Size?>(null);
      imageLoadingStates[messageId] = true.obs;
      imageLoadErrors[messageId] = false.obs;
      calculatedSizes[messageId] = Rx<Size?>(null);
    }
  }

  // 加载图片尺寸
  Future<void> loadImageSize(String messageId, String imagePath) async {
    initImageState(messageId);

    try {
      if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
        final imageProvider = NetworkImage(imagePath);
        final imageStream = imageProvider.resolve(ImageConfiguration.empty);
        final completer = Completer<ui.Image>();
        final listener = ImageStreamListener(
          (ImageInfo info, bool _) {
            completer.complete(info.image);
          },
          onError: (dynamic exception, StackTrace? stackTrace) {
            debugPrint('❌ [ImageBubble] Error loading image: $exception');
            completer.completeError(exception);
          },
        );

        imageStream.addListener(listener);
        final image = await completer.future;
        imageSizes[messageId]?.value =
            Size(image.width.toDouble(), image.height.toDouble());
        imageLoadErrors[messageId]?.value = false;
        imageStream.removeListener(listener);
      } else {
        final file = File(imagePath);
        if (!file.existsSync()) {
          debugPrint('❌ [ImageBubble] Local file not found: $imagePath');
          imageLoadErrors[messageId]?.value = true;
          return;
        }
        final bytes = await file.readAsBytes();
        final image = await decodeImageFromList(bytes);
        imageSizes[messageId]?.value =
            Size(image.width.toDouble(), image.height.toDouble());
        imageLoadErrors[messageId]?.value = false;
      }
    } catch (e) {
      debugPrint('❌ [ImageBubble] Error getting image size: $e');
      imageLoadErrors[messageId]?.value = true;
    } finally {
      imageLoadingStates[messageId]?.value = false;
    }
  }

  // 计算图片显示尺寸
  void calculateDisplaySize(String messageId, BuildContext context) {
    if (imageSizes[messageId]?.value == null ||
        calculatedSizes[messageId]?.value != null) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth * 0.4;
    final maxHeight = screenWidth * 0.4;
    final minSize = 100.0;

    final originalWidth = imageSizes[messageId]!.value!.width;
    final originalHeight = imageSizes[messageId]!.value!.height;
    final aspectRatio = originalWidth / originalHeight;

    double width, height;

    if (aspectRatio > 1) {
      // 横图
      width = maxWidth;
      height = width / aspectRatio;
      if (height < minSize) {
        height = minSize;
        width = height * aspectRatio;
      }
    } else {
      // 竖图
      height = maxHeight;
      width = height * aspectRatio;
      if (width < minSize) {
        width = minSize;
        height = width / aspectRatio;
      }
    }

    // 确保不超过最大尺寸
    if (width > maxWidth) {
      width = maxWidth;
      height = width / aspectRatio;
    }
    if (height > maxHeight) {
      height = maxHeight;
      width = height * aspectRatio;
    }

    calculatedSizes[messageId]?.value = Size(width, height);
  }

  // 获取图片显示尺寸
  Size getDisplaySize(String messageId, BuildContext context) {
    calculateDisplaySize(messageId, context);
    return calculatedSizes[messageId]?.value ?? const Size(150, 150);
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
    playProgress.value = 0.0;
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
      playProgress.value = 0.0;
    }
  }

  // 更新播放进度
  void updatePlayProgress(double progress) {
    if (progress >= 0 && progress <= 1) {
      playProgress.value = progress;
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
      messages[index] = messages[index].copyWith(
        isRecalled: true,
        content: '此消息已被撤回',
      );
      update();
    }
  }

  // 清理资源
  @override
  void onClose() {
    // 清理图片相关资源
    imageSizes.clear();
    imageLoadingStates.clear();
    imageLoadErrors.clear();
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
