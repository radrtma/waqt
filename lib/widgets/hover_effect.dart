import 'package:flutter/material.dart';

class HoverEffect extends StatefulWidget {
  final Widget child;
  final double scale;
  final Matrix4? transform;
  final VoidCallback? onTap;
  final HitTestBehavior behavior;

  const HoverEffect({
    Key? key,
    required this.child,
    this.scale = 1.02,
    this.transform,
    this.onTap,
    this.behavior = HitTestBehavior.opaque,
  }) : super(key: key);

  @override
  State<HoverEffect> createState() => _HoverEffectState();
}

class _HoverEffectState extends State<HoverEffect> {
  bool _isHovered = false;
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    final scale = _isTapped ? 0.95 : (_isHovered ? widget.scale : 1.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        behavior: widget.behavior,
        onTapDown: widget.onTap != null ? (_) => setState(() => _isTapped = true) : null,
        onTapUp: widget.onTap != null ? (_) => setState(() => _isTapped = false) : null,
        onTapCancel: widget.onTap != null ? () => setState(() => _isTapped = false) : null,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: widget.transform ?? Matrix4.identity()
            ..scale(scale),
          transformAlignment: Alignment.center,
          child: widget.child,
        ),
      ),
    );
  }
}
