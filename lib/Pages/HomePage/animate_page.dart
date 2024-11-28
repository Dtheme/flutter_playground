import 'package:flutter/material.dart';
import 'dart:math';

class AnimatePage extends StatefulWidget {
  const AnimatePage({super.key});

  @override
  _AnimatePageState createState() => _AnimatePageState();
}

class _AnimatePageState extends State<AnimatePage>
    with TickerProviderStateMixin {
  // 定义动画控制器和动画变量

  // 示例一：单个动画
  late AnimationController _controllerSingle;
  late Animation<double> _animationSingle;
  late AnimationController _controllerSingleDelay;
  late Animation<double> _animationSingleDelay;

  // 示例二：循环动画
  late AnimationController _controllerLoop;
  late Animation<double> _animationLoop;

  // 示例三：串行动画
  late AnimationController _controllerSequential;
  late Animation<double> _animationWidthSequential;
  late Animation<Color?> _animationColorSequential;

  // 示例四：并行动画
  late AnimationController _controllerParallel;
  late Animation<double> _animationWidthParallel;
  late Animation<Color?> _animationColorParallel;

  // 示例五：透明度动画
  late AnimationController _controllerOpacity;
  late Animation<double> _animationOpacity;

  // 示例六：缩放动画
  late AnimationController _controllerScale;
  late Animation<double> _animationScale;

  // 示例七：旋转动画
  late AnimationController _controllerRotation;
  late Animation<double> _animationRotation;

  // 示例八：位移动画
  late AnimationController _controllerTranslation;
  late Animation<Offset> _animationTranslation;

  // 示例九：3D旋转动画
  late AnimationController _controller3DRotation;
  late Animation<double> _animation3DRotation;

  // 示例十：复杂动画（加入平移动画）
  late AnimationController _controllerComplex;
  late Animation<double> _animationAngleComplex;
  late Animation<double> _animationSizeComplex;
  late Animation<Color?> _animationColorComplex;
  late Animation<double> _animationRadiusComplex;
  late Animation<Color?> _animationBorderColorComplex;
  late Animation<double> _animationTranslationComplex;

  late AnimationController _controllerParticle;
  late Animation<double> _animationParticle;

  @override
  void initState() {
    super.initState();

    // 初始化示例一的动画（单个动画）
    _controllerSingle = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationSingle =
        Tween<double>(begin: 0.0, end: 200.0).animate(_controllerSingle);
    _controllerSingle.forward();

    _controllerSingleDelay = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationSingleDelay =
        Tween<double>(begin: 0.0, end: 200.0).animate(_controllerSingleDelay);
    Future.delayed(const Duration(seconds: 3), () {
      _controllerSingleDelay.forward();
    });

    // 初始化示例二的动画（循环动画）
    _controllerLoop = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationLoop = Tween<double>(begin: 0.0, end: 200.0).animate(
      CurvedAnimation(
        parent: _controllerLoop,
        curve: Curves.bounceInOut,
      ),
    );
    _controllerLoop.repeat(reverse: true);

    // 初始化示例三的动画（串行动画）
    _controllerSequential = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _animationWidthSequential = Tween<double>(begin: 0.0, end: 200.0).animate(
      CurvedAnimation(
        parent: _controllerSequential,
        curve: const Interval(0.0, 0.5, curve: Curves.linear),
      ),
    );
    _animationColorSequential =
        ColorTween(begin: Colors.blue, end: Colors.red).animate(
      CurvedAnimation(
        parent: _controllerSequential,
        curve: const Interval(0.5, 1.0, curve: Curves.linear),
      ),
    );
    _controllerSequential.repeat();

    // 初始化示例四的动画（并行动画）
    _controllerParallel = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationWidthParallel =
        Tween<double>(begin: 0.0, end: 200.0).animate(_controllerParallel);
    _animationColorParallel = ColorTween(begin: Colors.blue, end: Colors.red)
        .animate(_controllerParallel);
    _controllerParallel.repeat(reverse: true);

    // 初始化示例五的动画（透明度动画）
    _controllerOpacity = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationOpacity =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controllerOpacity);
    _controllerOpacity.repeat(reverse: true);

    // 初始化示例六的动画（缩放动画）
    _controllerScale = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationScale =
        Tween<double>(begin: 1.0, end: 2.0).animate(_controllerScale);
    _controllerScale.repeat(reverse: true);

    // 初始化示例��的动画（旋转动画）
    _controllerRotation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationRotation =
        Tween<double>(begin: 0.0, end: 2 * pi).animate(_controllerRotation);
    _controllerRotation.repeat();

    // 初始化示例八的动画（位移动画）
    _controllerTranslation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationTranslation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(2.8, 0.0),
    ).animate(_controllerTranslation);
    _controllerTranslation.repeat(reverse: true);

    // 初始化示例九的动画（3D旋转动画）
    _controller3DRotation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _animation3DRotation =
        Tween<double>(begin: 0.0, end: 2 * pi).animate(_controller3DRotation);
    _controller3DRotation.repeat();

    _controllerComplex = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // 定义角度动画
    _animationAngleComplex = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: pi), weight: 50),
      TweenSequenceItem(tween: ConstantTween<double>(pi), weight: 50),
    ]).animate(_controllerComplex);

    // 定义尺寸动画
    _animationSizeComplex = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 50.0, end: 200.0), weight: 50),
      TweenSequenceItem(
          tween: Tween<double>(begin: 200.0, end: 50.0), weight: 50),
    ]).animate(_controllerComplex);

    // 定义颜色动画
    _animationColorComplex = TweenSequence([
      TweenSequenceItem(
          tween: ColorTween(begin: Colors.blue[50], end: Colors.blue[400]),
          weight: 50),
      TweenSequenceItem(
          tween: ColorTween(begin: Colors.blue[400], end: Colors.amber),
          weight: 50),
    ]).animate(_controllerComplex);

    // 定义圆角动画
    _animationRadiusComplex = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 20.0, end: 0.0), weight: 50),
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: 360.0), weight: 50),
    ]).animate(_controllerComplex);

    // 定义边框颜色动画
    _animationBorderColorComplex = TweenSequence([
      TweenSequenceItem(
          tween: ColorTween(begin: Colors.red, end: Colors.deepPurpleAccent),
          weight: 50),
      TweenSequenceItem(
          tween: ColorTween(begin: Colors.deepPurpleAccent, end: Colors.brown),
          weight: 50),
    ]).animate(_controllerComplex);

    // 定义平移动画
    _animationTranslationComplex = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0),
        weight: 50,
      ),
    ]).animate(_controllerComplex);

    _controllerComplex.repeat();

    // 初始化粒子动画控制器
    _controllerParticle = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // 定义粒子动画
    _animationParticle =
        Tween<double>(begin: 0.0, end: 100.0).animate(_controllerParticle);

    // 开始动画
    _controllerParticle.repeat(reverse: true);
  }

  @override
  void dispose() {
    // 释放动画控制器
    _controllerSingle.dispose();
    _controllerSingleDelay.dispose();
    _controllerLoop.dispose();
    _controllerSequential.dispose();
    _controllerParallel.dispose();
    _controllerOpacity.dispose();
    _controllerScale.dispose();
    _controllerRotation.dispose();
    _controllerTranslation.dispose();
    _controller3DRotation.dispose();
    _controllerComplex.dispose();
    _controllerParticle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            singleAnimation(),
            loopAnimation(),
            sequentialAnimation(),
            parallelAnimation(),
            opacityAnimation(),
            scaleAnimation(),
            rotationAnimation(),
            translationAnimation(),
            threeDRotationAnimation(),
            complexAnimation(),
            const SizedBox(height: 500),
          ],
        ),
      ),
    );
  }

  /// 示例一：单个动画
  Widget singleAnimation() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            leading: Icon(Icons.album),
            title: Text('单个动画'),
            subtitle: Text("红色方块单个动画，执行一次 \n紫色方块延迟3秒执行一次"),
          ),
          // 红色方块动画
          AnimatedBuilder(
            animation: _animationSingle,
            builder: (context, child) {
              return Container(
                width: _animationSingle.value,
                height: 100,
                color: Colors.red,
              );
            },
          ),
          const SizedBox(height: 20),
          // 紫色方块延迟动画
          AnimatedBuilder(
            animation: _animationSingleDelay,
            builder: (context, child) {
              return Container(
                width: _animationSingleDelay.value,
                height: 100,
                color: Colors.deepPurpleAccent,
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// 示例二：循环动画
  Widget loopAnimation() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            leading: Icon(Icons.album),
            title: Text('循环执行'),
            subtitle: Text("黄色方块单个动画，循环执行"),
          ),
          // 黄色方块动画
          AnimatedBuilder(
            animation: _animationLoop,
            builder: (context, child) {
              return Container(
                width: _animationLoop.value,
                height: 100,
                color: Colors.amber,
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// 示例三：串行动画
  Widget sequentialAnimation() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            leading: Icon(Icons.album),
            title: Text('串行执行多个动画'),
            subtitle: Text("蓝色方块串行执行多个动画（宽度放大->颜色改变为红色）"),
          ),
          // 蓝色方块动画
          AnimatedBuilder(
            animation: _controllerSequential,
            builder: (context, child) {
              return Container(
                width: _animationWidthSequential.value,
                height: 100,
                color: _animationColorSequential.value,
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// 示例四：并行动画
  Widget parallelAnimation() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            leading: Icon(Icons.album),
            title: Text('并行执行多个动画（交织动画）'),
            subtitle: Text("方块同时执行多个动画（宽度放大+颜色改变为红色）"),
          ),
          // 方块动画
          AnimatedBuilder(
            animation: _controllerParallel,
            builder: (context, child) {
              return Container(
                width: _animationWidthParallel.value,
                height: 100,
                color: _animationColorParallel.value,
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// 示例五：透明度动画
  Widget opacityAnimation() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            leading: Icon(Icons.album),
            title: Text('透明度变化'),
            subtitle: Text("方块透明度从0到1变化"),
          ),
          // 透明度动画
          AnimatedBuilder(
            animation: _controllerOpacity,
            builder: (context, child) {
              return Opacity(
                opacity: _animationOpacity.value,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.blue,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// 示例六：缩放动画
  Widget scaleAnimation() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            leading: Icon(Icons.album),
            title: Text('缩放动画'),
            subtitle: Text("方块进行缩放动画"),
          ),
          // 缩放动画
          AnimatedBuilder(
            animation: _controllerScale,
            builder: (context, child) {
              return Transform.scale(
                scale: _animationScale.value,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.green,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// 示例七：旋转动画
  Widget rotationAnimation() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            leading: Icon(Icons.album),
            title: Text('旋转动画'),
            subtitle: Text("方块进行旋转动画"),
          ),
          // 旋转动画
          AnimatedBuilder(
            animation: _controllerRotation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _animationRotation.value,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.orange,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// 示例八：位移动画
  Widget translationAnimation() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            leading: Icon(Icons.album),
            title: Text('位移动画'),
            subtitle: Text("方块从父容器最左移动到最右"),
          ),
          // 位移动画
          Align(
            alignment: Alignment.centerLeft,
            child: SlideTransition(
              position: _animationTranslation,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.purple,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// 示例九：3D旋转动画
  Widget threeDRotationAnimation() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            leading: Icon(Icons.album),
            title: Text('3D旋转动画'),
            subtitle: Text("块进行3D旋转动画"),
          ),
          // 3D旋转动画
          AnimatedBuilder(
            animation: _controller3DRotation,
            builder: (context, child) {
              return Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // 设置透视
                  ..rotateY(_animation3DRotation.value),
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.teal,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// 示例十：复杂动画（加入平移动画，起始位置在最左边）
  Widget complexAnimation() {
    return SizedBox(
      // 设置容器宽度为屏幕宽度
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 自定义标题，减少内边距
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                Icon(Icons.album),
                SizedBox(width: 8),
                Text(
                  '复杂动画',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("方块从屏幕最左边移动到最右边，再返回，同时进行旋转、缩放等动画"),
          ),
          // 复杂动画
          SizedBox(
            width: double.infinity,
            height: 200, // 设置固定高度
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _controllerComplex,
                  builder: (context, child) {
                    // 获取屏幕宽度
                    double screenWidth = MediaQuery.of(context).size.width;
                    // 计算当前的位移量
                    double maxTranslation =
                        screenWidth - _animationSizeComplex.value;
                    double translationX =
                        _animationTranslationComplex.value * maxTranslation;

                    return Positioned(
                      left: translationX,
                      child: Transform.rotate(
                        angle: _animationAngleComplex.value,
                        child: Container(
                          width: _animationSizeComplex.value,
                          height: _animationSizeComplex.value,
                          decoration: BoxDecoration(
                            color: _animationColorComplex.value,
                            borderRadius: BorderRadius.circular(
                                _animationRadiusComplex.value),
                            border: Border.all(
                              color: _animationBorderColorComplex.value ??
                                  Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
