import 'dart:async';
import 'package:flutter/material.dart';
import '../core/enums/keyboard_enums.dart';
import '../core/global_keys/global_keys.dart';
import '../services/keyboard_language_service.dart';

class KeyboardService {
  final ValueNotifier<bool> showKeyboard = ValueNotifier<bool>(false);
  final ValueNotifier<CapsState> capsState = ValueNotifier<CapsState>(
    CapsState.small,
  );
  final ValueNotifier<KeyboardLanguage> currentLanguage =
      ValueNotifier<KeyboardLanguage>(KeyboardLanguage.english);
  final ValueNotifier<KeyboardMode> currentMode = ValueNotifier<KeyboardMode>(
    KeyboardMode.letters,
  );

  TextEditingController? _activeController;
  FocusNode? activeFocus;
  Timer? _backspaceTimer;

  List<String> get currentKeys {
    final languageKey = currentLanguage.value.name;
    final modeKey = currentMode.value.name;
    final data = KeyboardLanguageService.data;
    final keys = data[languageKey]?[modeKey];
    if (keys == null) return [];
    return List<String>.from(keys);
  }

  void openKeyboardFor(TextEditingController controller, FocusNode focus) {
    _activeController = controller;
    activeFocus = focus;
    showKeyboard.value = true;
    focus.requestFocus();
  }

  void closeKeyboard() {
    showKeyboard.value = false;
    _activeController = null;
    activeFocus = null;
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void handleTapDown(BuildContext context, Offset tapPosition) {
    if (!showKeyboard.value) return;
    final renderBox =
        globalKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      closeKeyboard();
      return;
    }
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final rect = Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
    if (!rect.contains(tapPosition)) closeKeyboard();
  }

  void insertText(String text) {
    if (_activeController == null) return;
    final sel = _activeController!.selection;
    final full = _activeController!.text;
    final start = sel.start >= 0 ? sel.start : full.length;
    final end = sel.end >= 0 ? sel.end : full.length;

    _activeController!.value = TextEditingValue(
      text: full.replaceRange(start, end, text),
      selection: TextSelection.collapsed(offset: start + text.length),
    );

    if (capsState.value == CapsState.firstCapital) {
      capsState.value = CapsState.small;
    }
  }

  void backspace() {
    if (_activeController == null) return;
    final sel = _activeController!.selection;
    final full = _activeController!.text;
    final start = sel.start >= 0 ? sel.start : full.length;
    final end = sel.end >= 0 ? sel.end : full.length;

    if (start != end) {
      _activeController!.value = TextEditingValue(
        text: full.replaceRange(start, end, ''),
        selection: TextSelection.collapsed(offset: start),
      );
      return;
    }

    if (start == 0) return;
    _activeController!.value = TextEditingValue(
      text: full.replaceRange(start - 1, start, ''),
      selection: TextSelection.collapsed(offset: start - 1),
    );
  }

  void startBackspaceHold() {
    backspace();
    _backspaceTimer?.cancel();
    _backspaceTimer = Timer.periodic(
      const Duration(milliseconds: 120),
      (_) => backspace(),
    );
  }

  void stopBackspaceHold() {
    _backspaceTimer?.cancel();
    _backspaceTimer = null;
  }

  void toggleCapsState() {
    final next =
        CapsState.values[(capsState.value.index + 1) % CapsState.values.length];
    capsState.value = next;
  }

  void switchLanguage() {
    final next =
        KeyboardLanguage.values[(currentLanguage.value.index + 1) %
            KeyboardLanguage.values.length];
    currentLanguage.value = next;
    capsState.value = CapsState.small;
  }

  void switchMode() {
    final next = KeyboardMode
        .values[(currentMode.value.index + 1) % KeyboardMode.values.length];
    currentMode.value = next;
    capsState.value = CapsState.small;
  }

  void dispose() {
    _backspaceTimer?.cancel();
    showKeyboard.dispose();
    capsState.dispose();
    currentLanguage.dispose();
    currentMode.dispose();
  }
}
