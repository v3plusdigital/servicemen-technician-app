import 'dart:io';

import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../utils/app_textstyles.dart';
import '../utils/build_extention.dart';
import '../utils/image_picker_helper.dart';
import 'app_image_widget.dart';

void showImagePickerBottomSheet(
  BuildContext context,
  Function(File file) onImageSelected,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: AppColors.kWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Choose image from",
                      style: AppTextStyles.sf20kBlackSemiboldTextStyle,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: AppImageWidget().svgImage(
                      imageName: AppImages.closeIcon,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () async {
                  final file = await ImagePickerHelper.pickFromCamera();
                  if (file != null) onImageSelected(file);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () async {
                  final file = await ImagePickerHelper.pickFromGallery();
                  if (file != null) onImageSelected(file);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showUploadOrDeleteProfilePictureBottomSheet(
  BuildContext context,
  Function(bool isDelete) onOptionSelected,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: AppColors.kWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: AppImageWidget().svgImage(
                      imageName: AppImages.closeIcon,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  onOptionSelected(false);
                },
                child: Text(
                  "Upload profile photo",
                  style: AppTextStyles.sf16kBlackW400TextStyle,
                ),
              ),
              Divider(color: AppColors.kGrey1, thickness: 1, height: 20),
              GestureDetector(
                onTap: () {
                  onOptionSelected(true);
                },
                child: Text(
                  "Delete profile photo",
                  style: AppTextStyles.sf16kBlackW400TextStyle,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
