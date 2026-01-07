import 'dart:io';

import 'package:flutter/services.dart';
import 'package:servicemen_technician_app/helper/location_api_service.dart';

class NativeIOSChannel {
  static const _channel =
  MethodChannel('ios_location_channel');



  static void init() {
    if (!Platform.isIOS) return;

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onLocation') {
        final lat = call.arguments['lat'];
        final lng = call.arguments['lng'];

        await ApiService.sendLocation(
          lat: lat,
          lng: lng,
        );
      }
    });
  }

  static Future<void> start() async {
    if (Platform.isIOS) {
      await _channel.invokeMethod('startTracking');
    }
  }

  static Future<void> stop() async {
    if (Platform.isIOS) {
      await _channel.invokeMethod('stopTracking');
    }
  }
}
