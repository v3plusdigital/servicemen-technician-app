import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:servicemen_technician_app/custom_widgets/app_image_widget.dart';
import 'package:servicemen_technician_app/utils/app_colors.dart';
import 'package:servicemen_technician_app/utils/app_images.dart';
import 'package:servicemen_technician_app/utils/app_textstyles.dart';

class MultiSelectDropdownButton2<T> extends StatefulWidget {
  final List<T> items;
  final List<T> initialSelectedItems;
  final String hint;
  final String Function(T) itemLabel;
  final ValueChanged<List<T>> onChanged;
  final bool Function(T a, T b)? compareFn;

  const MultiSelectDropdownButton2({
    super.key,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.initialSelectedItems = const [],
    this.hint = 'Select',
    this.compareFn,
  });

  @override
  State<MultiSelectDropdownButton2<T>> createState() =>
      _MultiSelectDropdownButton2State<T>();
}

class _MultiSelectDropdownButton2State<T>
    extends State<MultiSelectDropdownButton2<T>> {
  late List<T> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = List<T>.from(widget.initialSelectedItems);
  }

  bool _contains(T item) {
    if (widget.compareFn != null) {
      return _selectedItems.any((e) => widget.compareFn!(e, item));
    }
    return _selectedItems.contains(item);
  }

  void _clearAll() {
    setState(() {
      _selectedItems.clear();
      widget.onChanged(_selectedItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,

        /// REQUIRED even for multi-select
        value: _selectedItems.isEmpty ? null : _selectedItems.last,
        onChanged: (_) {},

        hint: Text(
          widget.hint,
          style: AppTextStyles.sf14kGreyW400TextStyle,
        ),

        /// 🔥 DROPDOWN ITEMS
        items: widget.items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            enabled: false,
            child: StatefulBuilder(
              builder: (context, menuSetState) {
                final isSelected = _contains(item);

                return  customCheckboxTile(
                  title: widget.itemLabel(item),
                  value: isSelected,
                  showDivider: widget.items.last != item,
                  onChanged: (checked) {
                    if (checked) {
                      if (!isSelected) {
                        _selectedItems.add(item);
                      }
                    } else {
                      if (widget.compareFn != null) {
                        _selectedItems.removeWhere(
                              (e) => widget.compareFn!(e, item),
                        );
                      } else {
                        _selectedItems.remove(item);
                      }
                    }

                    widget.onChanged(_selectedItems);

                    /// 🔥 REQUIRED for dropdown_button2
                    menuSetState(() {}); // rebuild this row
                    setState(() {}); // rebuild field (count chip)
                  },
                );

              },
            ),
          );
        }).toList(),

        /// FIELD UI
        buttonStyleData: ButtonStyleData(
          height: 58,
          padding: const EdgeInsets.only(left: 0, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.kGrey1),
          ),
        ),

        /// COUNT CHIP IN FIELD
        selectedItemBuilder: (context) {
          return widget.items.map((_) {
            return Row(
              children: [
                _selectedItems.isEmpty
                    ? Text(
                        widget.hint,
                        style: const TextStyle(color: Colors.grey),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.kBlack,
                          borderRadius: BorderRadius.circular(
                              20), // 🔥 control radius here
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${_selectedItems.length}',
                                style: AppTextStyles.sf14kWhiteW400TextStyle),
                            const SizedBox(width: 10),
                            GestureDetector(
                                onTap: _clearAll,
                                child: AppImageWidget().svgImage(
                                    imageName: AppImages.closeIcon,
                                    color: AppColors.kWhite,
                                    height: 16,
                                    width: 16)),
                          ],
                        ),
                      )
              ],
            );
          }).toList();
        },

        /// DROPDOWN STYLE
        dropdownStyleData: DropdownStyleData(
          maxHeight: MediaQuery.of(context).size.height * 0.45,
          decoration: BoxDecoration(
            color: AppColors.kWhite,
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down),
        ),
      ),
    );
  }

  Widget customCheckboxTile(
      {required String title,
      required bool value,
      required ValueChanged<bool> onChanged,
      required bool showDivider}) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: Row(
              children: [
                /// CHECKBOX
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: value ? AppColors.kPrimaryColor: Colors.transparent,
                    border: Border.all(
                      color: value
                          ? AppColors.kPrimaryColor
                          : AppColors.kGrey7,
                      width: 2,
                    ),
                  ),
                  child: value
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),

                const SizedBox(width: 14),

                /// TEXT
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.sf16kBlackW400TextStyle
                  ),
                ),
              ],
            ),
          ),

          /// DIVIDER (inside same widget)
          if (showDivider)
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey.shade200,
            ),
        ],
      ),
    );
  }
}

