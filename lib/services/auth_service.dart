import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../core/constants/api_constants.dart';
import '../core/network/dio_client.dart';
import '../data/models/auth_model.dart';

class AuthService extends GetxService {
  // Singleton — Get.put(AuthService()) registers it; Get.find<AuthService>() retrieves it.
  final DioClient _client = Get.find<DioClient>();

  // ── Register ──────────────────────────────────────────────────────────────

  Future<AuthResponse?> register(RegisterRequest req) async {
    try {
      final res = await _client.post<Map<String, dynamic>>(
        ApiConstants.register,
        data: req.toJson(), // raw JSON body — Dio serialises Map → application/json
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = _toMap(res.data);
        if (data != null) return AuthResponse.fromJson(data);
      }
    } on DioException catch (e) {
      _logDio('register', e);
    } catch (e) {
      _log('register', e);
    }
    return null;
  }

  // ── Login ─────────────────────────────────────────────────────────────────

  Future<AuthResponse?> login(LoginRequest req) async {
    try {
      final res = await _client.post<Map<String, dynamic>>(
        ApiConstants.login,
        data: req.toJson(),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = _toMap(res.data);
        if (data != null) return AuthResponse.fromJson(data);
      }
    } on DioException catch (e) {
      _logDio('login', e);
    } catch (e) {
      _log('login', e);
    }
    return null;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Handles both pre-decoded Map and raw JSON String responses.
  Map<String, dynamic>? _toMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is String) {
      try {
        return jsonDecode(raw) as Map<String, dynamic>;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  void _logDio(String method, DioException e) =>
      print('*** AuthService.$method DioException: ${e.response}');

  void _log(String method, Object e) =>
      print('*** AuthService.$method error: $e');
}
