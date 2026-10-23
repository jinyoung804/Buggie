import 'package:flutter/services.dart';

class OverlayService {
  static const MethodChannel _channel =
  MethodChannel('com.buggie/overlay');

  static Future<void> requestPermission() async {
    await _channel.invokeMethod('requestOverlayPermission');
  }

  static Future<void> showTestOverlay() async {
    await _channel.invokeMethod('showOverlayTest');
  }

  static Future<void> hideOverlay() async {
    await _channel.invokeMethod('hideOverlay');
  }
}