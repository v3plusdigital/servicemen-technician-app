import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../custom_widgets/app_image_widget.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_images.dart';
import '../../utils/app_routes.dart';
import '../../utils/build_extention.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final auth = context.read<AuthProvider>();
    await auth.checkStatus();

    if (!mounted) return;
    Future.delayed(Duration(seconds: 2), () async {
      if (!auth.isLoggedIn) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (v) => false,
        );
      } else if (auth.isNewUser) {
        final cancel = BotToast.showLoading();
        final futures = [
          auth.getServiceArea().catchError((_) => null),
          auth.getServicesCategories().catchError((_) => null),
          auth.getExperience().catchError((_) => null),
        ];

        await Future.wait(futures);

        cancel(); // ALWAYS close loading

        auth.clearProfileValue();
        auth.getProfile(context).then((v){
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.profileInformation,
                (v) => false,
          );
        });

      } else {
       await auth.getProfile(context).then((v){
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
                (v) => false,
          );
        });

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AppImageWidget().customNetworkImage(
              radius: 0,
              image: AppImages.splashImage,
            ),
          ),
          Align(
            alignment: AlignmentGeometry.center,
            child: AppImageWidget().customNetworkImage(
              image: AppImages.logoImage,
              width: context.wp(0.5),
              height: context.wp(0.5),
              radius: 0,
            ),
          ),
        ],
      ),
    );
  }
}
