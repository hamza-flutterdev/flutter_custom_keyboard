import 'package:flutter/widgets.dart';
import '../services/keyboard_service.dart';
import '../controller/app_keyboard_controller.dart';

class KeyboardScope extends InheritedWidget {
  final KeyboardService service;
  final AppKeyboardController controller;

  const KeyboardScope({
    required this.service,
    required this.controller,
    required super.child,
    super.key,
  });

  static KeyboardScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<KeyboardScope>();
    if (scope == null) {
      throw FlutterError(
        'KeyboardScope not found in widget tree. Make sure to wrap your app with KeyboardScope.',
      );
    }
    return scope;
  }

  @override
  bool updateShouldNotify(covariant KeyboardScope oldWidget) {
    return service != oldWidget.service || controller != oldWidget.controller;
  }
}
