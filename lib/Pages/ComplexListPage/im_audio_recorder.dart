import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class ImAudioRecorder extends StatefulWidget {
  final bool isRecording;
  final Function(String)? onSendAudio;
  final Function()? onRecordingStarted;

  const ImAudioRecorder({
    super.key,
    required this.isRecording,
    this.onSendAudio,
    this.onRecordingStarted,
  });

  @override
  _ImAudioRecorderState createState() => _ImAudioRecorderState();
}

class _ImAudioRecorderState extends State<ImAudioRecorder> {
  final _recorder = AudioRecorder();
  bool _isInitialized = false;
  bool _isRecording = false;
  String? _recordedFilePath;

  @override
  void initState() {
    super.initState();
    debugPrint('🎤 [AudioRecorder] Initializing...');
    _initializeRecorder();
  }

  @override
  void dispose() {
    _disposeRecorder();
    super.dispose();
  }

  Future<void> _initializeRecorder() async {
    try {
      debugPrint('🎤 [AudioRecorder] Starting initialization...');

      // 1. 检查权限
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw Exception('Microphone permission not granted');
      }
      debugPrint('✅ [AudioRecorder] Microphone permission granted');

      // 2. 检查录音器状态
      if (!await _recorder.isRecording()) {
        debugPrint('✅ [AudioRecorder] Recorder is available');
        setState(() {
          _isInitialized = true;
        });
        debugPrint('✅ [AudioRecorder] Initialization complete');
      } else {
        throw Exception('Recorder is busy');
      }
    } catch (e) {
      debugPrint('❌ [AudioRecorder] Error initializing recorder: $e');
      _isInitialized = false;
      rethrow;
    }
  }

  Future<void> _startRecording() async {
    try {
      debugPrint('🎤 [AudioRecorder] Starting recording process...');

      // 1. 状态检查
      if (!_isInitialized) {
        debugPrint('🎤 [AudioRecorder] Recorder not initialized, initializing...');
        await _initializeRecorder();
        if (!_isInitialized) {
          throw Exception('Failed to initialize recorder');
        }
      }

      // 2. 检查录音状态
      if (await _recorder.isRecording()) {
        debugPrint('⚠️ [AudioRecorder] Already recording');
        return;
      }

      // 3. 创建录音文件
      debugPrint('🎤 [AudioRecorder] Creating recording path...');
      final tempDir = await getTemporaryDirectory();
      _recordedFilePath = '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

      // 4. 开始录音
      debugPrint('🎤 [AudioRecorder] Starting recorder...');
      
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: _recordedFilePath!,
      );

      // 5. 录音实际开始后，更新状态并触发回调
      setState(() {
        _isRecording = true;
      });
      widget.onRecordingStarted?.call();

      debugPrint('✅ [AudioRecorder] Recording started successfully');
    } catch (e) {
      debugPrint('❌ [AudioRecorder] Error in startRecording: $e');
      setState(() {
        _isRecording = false;
      });
      rethrow;
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) {
      debugPrint('⚠️ [AudioRecorder] Not recording, cannot stop');
      return;
    }

    try {
      debugPrint('🎤 [AudioRecorder] Stopping recording...');
      
      // 先更新状态
      setState(() {
        _isRecording = false;
      });

      // 停止录音
      final path = await _recorder.stop();
      debugPrint('✅ [AudioRecorder] Recording stopped at path: $path');

      if (path != null && widget.onSendAudio != null) {
        // 验证录音文件
        final file = File(path);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          debugPrint('📊 [AudioRecorder] Recording file stats:');
          debugPrint('   Path: $path');
          debugPrint('   Total bytes: ${bytes.length}');
          if (bytes.isNotEmpty) {
            debugPrint('✅ [AudioRecorder] File contains data');
            widget.onSendAudio!(path);
          } else {
            debugPrint('❌ [AudioRecorder] Empty recording file');
            throw Exception('Recording file is empty');
          }
        } else {
          debugPrint('❌ [AudioRecorder] Recording file not found');
          throw Exception('Recording file not found');
        }
      }

      debugPrint('✅ [AudioRecorder] Recording stopped successfully');
    } catch (e) {
      debugPrint('❌ [AudioRecorder] Error in stopRecording: $e');
      rethrow;
    }
  }

  Future<void> _disposeRecorder() async {
    debugPrint('🎤 [AudioRecorder] Disposing recorder...');
    try {
      if (await _recorder.isRecording()) {
        await _stopRecording();
      }
      await _recorder.dispose();
      debugPrint('✅ [AudioRecorder] Recorder disposed');
    } catch (e) {
      debugPrint('❌ [AudioRecorder] Error disposing recorder: $e');
    }
  }

  @override
  void didUpdateWidget(ImAudioRecorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording != oldWidget.isRecording && _isInitialized) {
      debugPrint(
          '🎤 [AudioRecorder] Recording state changed: ${widget.isRecording}');
      if (widget.isRecording && !_isRecording) {
        _startRecording();
      } else if (!widget.isRecording && _isRecording) {
        _stopRecording();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // 不再显示波形图，由 ImMessageInput 控制显示
  }
}
