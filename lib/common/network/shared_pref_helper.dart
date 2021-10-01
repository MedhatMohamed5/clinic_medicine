import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static late SharedPreferences _sharedPreferences;

  SharedPrefHelper._();

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Object? getData({
    required String key,
  }) {
    return _sharedPreferences.get(key);
  }

  static Future<bool> removeData({required key}) async {
    return await _sharedPreferences.remove(key);
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await _sharedPreferences.setString(key, value);
    if (value is int) return await _sharedPreferences.setInt(key, value);
    if (value is bool) return await _sharedPreferences.setBool(key, value);

    return await _sharedPreferences.setDouble(key, value);
  }
}
