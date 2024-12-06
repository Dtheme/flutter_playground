import 'package:flutter/material.dart';
import 'dart:math' as math;

class ImAudioWave extends StatefulWidget {
  final bool isRecording;
  final bool showDefaultWave;
  
  const ImAudioWave({super.key, 
    required this.isRecording,
    this.showDefaultWave = false,
  });
  
  @override
  _ImAudioWaveState createState() => _ImAudioWaveState();
}

class _ImAudioWaveState extends State<ImAudioWave> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  final List<double> _heights = [];
  final int barsCount = 20;
  
  @override
  void initState() {
    super.initState();
    _initControllers();
  }
  
  void _initControllers() {
    _controllers = List.generate(
      barsCount,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
      )..addListener(() {
        setState(() {});
      }),
    );
    _heights.clear();
    _heights.addAll(List.generate(barsCount, (index) => 0.3));
    
    // 初始化时让所有控制器到达终点
    for (var controller in _controllers) {
      controller.value = 1.0;
    }
  }
  
  @override
  void didUpdateWidget(ImAudioWave oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording != oldWidget.isRecording) {
      if (widget.isRecording) {
        _startAnimation();
      } else {
        _stopAnimation();
        // 停止录音时重置为静止状态
        _resetToDefault();
      }
    }
  }
  
  void _startAnimation() {
    for (var i = 0; i < barsCount; i++) {
      Future.delayed(Duration(milliseconds: i * 50), () {
        if (mounted && widget.isRecording) {
          _animateBar(i);
        }
      });
    }
  }
  
  void _stopAnimation() {
    for (var controller in _controllers) {
      controller.stop();
    }
  }

  void _resetToDefault() {
    for (var i = 0; i < barsCount; i++) {
      _heights[i] = 0.3;
      _controllers[i].value = 1.0;
    }
  }
  
  void _animateBar(int index) {
    if (!widget.isRecording) return;
    
    final random = math.Random();
    final newHeight = 0.3 + random.nextDouble() * 0.7;
    
    _controllers[index].value = 0;
    _heights[index] = newHeight;
    
    _controllers[index].forward().then((_) {
      if (mounted && widget.isRecording) {
        _animateBar(index);
      }
    });
  }
  
  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          barsCount,
          (index) => _buildBar(index),
        ),
      ),
    );
  }
  
  Widget _buildBar(int index) {
    return Container(
      width: 3,
      height: 60 * _heights[index] * _controllers[index].value,
      decoration: BoxDecoration(
        color: widget.isRecording ? Colors.blue : Colors.grey[400],
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}