import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:provider/provider.dart';
import 'package:servicemen_technician_app/providers/auth_provider.dart';
import 'package:servicemen_technician_app/providers/booking_provider.dart';
import 'package:servicemen_technician_app/providers/dashboard_provider.dart';
import 'package:servicemen_technician_app/services/api/api_client.dart';
import 'package:servicemen_technician_app/services/local_data/shared_pref.dart';
import 'package:servicemen_technician_app/utils/app_colors.dart';
import 'package:servicemen_technician_app/utils/app_fonts.dart';
import 'package:servicemen_technician_app/utils/app_routes.dart';
import 'package:servicemen_technician_app/utils/l10n/app_localizations.dart';
import 'package:servicemen_technician_app/utils/navigation_service.dart';

import 'helper/native_ios_location_channel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'location_service',
      channelName: 'Location Tracking',
      channelDescription: 'Sending location updates',
      channelImportance: NotificationChannelImportance.LOW,
      priority: NotificationPriority.LOW,
    ),
    foregroundTaskOptions: ForegroundTaskOptions(
      allowWakeLock: true,
      allowWifiLock: true,
      eventAction: ForegroundTaskEventAction.repeat(120000), // 2 minutes interval (120,000 milliseconds)
    ),
    iosNotificationOptions: const IOSNotificationOptions(),
  );
  if (Platform.isIOS) {
    NativeIOSChannel.init();
  }

  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // FlutterNativeSplash.remove();
    return MultiProvider(
      providers: [
        Provider(create: (_) => ApiClient()),
        Provider(create: (_) => SharedPrefService()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: BotToastInit(),
        navigatorObservers: [
          BotToastNavigatorObserver(),
        ],
        navigatorKey: NavigationService.navigatorKey,
        theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.kWhite,
            fontFamily: AppFonts.generalSans),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        initialRoute: AppRoutes.initialRoute(),
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
