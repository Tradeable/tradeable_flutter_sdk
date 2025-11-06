import 'package:flutter/material.dart';

class BouncingWidget extends StatefulWidget {
  final Widget child;

  const BouncingWidget({super.key, required this.child});

  @override
  State<BouncingWidget> createState() => _BouncingWidgetState();
}

class _BouncingWidgetState extends State<BouncingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offset;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);
    _offset = Tween<double>(begin: 0, end: -20)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.bounceIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offset,
      builder: (context, child) =>
          Transform.translate(offset: Offset(0, _offset.value), child: child),
      child: widget.child,
    );
  }
}
