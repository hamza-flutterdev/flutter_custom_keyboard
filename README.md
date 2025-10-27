# flutter_custom_keyboard

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
  flutter_custom_keyboard: ^1.1.2
```
Or
```yaml
  flutter pub add flutter_custom_keyboard
```

## 🚀 Usage

```dart
import 'package:flutter_keyboard_package/flutter_keyboard_package.dart';

final service = KeyboardService();
final controller = AppKeyboardController();

KeyboardScope(
  service: service,
  controller: controller,
  child: MyApp(),
);