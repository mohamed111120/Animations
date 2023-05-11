import 'dart:math';

import 'package:flutter/material.dart';

class FristAnimation extends StatefulWidget {
  const FristAnimation({super.key});

  @override
  State<FristAnimation> createState() => _FristAnimationState();
}

class _FristAnimationState extends State<FristAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.0, end: 2 * pi).animate(_controller);
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..rotateZ(_animation.value),
            child: Container(
              height: 100,
              width: 100,
              color: Colors.blue,
            ),
          );
          },
        ),
      ),
    );
  }
}
