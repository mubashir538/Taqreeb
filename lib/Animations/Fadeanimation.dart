import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FadeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const FadeAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(seconds: 1),
  }) : super(key: key);

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isVisible = false; // Track visibility status

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // This method triggers the fade-in animation
  void _triggerFadeIn() {
    if (!_controller.isAnimating) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _triggerFadeIn(); // Trigger fade-in when the mouse enters the widget
      },
      onExit: (_) {
        // Optionally, reverse the fade-out if you want it to disappear when the mouse exits
        // _controller.reverse();
      },
      child: VisibilityDetector(
        key: Key('fade-animation-key'),
        onVisibilityChanged: (visibilityInfo) {
          // Trigger fade-in when the widget comes into view
          if (visibilityInfo.visibleFraction > 0.1 && !_isVisible) {
            _isVisible = true;
            _triggerFadeIn();
          }
        },
        child: FadeTransition(
          opacity: _controller,
          child: widget.child,
        ),
      ),
    );
  }
}
