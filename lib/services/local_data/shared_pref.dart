import 'dart:ffi';

import 'package:servicemen_technician_app/services/local_data/shared_pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  Future<void> setStringValue(String key, String value) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(key, value);
  }

  Future<String?> getStringValue(String key) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

  Future<void> setBoolValue(String key, bool value) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(key, value);
  }

  Future<bool?> getBoolValue(String key) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(key);
  }

  Future<void> clear() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}
