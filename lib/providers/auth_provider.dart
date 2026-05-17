import 'package:flutter/foundation.dart';

import '../core/api_exception.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._auth);

  final AuthService _auth;
  bool _loading = false;
  String? _error;
  bool _loggedIn = false;
  bool _ready = false;

  bool get loading => _loading;
  String? get error => _error;
  bool get loggedIn => _loggedIn;
  bool get ready => _ready;

  Future<void> init() async {
    _loggedIn = await _auth.hasSession();
    _ready = true;
    notifyListeners();
  }

  Future<bool> login(String mobile, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _auth.login(mobile, password);
      _loggedIn = true;
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (_) {
      _error = 'Network error. Check your connection.';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.logout();
    _loggedIn = false;
    notifyListeners();
  }
}
