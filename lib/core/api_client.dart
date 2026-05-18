import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _tokenKey = 'partner_access_token';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Future<Map<String, dynamic>> get(String path, {bool auth = true}) async {
    final headers = await _headers(auth);
    final res = await _client.get(_uri(path), headers: headers);
    return _decode(res);
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final headers = await _headers(auth);
    final res = await _client.put(
      _uri(path),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _decode(res);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final headers = await _headers(auth);
    final res = await _client.post(
      _uri(path),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _decode(res);
  }

  Future<Map<String, dynamic>> postMultipart(
    String path, {
    required List<http.MultipartFile> files,
    Map<String, String>? fields,
    bool auth = true,
  }) async {
    final headers = await _headers(auth, json: false);
    final request = http.MultipartRequest('POST', _uri(path));
    request.headers.addAll(headers);
    if (fields != null) request.fields.addAll(fields);
    request.files.addAll(files);
    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    return _decode(res);
  }

  Future<Map<String, String>> _headers(bool auth, {bool json = true}) async {
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    if (json) headers['Content-Type'] = 'application/json';
    if (auth) {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Session expired. Please log in again.', statusCode: 401);
      }
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Map<String, dynamic> _decode(http.Response res) {
    Map<String, dynamic>? body;
    if (res.body.isNotEmpty) {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) body = decoded;
    }
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return body ?? {};
    }
    throw ApiException.fromResponse(res.statusCode, body);
  }

  void dispose() => _client.close();
}
