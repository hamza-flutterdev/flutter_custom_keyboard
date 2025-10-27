# flutter_multilingual_keyboard

A fully customizable Flutter on-screen keyboard widget with multi-language support.  
Built entirely in Flutter.

---

## ✨ Features

- 🈳 Multi-language support (e.g. English, Urdu)
- 🔠 Caps, first-capital, and small letter states
- 🔢 Letters, numbers, and symbols modes
- 🎨 Smooth key press animations
- 💡 Works with any `TextField` or `TextEditingController`
- 🚫 No native code or external state management (pure Flutter)

---

## 🚀 Installation

Add to your `pubspec.yaml`: 

```yaml
dependencies:
  flutter_multilingual_keyboard: ^1.1.2
```
Or Simply Run in `Terminal`
```yaml
  flutter pub add flutter_multilingual_keyboard
```

## 🚀 Usage

```dart
import 'package:flutter_multilingual_keyboard/flutter_multilingual_keyboard.dart';

final service = KeyboardService();
final controller = AppKeyboardController();

KeyboardScope(
  service: service,
  controller: controller,
  child: MyApp(),
);

```
## Then Use:

```dart
ValueListenableBuilder<bool>(
valueListenable: service.showKeyboard,
builder: (_, show, __) => show ? const AppKeyboard() : const SizedBox(),
)
```

---

1.1.2

## Initial release:

- Added English, Japanese, and Urdu language support
- Added caps modes and key animations
