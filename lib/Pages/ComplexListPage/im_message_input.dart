import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'im_audio_recorder.dart';
import 'im_audio_wave.dart';
import 'im_audio_preview.dart';

class ImMessageInput extends StatefulWidget {
  final Function(String) onSendText;
  final Function(String)? onSendAudio;
  final Function(String)? onSendImage;

  const ImMessageInput({
    super.key,
    required this.onSendText,
    this.onSendAudio,
    this.onSendImage,
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
  bool _isActuallyRecording = false;
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initAudioRecorder();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    if (Platform.isIOS) {
      final photos = await Permission.photos.status;
      final camera = await Permission.camera.status;
      if (photos.isDenied) {
        await Permission.photos.request();
      }
      if (camera.isDenied) {
        await Permission.camera.request();
      }
    } else {
      final storage = await Permission.storage.status;
      final camera = await Permission.camera.status;
      if (storage.isDenied) {
        await Permission.storage.request();
      }
      if (camera.isDenied) {
        await Permission.camera.request();
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (image != null) {
        debugPrint('📸 [MessageInput] Image picked: ${image.path}');
        if (widget.onSendImage != null) {
          widget.onSendImage!(image.path);
        }
      }
    } catch (e) {
      debugPrint('❌ [MessageInput] Error picking image: $e');
      Get.snackbar(
        '提示',
        '选择图片失败，请重试',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 300),
      ),
      builder: (context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 1.0, end: 0.0),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) => Transform.translate(
          offset: Offset(0, 100 * value),
          child: child,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '选择图片',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOptionButton(
                      icon: Icons.photo_library,
                      label: '相册',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                    _buildOptionButton(
                      icon: Icons.camera_alt,
                      label: '拍照',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 8,
                  color: Colors.grey[100],
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    alignment: Alignment.center,
                    child: const Text(
                      '取消',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                icon,
                size: 28,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
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
        duration: const Duration(seconds: 3),
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
          duration: const Duration(seconds: 5),
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
    if (isVoiceMode) {
      if (recordedAudioPath != null) {
        if (!_hasShowSwitchWarning) {
          _showSwitchWarning();
          setState(() {
            _hasShowSwitchWarning = true;
          });
        } else {
          setState(() {
            recordedAudioPath = null;
            _hasShowSwitchWarning = false;
            isVoiceMode = false;
            showOptions = true;
          });
        }
      } else {
        setState(() {
          isVoiceMode = false;
          showOptions = true;
        });
      }
    } else {
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
      _isActuallyRecording = false;
      _audioRecorder = ImAudioRecorder(
        onSendAudio: _handleSendAudio,
        isRecording: true,
        onRecordingStarted: () {
          setState(() {
            _isActuallyRecording = true;
          });
        },
      );
    });
  }

  void _stopRecording() {
    debugPrint('🎤 [MessageInput] Stopping recording...');
    setState(() {
      isRecording = false;
      _isActuallyRecording = false;
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  ImAudioWave(
                    isRecording: _isActuallyRecording,
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
            onPressed: () => _pickImage(ImageSource.gallery),
            tooltip: '从相册选择',
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () => _pickImage(ImageSource.camera),
            tooltip: '拍摄照片',
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              // TODO: 实现视频录制
            },
            tooltip: '录制视频',
          ),
        ],
      ),
    );
  }
}
