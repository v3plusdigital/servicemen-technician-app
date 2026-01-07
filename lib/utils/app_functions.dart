import 'package:flutter/services.dart';

String? validatePhone(String? value) {
  if (value == null || value.isEmpty) return "Enter phone number";

  // remove hyphen
  value = value.replaceAll('-', '');

  if (value.length != 10) return "Must be 10 digits";

  // if (!RegExp(r'^[6-9]').hasMatch(value)) return "Invalid mobile number";

  return null;
}



String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return "Enter email";
  }

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  if (!emailRegex.hasMatch(value)) {
    return "Enter valid email";
  }

  return null;
}
bool isEmpty(String? value) => value == null || value.trim().isEmpty;

String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}
