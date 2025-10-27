import 'package:flutter/material.dart';
import '../../binders/keyboard_scope.dart';

class KeyCap extends StatelessWidget {
  final String label;
  final double? width;
  final VoidCallback onTap;
  final int flex;

  const KeyCap({
    super.key,
    required this.label,
    required this.onTap,
    this.width,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    final controller = KeyboardScope.of(context).controller;
    final notifier = controller.pressedNotifier(label);

    final calculatedWidth =
        width ??
        (flex == 6
            ? MediaQuery.of(context).size.width * 0.16
            : MediaQuery.of(context).size.width * 0.084);

    return Listener(
      onPointerDown: (_) => controller.setPressed(label, true),
      onPointerUp: (_) {
        controller.setPressed(label, false);
        onTap();
      },
      onPointerCancel: (_) => controller.setPressed(label, false),
      child: ValueListenableBuilder<bool>(
        valueListenable: notifier,
        builder: (context, isPressed, child) {
          return AnimatedScale(
            scale: isPressed ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 60),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 60),
              width: calculatedWidth,
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
                color: isPressed ? Colors.grey[300] : Colors.black12,
                boxShadow: isPressed
                    ? [
                        BoxShadow(
                          color: Colors.black26,
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ]
                    : [],
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
