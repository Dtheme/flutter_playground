import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'im_audio_recorder.dart';
import 'im_audio_wave.dart';
import 'im_audio_preview.dart';

class ImMessageInput extends StatefulWidget {
  final Function(String) onSendText;
  final Function(String)? onSendAudio;

  const ImMessageInput({
    super.key,
    required this.onSendText,
    this.onSendAudio,
  });

  @override
  _ImMessageInputState createState() => _ImMessageInputState();
}

class _ImMessageInputState extends State<ImMessageInput> {
  final TextEditingController _controller = TextEditingController();
  bool isVoiceMode = false;
  bool isRecording = false;
  bool showOptions = false;
  String? recordedAudioPath;
  ImAudioRecorder? _audioRecorder;
  bool _hasShowSwitchWarning = false;

  @override
  void initState() {
    super.initState();
    _initAudioRecorder();
  }

  Future<void> _initAudioRecorder() async {
    debugPrint('🎤 [MessageInput] Initializing audio recorder...');
    if (await _checkMicrophonePermission()) {
      _audioRecorder = ImAudioRecorder(
        onSendAudio: _handleSendAudio,
        isRecording: false,
      );
    }
  }

  Future<bool> _checkMicrophonePermission() async {
    debugPrint('🎤 [MessageInput] Checking microphone permission...');

    // 先检查当前权限状态
    final status = await Permission.microphone.status;
    debugPrint('🎤 [MessageInput] Current permission status: $status');

    if (status.isGranted) {
      debugPrint('✅ [MessageInput] Microphone permission already granted');
      return true;
    }

    if (status.isPermanentlyDenied) {
      debugPrint('❌ [MessageInput] Microphone permission permanently denied');
      Get.snackbar(
        '需要麦克风权限',
        '请在设置中允许访问麦克风以进行录音',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: Duration(seconds: 3),
        mainButton: TextButton(
          onPressed: () => openAppSettings(),
          child: Text('去设置', style: TextStyle(color: Colors.red[900])),
        ),
      );
      return false;
    }

    debugPrint('⚠️ [MessageInput] Requesting microphone permission...');
    try {
      final result = await Permission.microphone.request();
      debugPrint('🎤 [MessageInput] Permission request result: $result');

      if (result.isGranted) {
        debugPrint('✅ [MessageInput] Microphone permission granted');
        return true;
      } else {
        debugPrint('❌ [MessageInput] Microphone permission denied');
        Get.snackbar(
          '需要麦克风权限',
          '请在设置中允许访问麦克风以进行录音',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          duration: Duration(seconds: 5),
          mainButton: TextButton(
            onPressed: () => openAppSettings(),
            child: Text('去设置', style: TextStyle(color: Colors.red[900])),
          ),
        );
        return false;
      }
    } catch (e) {
      debugPrint('❌ [MessageInput] Error requesting permission: $e');
      return false; 
    }
  }

  void _showSwitchWarning() {
    Get.snackbar(
      '提示',
      '再次点击切换到其他消息类型，放弃当前录制的语音',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange[100],
      colorText: Colors.orange[900],
      duration: const Duration(seconds: 2),
    );
  }

  void _toggleVoiceMode() async {
    if (recordedAudioPath != null && !isRecording) {
      if (!_hasShowSwitchWarning) {
        _showSwitchWarning();
        setState(() {
          _hasShowSwitchWarning = true;
        });
        return;
      } else {
        setState(() {
          recordedAudioPath = null;
          _hasShowSwitchWarning = false;
        });
      }
    }

    if (!isVoiceMode) {
      await _initAudioRecorder();
      setState(() {
        isVoiceMode = true;
        showOptions = true;
      });
    } else {
      setState(() {
        isVoiceMode = false;
        showOptions = false;
      });
    }
  }

  void _toggleOptions() {
    if (recordedAudioPath != null && !isRecording) {
      if (!_hasShowSwitchWarning) {
        _showSwitchWarning();
        setState(() {
          _hasShowSwitchWarning = true;
        });
        return;
      } else {
        setState(() {
          recordedAudioPath = null;
          _hasShowSwitchWarning = false;
          showOptions = !showOptions;
        });
      }
    } else {
      if (isVoiceMode) {
        return;
      }
      setState(() {
        showOptions = !showOptions;
      });
    }
  }

  void _handleSendAudio(String audioPath) {
    debugPrint('🎤 [MessageInput] Received audio path: $audioPath');
    if (File(audioPath).existsSync()) {
      debugPrint('✅ [MessageInput] Audio file exists, switching to preview');
      setState(() {
        isRecording = false;
        recordedAudioPath = audioPath;
        showOptions = true;
      });
    } else {
      debugPrint('❌ [MessageInput] Audio file does not exist: $audioPath');
    }
  }

  void _resetRecording() {
    debugPrint('🎤 [MessageInput] Resetting recording state');
    setState(() {
      recordedAudioPath = null;
      isRecording = false;
      _hasShowSwitchWarning = false;
    });
  }

  void _sendRecordedAudio() {
    if (recordedAudioPath != null && widget.onSendAudio != null) {
      widget.onSendAudio!(recordedAudioPath!);
      setState(() {
        recordedAudioPath = null;
        showOptions = false;
        _hasShowSwitchWarning = false;
      });
    }
  }

  void _startRecording() async {
    debugPrint('🎤 [MessageInput] Starting recording...');
    setState(() {
      isRecording = true;
      recordedAudioPath = null;
      _audioRecorder = ImAudioRecorder(
        onSendAudio: _handleSendAudio,
        isRecording: true,
      );
    });
  }

  void _stopRecording() {
    debugPrint('🎤 [MessageInput] Stopping recording...');
    setState(() {
      isRecording = false;
      if (_audioRecorder != null) {
        _audioRecorder = ImAudioRecorder(
          onSendAudio: _handleSendAudio,
          isRecording: false,
        );
      }
    });
  }

  @override
  void dispose() {
    _audioRecorder = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildInputRow(),
        if (showOptions) _buildOptionsArea(),
      ],
    );
  }

  Widget _buildInputRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              isVoiceMode ? Icons.keyboard : Icons.mic,
              color: Colors.grey[700],
            ),
            onPressed: _toggleVoiceMode,
          ),
          if (!isVoiceMode)
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration.collapsed(
                  hintText: "输入消息...",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
            ),
          if (isVoiceMode)
            Expanded(
              child: GestureDetector(
                onLongPressStart: (_) async {
                  _startRecording();
                },
                onLongPressEnd: (_) => _stopRecording(),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  height: 36,
                  decoration: BoxDecoration(
                    color: isRecording ? Colors.grey[300] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Center(
                    child: Text(
                      isRecording ? '松开 结束' : '按住 说话',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                ),
              ),
            ),
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.grey[700],
            ),
            onPressed: _toggleOptions,
          ),
          if (!isVoiceMode)
            IconButton(
              icon: Icon(
                Icons.send,
                color:
                    _controller.text.isEmpty ? Colors.grey[400] : Colors.blue,
              ),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  widget.onSendText(_controller.text);
                  _controller.clear();
                }
              },
            ),
        ],
      ),
    );
  }

  Widget _buildOptionsArea() {
    if (isVoiceMode) {
      if (recordedAudioPath != null) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.grey[100],
          child: ImAudioPreview(
            audioPath: recordedAudioPath!,
            onDelete: _resetRecording,
            onSend: (path) {
              widget.onSendAudio?.call(path);
              _resetRecording();
              setState(() {
                showOptions = false;
                isVoiceMode = false;
              });
            },
          ),
        );
      }
      return Container(
        color: Colors.grey[100],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  ImAudioWave(
                    isRecording: isRecording,
                    showDefaultWave: true,
                  ),
                  if (_audioRecorder != null) _audioRecorder!,
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () {
              // TODO: 实现图片选择
            },
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              // TODO: 实现拍照
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              // TODO: 实现视频录制
            },
          ),
        ],
      ),
    );
  }
}
