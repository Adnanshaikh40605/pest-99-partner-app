import 'package:flutter/foundation.dart';

import '../core/api_exception.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._auth);

  final AuthService _auth;
  bool _loading = false;
  String? _error;
  bool _loggedIn = false;
  bool _appApproved = false;
  bool _ready = false;
  String? _partnerName;

  bool get loading => _loading;
  String? get error => _error;
  bool get loggedIn => _loggedIn;
  bool get appApproved => _appApproved;
  bool get ready => _ready;
  String? get partnerName => _partnerName;

  Future<void> init() async {
    _loggedIn = await _auth.hasSession();
    _appApproved = _loggedIn ? await _auth.isAppApproved() : false;
    _ready = true;
    notifyListeners();
  }

  Future<bool> login(String mobile, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final data = await _auth.login(mobile, password);
      _loggedIn = true;
      _appApproved = data['is_app_approved'] == true;
      final partner = data['partner'];
      if (partner is Map) {
        _partnerName = partner['full_name'] as String?;
      }
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

  Future<bool> register({
    required String fullName,
    required String mobile,
    required String password,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _auth.register(fullName: fullName, mobile: mobile, password: password);
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (_) {
      _error = 'Registration failed. Check your connection.';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refreshApprovalFromProfile(Map<String, dynamic> data) async {
    _appApproved = data['is_app_approved'] == true;
    await _auth.setAppApproved(_appApproved);
    final partner = data['partner'];
    if (partner is Map) {
      _partnerName = partner['full_name'] as String?;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.logout();
    _loggedIn = false;
    _appApproved = false;
    _partnerName = null;
    notifyListeners();
  }
}
