import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:5050";
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return "http://10.0.2.2:5050";
      case TargetPlatform.iOS:
        return "http://localhost:5050";
      default:
        return "http://localhost:5050";
    }
  }
}
