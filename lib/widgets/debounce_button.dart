import 'dart:async';
import 'package:flutter/material.dart';

class DebounceButton extends StatefulWidget {
  const DebounceButton({super.key});

  @override
  _DebounceButtonState createState() => _DebounceButtonState();
}

class _DebounceButtonState extends State<DebounceButton> {
  Timer? _debounceTimer;

  void _onButtonPressed() {
    // 如果 Timer 正在运行，直接返回，防止短时间内多次触发
    if (_debounceTimer?.isActive ?? false) {
      debugPrint("操作过于频繁，忽略当前点击");
      return;
    }

    // 执行点击事件逻辑
    debugPrint("执行点击事件逻辑");

    // 启动防抖 Timer，设置为 1 秒后允许再次触发
    _debounceTimer = Timer(const Duration(seconds: 1), () {
      // Timer 完成后自动允许下次点击
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel(); // 确保 Timer 在页面销毁时被清理
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("防抖按钮")),
      body: Center(
        child: ElevatedButton(
          onPressed: _onButtonPressed,
          child: const Text("点击我"),
        ),
      ),
    );
  }
}
