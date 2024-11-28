import 'package:flutter/material.dart';
import 'dart:math' as math;

class ParticlePage extends StatefulWidget {
  const ParticlePage({super.key});

  @override
  _ParticlePageState createState() => _ParticlePageState();
}

class _ParticlePageState extends State<ParticlePage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final GlobalKey _bodyKey = GlobalKey();
  final GlobalKey _centerTextKey = GlobalKey(); // 中心内容的 Key
  late Size _screenSize;

  // 防抖变量：记录上一次点击时间
  DateTime? _lastTapTime;

  // 定义 Emoji 列表
  final List<String> emojis = [
    '✨',
    '🎉',
    '🎊',
    '🎁',
    '🍖',
    '🍢',
    '🎂',
    '🦴',
    '🔆',
    '👍🏻',
    '👍🏼',
    '👍🏽',
    '👍🏾',
    '👍🏿'
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..addListener(() {
        setState(() {
          _particles.removeWhere((particle) => particle.alpha <= 0);
          for (var particle in _particles) {
            particle.update();
          }
        });
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenSize = MediaQuery.of(context).size;
  }

  void _addParticles(Offset position) {
    final now = DateTime.now();
    if (_lastTapTime != null &&
        now.difference(_lastTapTime!) < const Duration(seconds: 1)) {
      return;
    }
    _lastTapTime = now;

    for (int i = 0; i < 50; i++) {
      String emoji = emojis[math.Random().nextInt(emojis.length)];
      _particles.add(Particle(
        position: position,
        velocity: math.Random().nextDouble() * 6 + 2,
        angle: math.Random().nextDouble() * 2 * math.pi,
        size: math.Random().nextDouble() * 20 + 10,
        emoji: emoji,
        color: Colors.primaries[math.Random().nextInt(Colors.primaries.length)],
      ));
    }
    if (_particles.length > 500) {
      _particles.removeRange(0, _particles.length - 500);
    }
    _controller.forward(from: 0);
  }

  Offset _getTapPosition(BuildContext context, Offset globalPosition) {
    RenderBox? renderBox =
        _bodyKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      debugPrint('RenderBox is null. Returning screen center.');
      return Offset(_screenSize.width / 2, _screenSize.height / 2);
    }

    Offset localPosition = renderBox.globalToLocal(globalPosition);
    return Offset(
      localPosition.dx.clamp(0, _screenSize.width),
      localPosition.dy.clamp(0, _screenSize.height),
    );
  }

  bool _isInCenterContentArea(Offset globalPosition) {
    RenderBox? centerBox =
        _centerTextKey.currentContext?.findRenderObject() as RenderBox?;
    if (centerBox == null) {
      debugPrint('Center content RenderBox is null.');
      return false;
    }

    // 获取中心内容的全局位置和尺寸
    Offset topLeft = centerBox.localToGlobal(Offset.zero);
    Size size = centerBox.size;

    // 构建中心内容的 Rect
    Rect centerRect = Rect.fromLTWH(topLeft.dx, topLeft.dy, size.width, size.height);

    // 判断点击位置是否在中心内容区域内
    return centerRect.contains(globalPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('粒子动画演示'),
      ),
      body: Container(
        key: _bodyKey,
        child: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent, // 确保透明区域也能响应点击
              onTapDown: (details) {
                if (_isInCenterContentArea(details.globalPosition)) {
                  // 点击了中心内容，触发粒子动画，位置固定为中心
                  Offset centerPosition = Offset(
                    _screenSize.width / 2,
                    _screenSize.height / 2,
                  );
                  _addParticles(centerPosition);
                } else {
                  // 全局区域点击
                  Offset tapPosition =
                      _getTapPosition(context, details.globalPosition);
                  _addParticles(tapPosition);
                }
              },
              child: Container(color: Colors.transparent),
            ),
            Center(
              child: Text(
                '👍🏻',
                key: _centerTextKey, // 设置 Key 用于获取位置和尺寸
                style: const TextStyle(fontSize: 50),
              ),
            ),
            ..._particles.map((particle) => particle.build()),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Particle {
  Offset position;
  double velocity;
  double angle;
  double size;
  double alpha = 1.0;
  String emoji;
  Color color;

  Particle({
    required this.position,
    required this.velocity,
    required this.angle,
    required double size,
    required this.emoji,
    required this.color,
  }) : size = size.clamp(0.0, double.infinity);

  void update() {
    position = Offset(
      position.dx + velocity * math.cos(angle),
      position.dy + velocity * math.sin(angle),
    );
    velocity *= 0.95;
    alpha -= 0.02;
  }

  Widget build() {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Opacity(
        opacity: alpha.clamp(0.0, 1.0),
        child: Transform.scale(
          scale: alpha,
          child: Text(
            emoji,
            style: TextStyle(fontSize: size, color: color),
          ),
        ),
      ),
    );
  }
}
