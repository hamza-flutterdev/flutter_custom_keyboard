import 'package:flutter/material.dart';
import 'widgets/key_cap.dart';
import '../binders/keyboard_scope.dart';
import 'widgets/keyboard_row_builder.dart';
import '../core/enums/keyboard_enums.dart';
import '../core/common_widgets/buttons.dart';

class AppKeyboard extends StatelessWidget {
  const AppKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    final service = KeyboardScope.of(context).service;

    return ValueListenableBuilder<KeyboardLanguage>(
      valueListenable: service.currentLanguage,
      builder: (context, _, __) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 8, bottom: 24, left: 8, right: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<KeyboardMode>(
                valueListenable: service.currentMode,
                builder: (context, mode, _) {
                  return Directionality(
                    textDirection:
                        service.currentLanguage.value == KeyboardLanguage.urdu
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: Column(
                      children: KeyboardRowBuilder(
                        service,
                        context,
                      ).buildRows(),
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconActionButton(
                    onTap: service.switchLanguage,
                    icon: Icons.language,
                  ),
                  IconActionButton(
                    onTap: service.switchMode,
                    icon: Icons.keyboard,
                  ),
                  Expanded(
                    child: KeyCap(
                      label: 'Space',
                      flex: 6,
                      onTap: () => service.insertText(' '),
                    ),
                  ),
                  IconActionButton(
                    onTap: service.closeKeyboard,
                    icon: Icons.send,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
