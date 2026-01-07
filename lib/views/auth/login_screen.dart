import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/app_image_widget.dart';
import '../../custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_text_field.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_textstyles.dart';
import '../../utils/build_extention.dart';
import '../../utils/app_functions.dart';
import '../../utils/textinput_formatter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppImages.splashImage, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: ListView(
              shrinkWrap: false,
              children: [
                Image.asset(AppImages.logoImage, height: 180),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.welcomeBack,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.sf20kBlackSemiboldTextStyle,
                    ),
                    SizedBox(height: 8),
                    Text(
                      context
                          .l10n
                          .yourServiceJourneyBeginsHereLogInEasilyWithYourMobileNumberToStartReceivingJobs,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.sf16kGreyW400TextStyle,
                    ),
                    SizedBox(height: 25),
                    Align(
                      alignment: AlignmentGeometry.centerLeft,
                      child: Text(
                        context.l10n.phoneNumber,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.sf16kBlackW400TextStyle,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 15),
                      child: CustomTextField(
                        fillColor: AppColors.kWhite,
                        controller: context
                            .read<AuthProvider>()
                            .loginPhoneNumberController,
                        prefixIcon: AppImageWidget().svgImage(
                          imageName: AppImages.indianFlagIcon,
                        ),
                        hintText: '00000-00000',
                        keyboardType: TextInputType.phone,
                        inputFormatters: [PhoneFormatter()],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 20),
                      child: GradientButton(
                        child: Text(
                          context.l10n.logIn,
                          style: AppTextStyles.sf16kWhiteMediumTextStyle,
                        ),
                        onPressed: () async {
                          final provider = context.read<AuthProvider>();

                          final cancel = BotToast.showLoading();

                          final success = await provider.requestOtp();

                          cancel(); // ALWAYS close loading

                          if (success) {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.otpVerification,
                            );
                          } else {
                            BotToast.showText(
                              text: provider.errorMessage ?? "Error",
                            );
                          }
                        },
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
