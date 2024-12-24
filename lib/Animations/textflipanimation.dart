import 'package:flutter/material.dart';

class ShakeTextAnimation extends StatefulWidget {
  final Widget child;

  const ShakeTextAnimation({super.key, required this.child});

  @override
  _ShakeTextAnimationState createState() => _ShakeTextAnimationState();
}

class _ShakeTextAnimationState extends State<ShakeTextAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1))..repeat();
    _shakeAnimation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.1, 0.0)).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _shakeAnimation,
      child: widget.child,
    );
  }
}
