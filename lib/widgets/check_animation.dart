import 'package:flutter/material.dart';

class CheckAnimation extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  const CheckAnimation({
    super.key,
    this.size = 80.0,
    this.color = const Color(0xFF10B981),
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<CheckAnimation> createState() => _CheckAnimationState();
}

class _CheckAnimationState extends State<CheckAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: widget.color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: ScaleTransition(
        scale: _animation,
        child: Icon(
          Icons.check,
          color: widget.color,
          size: widget.size * 0.5,
        ),
      ),
    );
  }
}
