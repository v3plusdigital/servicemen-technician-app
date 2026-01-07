import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:servicemen_technician_app/helper/location_api_service.dart';

@pragma('vm:entry-point')
void startAndroidLocationTask() {
  FlutterForegroundTask.setTaskHandler(AndroidLocationTask());
}

class AndroidLocationTask extends TaskHandler {
  int _eventCount = 0;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print('🔥 Android background task started at ${timestamp.toString()}');
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {
    _eventCount++;
    print('🔄 Repeat event #$_eventCount at ${timestamp.toString()}');

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('❌ Location services are disabled. Please enable location services.');
        FlutterForegroundTask.sendDataToMain(_eventCount);
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print('❌ Location permission not granted: $permission');
        FlutterForegroundTask.sendDataToMain(_eventCount);
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      print('📍 Location: ${position.latitude}, ${position.longitude}');

      // Send location to backend
      await ApiService.sendLocation(
        lat: position.latitude,
        lng: position.longitude,
      );

      print('✅ Location sent successfully');
    } catch (e) {
      print('❌ Error getting/sending location: $e');
    }

    // Send data to main isolate
    FlutterForegroundTask.sendDataToMain(_eventCount);
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    print('🛑 Task destroyed at ${timestamp.toString()}. timeout=$isTimeout');
  }

  @override
  void onNotificationButtonPressed(String id) {
    print('🔔 Notification button pressed: $id');
  }

  @override
  void onNotificationPressed() {
    print('🔔 Notification pressed');
    FlutterForegroundTask.launchApp('/');
  }
}
