import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:servicemen_technician_app/providers/auth_provider.dart';
import '../helper/native_ios_location_channel.dart';
import '../models/booking_view_model.dart';
import '../helper/location_service_helper.dart';
import '../services/location_service.dart';
import '../services/repositories/auth_repository.dart';
import '../services/repositories/auth_repository_impl.dart';

class DashboardProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  bool _isOnline = false;
  int _index = 0;

  // bool isTracking = false;
  final AuthRepository authRepo = AuthRepositoryImpl();
  final List<Booking> _bookings = [
    Booking(
      id: "#ORD-20241",
      title: "AC Service & Repair",
      service: "2 x Foam Service , 3 x Gas Refill",
      slotDate: DateTime(2025, 12, 2),
      slotTime: "12:00 PM",
      statusLabel: "Pending",
      completedDate: DateTime.now(),
      cancelledDate: DateTime.now(),
      amount: 0,
      refundAmount: 0,
      status: BookingTabStatus.active,
      bookingStatus: BookingStatus.pending,
    ),
    Booking(
      id: "#ORD-00456",
      title: "Washing Machine Repair",
      service: "Front Loaded",
      slotDate: DateTime(2025, 11, 28),
      slotTime: "05:00 PM",
      statusLabel: "Assigned",
      completedDate: DateTime.now(),
      cancelledDate: DateTime.now(),
      amount: 0,
      refundAmount: 0,
      status: BookingTabStatus.active,
      bookingStatus: BookingStatus.pending,
    ),
    Booking(
      id: "#ORD-55889",
      title: "TV Repair",
      service: "LED Screen Repair",
      slotDate: DateTime(2025, 11, 26),
      slotTime: "02:00 PM",
      statusLabel: "In-Progress",
      completedDate: DateTime.now(),
      cancelledDate: DateTime.now(),
      amount: 0,
      refundAmount: 0,
      status: BookingTabStatus.active,
      bookingStatus: BookingStatus.inProgress,
    ),
    Booking(
      id: "#ORD-55889",
      title: "TV Repair",
      service: "LED Screen Repair",
      slotDate: DateTime(2025, 11, 26),
      slotTime: "02:00 PM",
      statusLabel: "Completed",
      completedDate: DateTime.now(),
      cancelledDate: DateTime.now(),
      amount: 0,
      refundAmount: 0,
      status: BookingTabStatus.completed,
      bookingStatus: BookingStatus.assigned,
    ),
    Booking(
      id: "#ORD-55889",
      title: "TV Repair",
      service: "LED Screen Repair",
      slotDate: DateTime(2025, 11, 26),
      slotTime: "02:00 PM",
      statusLabel: "Cancelled",
      amount: 340,
      refundAmount: 300,
      cancelledDate: DateTime.now(),
      completedDate: DateTime.now(),
      status: BookingTabStatus.cancelled,
      bookingStatus: BookingStatus.completed,
    ),
  ];

  int get index => _index;

  bool get isOnline => _isOnline;

  List<Booking> get bookings => _bookings;

  void changeIndex(int newIndex) {
    if (_index == newIndex) return;
    _index = newIndex;
    notifyListeners();
  }

  setOnlineStatus(BuildContext context) {
    changeOnlineStatus(context
            .read<AuthProvider>()
            .getProfileResponseModel
            ?.data
            ?.technician
            ?.isOnline ??
        false);
  }

  Future<void> startTrackingIfOnline(BuildContext context) async {
    final profileData = context.read<AuthProvider>().getProfileResponseModel;
    final isOnline = profileData?.data?.technician?.isOnline ?? false;

    print('🔍 Checking online status: isOnline = $isOnline');
    print('🔍 Profile data: ${profileData?.data?.technician?.name}');

    if (isOnline) {
      print('📍 User is online, starting location tracking...');

      // Check if already tracking
      if (LocationService().isTracking) {
        print('⚠️ Location tracking is already running, skipping...');
        return;
      }

      // Don't show toast during initialization
      final trackingStarted = await startTracking(context, showToast: false);
      if (trackingStarted) {
        print('✅ Location tracking started successfully from initState');
        // Send initial location
        _sendInitialLocation();
      } else {
        print('⚠️ Failed to start location tracking from initState');
      }
    } else {
      print('ℹ️ User is offline, skipping location tracking');
    }
  }

  void changeOnlineStatus(bool val) {
    _isOnline = val;
    notifyListeners();
  }

  Future<void> updateOnlineStatus(BuildContext context, bool val) async {
    errorMessage = null;
    notifyListeners();

    if (val == true) {
      // User wants to go online
      // First check and start location tracking
      if (context.mounted) {
        final trackingStarted = await startTracking(context);
        if (!trackingStarted) {
          // Location tracking failed (location off or permission denied)
          // Keep switch OFF
          changeOnlineStatus(false);
          notifyListeners();
          return;
        }
      }

      // Location tracking started successfully, now call API
      final cancel = BotToast.showLoading();
      try {
        final response = await authRepo.updateOnlineStatus("online");

        if (response.success) {
          // API succeeded - turn switch ON
          changeOnlineStatus(true);
          print("✅ Online status updated and tracking started");

          // Send current location immediately when going online
          _sendInitialLocation();
        } else {
          // API failed - but tracking is working, so turn switch ON anyway
          // changeOnlineStatus(true);
          errorMessage = response.error?.message;
          print(
              "⚠️ API error but tracking started: ${response.error?.message}");
          BotToast.showText(text: errorMessage ?? response.message);
        }
      } catch (e) {
        // API failed - but tracking is working, so turn switch ON anyway
        // changeOnlineStatus(true);
        errorMessage = "Something went wrong";
        print("⚠️ API error but tracking started: $e");
        BotToast.showText(text: errorMessage!);
      } finally {
        cancel();
        notifyListeners();
      }
    } else {
      // Call API to update offline status
      final cancel = BotToast.showLoading();
      try {
        final response = await authRepo.updateOnlineStatus("offline");

        if (response.success) {
          // User wants to go offline
          await stopTracking();
          changeOnlineStatus(false);
        } else {
          print("⚠️ API error on offline: ${response.error?.message}");
        }
      } catch (e) {
        print("⚠️ API error on offline: $e");
      } finally {
        cancel();
        notifyListeners();
      }
    }
  }

  Future<bool> startTracking(BuildContext context,
      {bool showToast = true}) async {
    final success =
        await LocationService().startLocationTracking(context: context);
    if (!success) {
      print("⚠️ Failed to start location tracking. Please check permissions.");
      // Only show toast if explicitly requested and context is mounted
      if (showToast && context.mounted) {
        BotToast.showText(
            text:
                "Failed to start location tracking. Please check permissions.");
      }
      return false;
    } else {
      print("✅ Location tracking started successfully");
      return true;
    }
  }

  Future<void> stopTracking() async {
    await LocationService().stopLocationTracking();
    print("🛑 Location tracking stopped");
    notifyListeners();
  }

  Future<void> logout() async {
    await stopTracking();
    // await SecureStorage.clear();
  }

  // Send location immediately when going online
  void _sendInitialLocation() async {
    try {
      final position = await LocationService().getCurrentLocation();
      if (position != null) {
        print(
            "📍 Sending initial location: ${position.latitude}, ${position.longitude}");
        final response = await authRepo.updateLocation(
            position.latitude, position.longitude);
        if (response.success) {
          print("✅ Initial location sent successfully");
        } else {
          print(
              "⚠️ Failed to send initial location: ${response.error?.message}");
        }
      } else {
        print("⚠️ Could not get current location");
      }
    } catch (e) {
      print("❌ Error sending initial location: $e");
    }
  }
}
