import 'package:flutter/services.dart';

class PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    var text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.length > 10) {
      text = text.substring(0, 10);
    }

    if (text.length > 5) {
      text = text.substring(0, 5) + '-' + text.substring(5);
    }

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}