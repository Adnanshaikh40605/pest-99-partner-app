import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../core/api_client.dart';
import '../core/api_exception.dart';

class AuthService {
  AuthService(this._api);

  final ApiClient _api;
  static const _approvedKey = 'partner_app_approved';

  static String normalizeMobile(String mobile) {
    final digits = mobile.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 10) return digits.substring(digits.length - 10);
    return digits;
  }

  Future<Map<String, dynamic>> login(String mobile, String password) async {
    final data = await _api.post(
      ApiConfig.login,
      body: {
        'mobile': normalizeMobile(mobile),
        'password': password,
      },
      auth: false,
    );
    final token = data['access'] as String?;
    if (token == null || token.isEmpty) {
      throw ApiException('Login failed — no token received.');
    }
    await _api.saveToken(token);
    final approved = data['is_app_approved'] == true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_approvedKey, approved);
    return data;
  }

  Future<void> register({
    required String fullName,
    required String mobile,
    required String password,
    String role = 'technician',
  }) async {
    await _api.post(
      ApiConfig.register,
      body: {
        'full_name': fullName,
        'mobile': normalizeMobile(mobile),
        'password': password,
        'role': role,
      },
      auth: false,
    );
  }

  Future<bool> isAppApproved() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_approvedKey) ?? false;
  }

  Future<void> setAppApproved(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_approvedKey, value);
  }

  Future<void> logout() async {
    await _api.clearToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_approvedKey);
  }

  Future<bool> hasSession() async {
    final t = await _api.getToken();
    return t != null && t.isNotEmpty;
  }
}
