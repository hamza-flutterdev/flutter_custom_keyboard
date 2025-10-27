import 'package:flutter/material.dart';
import '../enums/keyboard_enums.dart';

class KeyboardHelpers {
  static List<int> getKeysPerRow(KeyboardMode mode) {
    return mode == KeyboardMode.numbers ? [3, 3, 3, 1] : [10, 9, 7];
  }

  static IconData getCapsIcon(CapsState state) {
    return state == CapsState.allCapital ? Icons.lock : Icons.arrow_upward;
  }

  static String formatKeyForDisplay(
    String key,
    CapsState capsState,
    bool isLetters,
  ) {
    if (!isLetters) return key;
    return capsState == CapsState.small ? key.toLowerCase() : key.toUpperCase();
  }

  static double calculateKeyWidth(
    int count,
    double screenWidth,
    bool isLastRow,
    bool isNumbers,
  ) {
    double totalWidth = screenWidth - ((count + 1) * 16);
    double backspaceWidth = isLastRow && isNumbers ? 48 : 0;
    return isNumbers ? (totalWidth - backspaceWidth) / count : 0;
  }
}
