import 'package:flutter/material.dart';

class IconActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final Color? color;
  final double? size;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final bool isCircular;
  final String? tooltip;

  const IconActionButton({
    super.key,
    required this.onTap,
    required this.icon,
    this.color,
    this.size,
    this.padding = const EdgeInsets.all(8),
    this.backgroundColor,
    this.isCircular = false,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedSize = size;

    return Tooltip(
      message: tooltip ?? '',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isCircular ? null : BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: resolvedSize),
        ),
      ),
    );
  }
}
