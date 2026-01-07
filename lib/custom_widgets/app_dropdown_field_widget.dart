import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_textstyles.dart';

class AppDropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// LABEL
        Text(
          label,
          style: AppTextStyles.sf14kBlackW400TextStyle,
        ),
        const SizedBox(height: 6),

        /// DROPDOWN
        DropdownButtonHideUnderline(
          child: DropdownButton2<T>(
            value: value,
            items: items,
            onChanged: onChanged,
            isExpanded: true,

            hint: Text(
              hint,
              style: AppTextStyles.sf14kGreyW400TextStyle,
            ),

            /// FIELD STYLE (matches TextField)
            buttonStyleData: ButtonStyleData(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.kGrey1,
                  width: 1,
                ),
              ),
            ),

            /// TEXT STYLE
            style: AppTextStyles.sf14kBlackW400TextStyle,

            /// ICON
            iconStyleData: const IconStyleData(
              icon: Icon(Icons.keyboard_arrow_down),
            ),

            /// 🔥 DROPDOWN MENU STYLE (THIS FIXES YOUR ISSUE)
            dropdownStyleData: DropdownStyleData(
              offset: const Offset(0, 8),
              maxHeight: MediaQuery.of(context).size.height * 0.4,

              /// 👇 horizontal spacing from screen
              width: MediaQuery.of(context).size.width - 32,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.kWhite
              ),
            ),

            /// MENU ITEM STYLE
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }
}


/*
import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_textstyles.dart';

class AppDropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:  AppTextStyles.sf14kBlackW400TextStyle,
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down),
          style: AppTextStyles.sf14kBlackW400TextStyle,

          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.sf14kGreyW400TextStyle,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.kGrey1, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
              enabledBorder:OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.kGrey1, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.kGrey1, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.kGrey1, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.kGrey1, width: 1),
                borderRadius: BorderRadius.circular(8),
              )
          ),
        ),
      ],
    );
  }
}*/
