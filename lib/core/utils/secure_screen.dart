import 'dart:io';
import 'package:flutter/services.dart';

class SecureScreen {
  static const MethodChannel _channel = MethodChannel('secure_screen');

  static Future<void> enable() async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('enable');
    } catch (_) {}
  }

  static Future<void> disable() async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('disable');
    } catch (_) {}
  }
}
