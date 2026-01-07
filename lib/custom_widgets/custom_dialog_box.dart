import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_textstyles.dart';
import '../utils/build_extention.dart';
import 'custom_button.dart';

Future<void> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String positiveText,
  required String negativeText,
  required VoidCallback onPositiveTap,
  bool? isBarrierDismissible,
}) {
  return showDialog(
    context: context,
    barrierDismissible: isBarrierDismissible ?? true,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.kWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // 🔥 rounded
        ),
        title: Text(title, style:AppTextStyles.sf20kBlackSemiboldTextStyle),
        content: Text(message,style:AppTextStyles.sf14kBlackW400TextStyle),
        actions: [
          SizedBox(
            width: context.width,
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: CustomOutlineButton(
                    color: AppColors.kPrimaryColor,
                    borderRadius: BorderRadius.circular(8),
                    child: Text(
                      negativeText,
                      style: AppTextStyles.sf16kPrimaryColorMediumTextStyle,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(flex: 1,child: Container()),
                Expanded(
                  flex: 7,
                  child: GradientButton(
                      child: Text(
                        positiveText,
                        style: AppTextStyles.sf16kWhiteMediumTextStyle,
                      ),
                      onPressed:onPositiveTap
                  ),
                ),
              ],
            ),
          ),


        ],
      );
    },
  );
}
