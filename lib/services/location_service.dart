import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../custom_widgets/custom_dialog_box.dart';
import '../helper/location_service_helper.dart';
import '../helper/native_ios_location_channel.dart';

enum LocationPermissionStatus {
  granted,
  serviceDisabled,
  permissionDenied,
  backgroundPermissionDenied,
}

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  bool _isTracking = false;

  bool get isTracking => _isTracking;

  Future<LocationPermissionStatus> checkAndRequestPermissions(BuildContext? context) async {
    // Check if location service is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('❌ Location services are disabled.');

      if (context != null && context.mounted) {
        // Show dialog to user
        await _showLocationServiceDialog(context);
      }
      return LocationPermissionStatus.serviceDisabled;
    }

    // Check location permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('❌ Location permission denied');
        return LocationPermissionStatus.permissionDenied;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('❌ Location permission denied forever. Please enable in settings.');
      await Geolocator.openLocationSettings();
      return LocationPermissionStatus.permissionDenied;
    }

    // For background location, we need "Always" permission
    // Request background location for Android 10+ (API 29+)
    if (Platform.isAndroid) {
      // First check if we have whileInUse permission
      if (permission == LocationPermission.whileInUse) {
        print('⚠️ You have "While Using App" permission. Requesting "Always Allow" for background tracking...');

        // Request background location permission
        final backgroundStatus = await Permission.locationAlways.request();

        if (!backgroundStatus.isGranted) {
          print('❌ Background location permission denied.');
          print('💡 Please go to Settings > Apps > Technician > Permissions > Location and select "Allow all the time"');
          return LocationPermissionStatus.backgroundPermissionDenied;
        }

        print('✅ Background location permission granted');
      }

      // Check notification permission for Android
      final notificationStatus = await Permission.notification.status;
      if (!notificationStatus.isGranted) {
        final result = await Permission.notification.request();
        if (!result.isGranted) {
          print('❌ Notification permission denied');
          return LocationPermissionStatus.permissionDenied;
        }
      }
    }

    // For iOS, check if we have "Always" permission
    if (Platform.isIOS) {
      if (permission != LocationPermission.always) {
        print('⚠️ iOS requires "Always Allow" permission for background tracking.');
        print('💡 Please go to Settings > Technician > Location and select "Always"');
        return LocationPermissionStatus.backgroundPermissionDenied;
      }
    }

    print('✅ All permissions granted');
    return LocationPermissionStatus.granted;
  }

  Future<void> _showLocationServiceDialog(BuildContext context) {
    return showConfirmDialog(
      context: context,
      title: 'Location Required',
      message: 'Location services are disabled. Please enable location to track your availability and send updates to customers.',
      positiveText: 'Open Settings',
      negativeText: 'Cancel',
      isBarrierDismissible: false,
      onPositiveTap: () async {
        Navigator.pop(context);
        await Geolocator.openLocationSettings();
      },
    );
  }

  Future<bool> startLocationTracking({BuildContext? context}) async {
    // Check actual service state, not just the flag
    if (Platform.isAndroid) {
      final isRunning = await FlutterForegroundTask.isRunningService;
      if (isRunning && _isTracking) {
        print('⚠️ Location tracking is already running');
        return true;
      }
    } else if (_isTracking) {
      print('⚠️ Location tracking is already running (iOS)');
      return true;
    }

    // Check permissions
    final permissionStatus = await checkAndRequestPermissions(context);
    if (permissionStatus != LocationPermissionStatus.granted) {
      print('❌ Cannot start tracking - permissions not granted');
      return false;
    }

    try {
      if (Platform.isAndroid) {
        await _startAndroidTracking();
      } else if (Platform.isIOS) {
        await _startIOSTracking();
      }

      _isTracking = true;
      print('✅ Location tracking started successfully');
      return true;
    } catch (e) {
      print('❌ Error starting location tracking: $e');
      return false;
    }
  }

  Future<void> _startAndroidTracking() async {
    // Check if service is already running and stop it first to prevent duplicates
    final isRunning = await FlutterForegroundTask.isRunningService;
    if (isRunning) {
      print('⚠️ Service already running, stopping it first...');
      await FlutterForegroundTask.stopService();
      await Future.delayed(const Duration(milliseconds: 500)); // Wait for service to fully stop
    }

    // Start the foreground task
    await FlutterForegroundTask.startService(
      serviceId: 256,
      notificationTitle: 'Location Tracking Active',
      notificationText: 'Sending location updates every 2 minutes',
      notificationIcon: null,
      notificationButtons: [
        const NotificationButton(id: 'stop', text: 'Stop Tracking'),
      ],
      callback: startAndroidLocationTask,
    );

    print('🤖 Android foreground service started');
  }

  Future<void> _startIOSTracking() async {
    await NativeIOSChannel.start();
    print('🍎 iOS location tracking started');
  }

  Future<void> stopLocationTracking() async {
    if (!_isTracking) {
      print('⚠️ Location tracking is not running');
      return;
    }

    try {
      if (Platform.isAndroid) {
        await FlutterForegroundTask.stopService();
        print('🤖 Android foreground service stopped');
      } else if (Platform.isIOS) {
        await NativeIOSChannel.stop();
        print('🍎 iOS location tracking stopped');
      }

      _isTracking = false;
      print('✅ Location tracking stopped successfully');
    } catch (e) {
      print('❌ Error stopping location tracking: $e');
    }
  }

  Future<Position?> getCurrentLocation({BuildContext? context}) async {
    try {
      final permissionStatus = await checkAndRequestPermissions(context);
      if (permissionStatus != LocationPermissionStatus.granted) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return position;
    } catch (e) {
      print('❌ Error getting current location: $e');
      return null;
    }
  }

  void receiveLocationUpdates(Function(int) onData) {
    if (Platform.isAndroid) {
      FlutterForegroundTask.addTaskDataCallback((data) {
        if (data is int) {
          onData(data);
        }
      });
    }
  }

  void removeLocationUpdatesCallback() {
    if (Platform.isAndroid) {
      FlutterForegroundTask.removeTaskDataCallback((data) {
        // Callback removed
      });
    }
  }
}
