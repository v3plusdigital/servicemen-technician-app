// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  String content;
  TextAlign? textAlign;
  TextStyle? textStyle;
  int? maxLine;
  TextOverflow? overflow;

  CustomTextWidget(
      {super.key,
      required this.content,
      this.textAlign,
      this.textStyle,
      this.maxLine,
      this.overflow,});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      textAlign: textAlign,
      softWrap: true,
      maxLines: maxLine,
      overflow: overflow,
      style: textStyle,
    );
  }
}
