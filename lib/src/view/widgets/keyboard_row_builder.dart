import 'package:flutter/material.dart';
import '../../../flutter_multilingual_keyboard.dart';
import '../../core/common_widgets/buttons.dart';
import '../../core/helper/keyboard_helper.dart';
import 'key_cap.dart';

class KeyboardRowBuilder {
  final KeyboardService service;
  final BuildContext context;

  KeyboardRowBuilder(this.service, this.context);

  List<Widget> buildRows() {
    List<Widget> rows = [];
    int currentIndex = 0;
    final keysPerRow = KeyboardHelpers.getKeysPerRow(service.currentMode.value);

    for (int row = 0; row < keysPerRow.length; row++) {
      rows.add(_buildRow(row, keysPerRow, currentIndex));
      currentIndex += keysPerRow[row];
    }
    return rows;
  }

  Widget _buildRow(int row, List<int> keysPerRow, int startIndex) {
    final count = keysPerRow[row];
    final isLastRow = row == keysPerRow.length - 1;
    final isLetters = service.currentMode.value == KeyboardMode.letters;
    final isNumbers = service.currentMode.value == KeyboardMode.numbers;

    const double specialButtonWidth = 48.0;

    final availableKeys = <String>[];
    for (int i = 0;
        i < count && startIndex + i < service.currentKeys.length;
        i++) {
      availableKeys.add(service.currentKeys[startIndex + i]);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : MediaQuery.of(context).size.width;

          double reserved = 0;
          if (isLastRow && isLetters) reserved += specialButtonWidth; // caps
          if (isLastRow) reserved += specialButtonWidth; // backspace

          final helperWidth = KeyboardHelpers.calculateKeyWidth(
            count,
            context.screenWidth,
            isLastRow,
            isNumbers,
          );

          final availableForKeys = (maxWidth - reserved).clamp(0.0, maxWidth);

          final keysCount = availableKeys.isEmpty ? 1 : availableKeys.length;

          double finalKeyWidth =
              helperWidth > 0 ? helperWidth : (availableForKeys / keysCount);

          if (finalKeyWidth * keysCount > availableForKeys) {
            finalKeyWidth = availableForKeys / keysCount;
          }

          if (finalKeyWidth <= 0) finalKeyWidth = availableForKeys / keysCount;

          final List<Widget> rowChildren = [];

          if (isLastRow && isLetters) {
            rowChildren.add(
              SizedBox(
                width: specialButtonWidth,
                child: ValueListenableBuilder(
                  valueListenable: service.capsState,
                  builder: (context, caps, _) {
                    return IconActionButton(
                      onTap: () => service.toggleCapsState(),
                      icon: KeyboardHelpers.getCapsIcon(caps),
                    );
                  },
                ),
              ),
            );
          }

          for (var key in availableKeys) {
            rowChildren.add(
              SizedBox(
                width: finalKeyWidth,
                child: ValueListenableBuilder(
                  valueListenable: service.capsState,
                  builder: (context, caps, _) {
                    final displayKey = KeyboardHelpers.formatKeyForDisplay(
                      key,
                      caps,
                      isLetters,
                    );
                    return KeyCap(
                      label: displayKey,
                      onTap: () => service.insertText(displayKey),
                    );
                  },
                ),
              ),
            );
          }

          if (isLastRow) {
            rowChildren.add(
              SizedBox(
                width: specialButtonWidth,
                child: GestureDetector(
                  onTapDown: (_) => service.startBackspaceHold(),
                  onTapUp: (_) => service.stopBackspaceHold(),
                  onTapCancel: () => service.stopBackspaceHold(),
                  child: IconActionButton(
                    onTap: service.backspace,
                    icon: Icons.backspace,
                  ),
                ),
              ),
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rowChildren,
          );
        },
      ),
    );
  }
}
