import 'package:flutter/material.dart';
import 'package:flutter_custom_keyboard/flutter_custom_keyboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // load packaged asset
  await KeyboardLanguageService.load(packageName: 'flutter_custom_keyboard');

  // create instances (the app controls lifecycle)
  final service = KeyboardService();
  final controller = AppKeyboardController();

  runApp(
    KeyboardScope(
      service: service,
      controller: controller,
      child: const ExampleApp(),
    ),
  );
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Keyboard Example', home: const ExampleHome());
  }
}

class ExampleHome extends StatefulWidget {
  const ExampleHome({super.key});

  @override
  State<ExampleHome> createState() => _ExampleHomeState();
}

class _ExampleHomeState extends State<ExampleHome> {
  final firstNameController = TextEditingController();
  final firstFocus = FocusNode();
  final lastNameController = TextEditingController();
  final lastFocus = FocusNode();

  // add a key for the keyboard
  final GlobalKey _keyboardKey = GlobalKey();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    firstFocus.dispose();
    lastFocus.dispose();
    super.dispose();
  }

  bool _tapIsInsideKeyboard(Offset globalPosition) {
    final kContext = _keyboardKey.currentContext;
    if (kContext == null) return false; // keyboard not mounted
    final box = kContext.findRenderObject() as RenderBox;
    final local = box.globalToLocal(globalPosition);
    return local.dx >= 0 &&
        local.dy >= 0 &&
        local.dx <= box.size.width &&
        local.dy <= box.size.height;
  }

  @override
  Widget build(BuildContext context) {
    final service = KeyboardScope.of(context).service;
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTapDown: (details) {
        // ignore taps that land inside our custom keyboard
        if (_tapIsInsideKeyboard(details.globalPosition)) return;
        service.handleTapDown(context, details.globalPosition);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Custom Keyboard'), centerTitle: true),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: firstNameController,
                    focusNode: firstFocus,
                    readOnly: true,
                    showCursor: true,
                    decoration: const InputDecoration(
                      labelText: 'First name',
                      border: OutlineInputBorder(),
                    ),
                    onTap: () => service.openKeyboardFor(
                      firstNameController,
                      firstFocus,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: lastNameController,
                    focusNode: lastFocus,
                    readOnly: true,
                    showCursor: true,
                    decoration: const InputDecoration(
                      labelText: 'Last name',
                      border: OutlineInputBorder(),
                    ),
                    onTap: () =>
                        service.openKeyboardFor(lastNameController, lastFocus),
                  ),
                ],
              ),
            ),
            const Spacer(),
            ValueListenableBuilder<bool>(
              valueListenable: service.showKeyboard,
              builder: (context, show, _) {
                // pass the key
                return show
                    ? AppKeyboard(key: _keyboardKey)
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
