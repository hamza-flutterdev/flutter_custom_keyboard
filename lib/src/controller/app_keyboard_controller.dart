import 'package:flutter/foundation.dart';

class AppKeyboardController {
  final Map<String, ValueNotifier<bool>> pressedKeys = {};

  void setPressed(String key, bool isPressed) {
    pressedKeys.putIfAbsent(key, () => ValueNotifier<bool>(false));
    pressedKeys[key]!.value = isPressed;
  }

  ValueNotifier<bool> pressedNotifier(String key) {
    return pressedKeys.putIfAbsent(key, () => ValueNotifier<bool>(false));
  }

  bool isPressed(String key) {
    return pressedKeys[key]?.value ?? false;
  }

  void dispose() {
    for (final v in pressedKeys.values) {
      v.dispose();
    }
    pressedKeys.clear();
  }
}
