import '../config/api_config.dart';
import '../core/api_client.dart';
import '../core/api_exception.dart';

class AuthService {
  AuthService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> login(String mobile, String password) async {
    final data = await _api.post(
      ApiConfig.login,
      body: {'mobile': mobile, 'password': password},
      auth: false,
    );
    final token = data['access'] as String?;
    if (token == null || token.isEmpty) {
      throw ApiException('Login failed — no token received.');
    }
    await _api.saveToken(token);
    return data;
  }

  Future<void> logout() => _api.clearToken();

  Future<bool> hasSession() async {
    final t = await _api.getToken();
    return t != null && t.isNotEmpty;
  }
}
