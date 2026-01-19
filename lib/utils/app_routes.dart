import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicemen_technician_app/providers/dashboard_provider.dart';
import '../models/booking_view_model.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/otp_verification_screen.dart';
import '../views/auth/profile_information_screen.dart';
import '../views/auth/splash_screen.dart';
import '../views/booking/booking_detail_screen.dart';
import '../views/dashboard/home_screen.dart';

class AppRoutes {
  static const String splash = '/Splash';
  static const String onBoarding = '/onBoarding';
  static const String login = '/login';
  static const String home = '/home';
  static const String otpVerification = '/otpVerification';
  static const String profileInformation = '/profileInformation';
  static const String chooseAddress = '/chooseAddress';
  static const String serviceProductsList = '/serviceProductsList';
  static const String orderSummary = '/orderSummary';
  static const String addressList = '/addressList';
  static const String cart = '/cart';
  static const String booking = '/booking';
  static const String bookingDetails = '/bookingDetails';

  static String initialRoute() {
    return splash;
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case otpVerification:
        return MaterialPageRoute(builder: (_) => const OtpVerificationScreen());

      case profileInformation:
        return MaterialPageRoute(
          builder: (_) =>  ProfileInformationScreen(),
        );
     case home:
        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: [
               ChangeNotifierProvider(create: (_) => DashboardProvider()),
            ],
            child: const HomeScreen(),
          ),
        );
      case bookingDetails:
        final booking = settings.arguments as Booking;
        return MaterialPageRoute(
          builder: (_) => BookingDetailScreen(booking: booking),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
