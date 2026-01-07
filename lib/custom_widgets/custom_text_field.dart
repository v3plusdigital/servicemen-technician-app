// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_colors.dart';
import '../utils/app_textstyles.dart';


class CustomTextField extends StatelessWidget {
  final bool? isVisible;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextStyle? textStyle;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final String? hintText;
  final TextStyle? hintStyle;
  final double? height;
  final double? width;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextEditingController? repeatController;
  final void Function(String)? onFieldSubmitted;
  final int? maxLength;
  final double borderRadius;
  final Color? fillColor;
  final double borderWidth;
  final TextAlign textAlign;
  final BoxConstraints? suffixIconConstraints;
  final String? suffixText;
  final Function()? onEditingComplete;
  final Function()? onTap;
  final Color? borderColor;
  final BorderRadius? borderR;
  final Widget? label;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool? allowBorder;
  final double? cursorHeight;
  final bool? readOnly;
  final double? contentHorizontalPadding;
  final double? contentVerticalPadding;

  const CustomTextField(
      {super.key,
      this.controller,
      this.onChanged,
      this.hintText,
      this.height,
      this.width,
      this.keyboardType,
      this.maxLines = 1,
      this.inputFormatters,
      this.validator,
      this.repeatController,
      this.isVisible,
      this.suffixIcon,
      this.prefixIcon,
      this.onFieldSubmitted,
      this.maxLength,
      this.borderRadius = 8,
      this.fillColor ,
      this.borderWidth = 1,
      this.onEditingComplete,
      this.suffixIconConstraints,
      this.textAlign = TextAlign.start,
      this.suffixText,
      this.textStyle,
      this.hintStyle,
      this.borderColor,
      this.borderR,
      this.label,
      this.autofocus = false,
      this.focusNode,
      this.allowBorder = true,
      this.cursorHeight,
      this.readOnly = false,
      this.onTap,
      this.contentHorizontalPadding,
      this.contentVerticalPadding});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        onTap: onTap,
        autofocus: autofocus,
        cursorHeight: cursorHeight,
        onEditingComplete: onEditingComplete,
        autocorrect: false,
        focusNode: focusNode,
        obscureText: isVisible ?? false,
        style: textStyle ?? AppTextStyles.sf14kBlackW400TextStyle,
        inputFormatters: inputFormatters,
        textAlignVertical: TextAlignVertical.center,
        maxLines: maxLines,
        keyboardType: keyboardType,
        controller: controller,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        cursorColor: AppColors.kPrimaryColor,
        validator: validator,
        textAlign: textAlign,
        maxLength: maxLength,
        readOnly: readOnly!,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            suffixText: suffixText,
            isDense: true,
            counterText: "",
            // suffixStyle: AppTextStyles.os12w400,
            suffixIconConstraints: suffixIconConstraints,
            label: label,
            hintStyle: hintStyle ?? AppTextStyles.sf14kGreyW400TextStyle,
            filled:fillColor!=null?true: false,
            fillColor: fillColor??AppColors.kTransparent,
            contentPadding: EdgeInsets.symmetric(
              horizontal: contentHorizontalPadding ?? 16,
              vertical: contentVerticalPadding ?? 18,
            ),
            hintText: hintText,
            errorBorder: allowBorder == false
                ? InputBorder.none
                : OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.kRed,
                    ),
                    borderRadius:
                        borderR ?? BorderRadius.circular(borderRadius),
                  ),
            enabledBorder: allowBorder == false
                ? InputBorder.none
                : OutlineInputBorder(
                    borderSide: BorderSide(
                      color: borderColor??AppColors.kGrey1,
                      width: borderWidth,
                    ),
                    borderRadius:
                        borderR ?? BorderRadius.circular(borderRadius),
                  ),
            border: allowBorder == false
                ? InputBorder.none
                : OutlineInputBorder(
                    borderSide: BorderSide(
                      color: borderColor??AppColors.kGrey1,
                      width: borderWidth,
                    ),
                    borderRadius:
                        borderR ?? BorderRadius.circular(borderRadius),
                  ),
            focusedErrorBorder: allowBorder == false
                ? InputBorder.none
                : OutlineInputBorder(
                    borderSide: BorderSide(
                      color: borderColor??AppColors.kRed,
                      width: borderWidth,
                    ),
                    borderRadius:
                        borderR ?? BorderRadius.circular(borderRadius),
                  ),
            disabledBorder: allowBorder == false
                ? InputBorder.none
                : OutlineInputBorder(
                    borderSide: BorderSide(
                      color: borderColor??AppColors.kGrey1,
                      width: borderWidth,
                    ),
                    borderRadius:
                        borderR ?? BorderRadius.circular(borderRadius),
                  ),
            focusedBorder: allowBorder == false
                ? InputBorder.none
                : OutlineInputBorder(
                    borderSide: BorderSide(
                      color: borderColor??AppColors.kGrey1,
                      width: borderWidth,
                    ),
                    borderRadius:
                        borderR ?? BorderRadius.circular(borderRadius),
                  )
        ),
      ),
    );
  }
}
