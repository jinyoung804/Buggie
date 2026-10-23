import 'package:flutter/services.dart';

class OverlayService {
  static const MethodChannel _channel =
  MethodChannel('com.buggie/overlay');

  static Future<bool> requestPermission() async {
    return await _channel.invokeMethod<bool>(
      'requestOverlayPermission',
    ) ??
        false;
  }

  static Future<bool> show() async {
    return await _channel.invokeMethod<bool>(
      'showTestOverlay',
    ) ??
        false;
  }

  static Future<void> hide() async {
    await _channel.invokeMethod('hideOverlay');
  }
}