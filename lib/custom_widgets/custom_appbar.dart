// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../utils/app_textstyles.dart';
import 'app_image_widget.dart';
import 'custom_text_widget.dart';

PreferredSize CustomAppBar({
  required BuildContext context,
  String? title,
  Widget? titleColumn,
  String? image,
  List<Widget>? actionWidget,
  bool? leading = true,
  Widget? leadingWidget,
  PreferredSizeWidget? bottom,
  Color? statusBarColor,
  TextStyle? titleTextStyle,
  Color? backColor,
}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(60),
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.kTransparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.kWhite,
        elevation: 4,
        centerTitle: false,
        automaticallyImplyLeading: leading ?? false,
        leading: leading == true && leadingWidget == null
            ?IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              if (Platform.isAndroid) {
                SystemNavigator.pop(); // exit app
              }
            }
          },
          icon: SvgPicture.asset(
            AppImages.arrowBackwardIcon,
            width: 15,
            height: 15,
          ),
        )
            : leadingWidget,
        titleSpacing: leading == false ? 15 : 0,
        title:
            titleColumn ??
            CustomTextWidget(
              content: title!,
              textStyle:
                  titleTextStyle ?? AppTextStyles.sf20kBlackSemiboldTextStyle,
            ),
        actions: actionWidget,
        bottom: bottom,
      ),
    ),
  );
}
