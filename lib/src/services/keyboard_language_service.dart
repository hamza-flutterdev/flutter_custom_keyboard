import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class KeyboardLanguageService {
  static Map<String, dynamic>? _cachedData;

  /// Call like: await KeyboardLanguageService.load(packageName: 'flutter_keyboard_package');
  static Future<void> load({String? packageName}) async {
    if (_cachedData != null) return;

    String jsonString;
    final pkgPath = packageName != null
        ? 'packages/$packageName/assets/keyboards.json'
        : null;

    try {
      if (pkgPath != null) {
        jsonString = await rootBundle.loadString(pkgPath);
      } else {
        throw Exception('packageName null'); // falls through to fallback
      }
    } catch (_) {
      // fallback to top-level assets
      jsonString = await rootBundle.loadString('assets/keyboards.json');
    }

    _cachedData = json.decode(jsonString) as Map<String, dynamic>;
  }

  static Map<String, dynamic> get data {
    if (_cachedData == null) {
      throw Exception(
        'Keyboard data not loaded yet. Call KeyboardLanguageService.load() first.',
      );
    }
    return _cachedData!;
  }
}
