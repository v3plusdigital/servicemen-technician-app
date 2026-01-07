import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicemen_technician_app/views/auth/widgets/otp_fields_widget.dart';

import '../../custom_widgets/app_image_widget.dart';
import '../../custom_widgets/custom_appbar.dart';
import '../../custom_widgets/custom_button.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_images.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_textstyles.dart';
import '../../utils/build_extention.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        context: context,
        title: context.l10n.verificationCode,
      ),
      bottomNavigationBar:  SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 12,
          ),
          child: GradientButton(
            child: Text(
              context.l10n.verify,
              style: AppTextStyles.sf16kWhiteMediumTextStyle,
            ),
            onPressed: () async {
              final provider = context.read<AuthProvider>();

              final cancel = BotToast.showLoading();

              final success = await provider.verifyOtp();
              provider.getServiceArea();
              provider.getServicesCategories();
              provider.getExperience();
              cancel(); // ALWAYS close loading

              if (success) {
                // Navigator.pushNamed(context, AppRoutes.profileInformation);
                if (provider.verifyOtpModel?.data?.isNewUser == true) {
                  provider.clearProfileValue();
                  Navigator.pushNamed(context, AppRoutes.profileInformation);
                } else {
                  Navigator.pushNamed(context, AppRoutes.home);
                }
              } else {
                BotToast.showText(text: provider.errorMessage ?? "Error");
              }
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            AppImageWidget().svgImage(
              imageName: AppImages.otpVerificationLockIcon,
            ),

            const SizedBox(height: 20),

            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Text(
                context.l10n.enter6DigitCode,
                style: AppTextStyles.sf20kBlackMediumTextStyle,
              ),
            ),

            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: context.l10n.weSentAVerificationCodeToYourPhoneNumber,
                    style: AppTextStyles.sf16kGreyW400TextStyle,
                  ),
                  TextSpan(
                    text:
                        " +91 ${context.read<AuthProvider>().loginPhoneNumberController.text} ",
                    style: AppTextStyles.sf16kGreyW400TextStyle,
                  ),
                  TextSpan(
                    text: context.l10n.change,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pop(context);
                      },
                    style: AppTextStyles.sf16kPrimaryW400TextStyle.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),
            OtpFields(
              length: 6,
              onCompleted: (code) {
                print("OTP Completed = $code");
              },
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Text(
                  context.l10n.youDidntReceivedAnyCode,
                  style: AppTextStyles.sf16kGreyW400TextStyle,
                ),
                SizedBox(height: 5),
                Selector<AuthProvider, int>(
                  selector: (_, p) => p.secondsLeft,
                  builder: (_, seconds, __) {
                    final min = seconds ~/ 60;
                    final sec = seconds % 60;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: context.read<AuthProvider>().secondsLeft == 0
                              ? () async {
                                  final provider = context.read<AuthProvider>();

                                  final cancel = BotToast.showLoading();

                                  final success = await provider.requestOtp();

                                  cancel(); // ALWAYS close loading

                                  if (success) {
                                    BotToast.showText(
                                      text: "OTP sent successfully",
                                    );
                                  } else {
                                    BotToast.showText(
                                      text:
                                          provider.errorMessage ??
                                          "Something went wrong",
                                    );
                                  }
                                }
                              : null,
                          child: Text(
                            context.l10n.resendCode,
                            style: context.read<AuthProvider>().secondsLeft != 0
                                ? AppTextStyles.sf16kGreyW400TextStyle
                                : AppTextStyles.sf16kPrimaryW400TextStyle
                                      .copyWith(
                                        decoration: TextDecoration.underline,
                                      ),
                          ),
                        ),
                        context.read<AuthProvider>().secondsLeft != 0? Text(
                          " - ${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}",
                          style: const TextStyle(fontSize: 16),
                        ):Container(),
                      ],
                    );
                  },
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
