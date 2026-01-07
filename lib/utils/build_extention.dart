import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

extension LocalizationExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

extension MediaQueryExt on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;

  double get topPadding => MediaQuery.of(this).padding.top;
  double get bottomPadding => MediaQuery.of(this).padding.bottom;

  double wp(double percent) => width * percent;   // width percentage
  double hp(double percent) => height * percent;  // height percentage
}