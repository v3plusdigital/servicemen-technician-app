import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;
  final double? width;
  final double? height;

  final BorderRadiusGeometry? borderRadius;
  final double? elevation;
  final Color? color;
  final ButtonStyle? style;
  final EdgeInsets? paddingContent;

  const CustomButton({
    super.key,
    required this.child,
    this.onPressed,
    this.width,
    this.height = 45,
    this.borderRadius,
    this.elevation = 0,
    this.color,
    this.style,
    this.paddingContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: color ?? AppColors.kPrimaryColor,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style:
            style ??
            ElevatedButton.styleFrom(
              backgroundColor: AppColors.kTransparent,
              shadowColor: AppColors.kTransparent,
              padding: paddingContent,
              // disabledBackgroundColor: AppColors.kGrey200,
              elevation: elevation,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(8),
              ),
            ),
        child: child,
      ),
    );
  }
}

class CustomOutlineButton extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;
  final double? width;
  final double? height;

  final BorderRadiusGeometry? borderRadius;
  final double? elevation;
  final Color? color;
  final ButtonStyle? style;
  final EdgeInsets? paddingContent;

  const CustomOutlineButton({
    super.key,
    required this.child,
    this.onPressed,
    this.width,
    this.height = 45,
    this.borderRadius,
    this.elevation = 0,
    this.color,
    this.style,
    this.paddingContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.zero,
      // decoration: BoxDecoration(
      //   color: color ?? AppColors.kPrimaryColor,
      //   borderRadius: borderRadius ?? BorderRadius.circular(12),
      // ),
      child: TextButton(
        onPressed: onPressed,
        style:
            style ??
            TextButton.styleFrom(
              backgroundColor: AppColors.kTransparent,
              // shadowColor: AppColors.kGrey1,
              padding: paddingContent,
              // disabledBackgroundColor: AppColors.kGrey200,
              elevation: elevation,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(8),
                side: BorderSide(color: color??AppColors.kGrey1),
              ),
            ),
        child: child,
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double? radius;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
     this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius??8),
          color: AppColors.kPrimaryColor,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius??8),

            // overlay fade
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.3,1],
              colors: [

                AppColors.kPrimaryColor,
                AppColors.kPrimaryColorLight,
                // Color.fromRGBO(255, 255, 255, 0.12),
                // Color.fromRGBO(255, 255, 255, 0),
              ],
            ),
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
