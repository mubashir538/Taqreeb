import 'package:flutter/material.dart';

class BounceAnimation extends StatefulWidget {
  final Widget child;

  const BounceAnimation({Key? key, required this.child}) : super(key: key);

  @override
  _BounceAnimationState createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<BounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800), 
    )..repeat(reverse: true);
    _bounceAnimation = Tween<double>(
      begin: 0.95, 
      end: 1.05,  
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, 
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _bounceAnimation,
      child: widget.child,
    );
  }
}
