import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../core/constants/api_constants.dart';
import '../core/network/dio_client.dart';
import '../data/models/student_model.dart';

class StudentService extends GetxService {
  final DioClient _client = Get.find<DioClient>();

  // ── Get student profile ───────────────────────────────────────────────────
  // GET /students/me

  Future<StudentProfile?> getProfile() async {
    try {
      final res = await _client.get<Map<String, dynamic>>(
        ApiConstants.studentMe,
      );
      if (_ok(res.statusCode)) {
        final data = _toMap(res.data);
        if (data != null) return StudentProfile.fromJson(data);
      }
    } on DioException catch (e) {
      _logDio('getProfile', e);
    }
    return null;
  }

  // ── Get student preferences ───────────────────────────────────────────────
  // GET /students/preferences

  Future<StudentPreferences?> getPreferences() async {
    try {
      final res = await _client.get<Map<String, dynamic>>(
        ApiConstants.studentPreferences,
      );
      if (_ok(res.statusCode)) {
        final data = _toMap(res.data);
        if (data != null) return StudentPreferences.fromJson(data);
      }
    } on DioException catch (e) {
      _logDio('getPreferences', e);
    }
    return null;
  }

  // ── Update student profile ────────────────────────────────────────────────
  // PATCH /students/me

  Future<StudentProfile?> updateProfile(UpdateStudentRequest req) async {
    try {
      final res = await _client.patch<Map<String, dynamic>>(
        ApiConstants.studentMe,
        data: req.toJson(),
      );
      if (_ok(res.statusCode)) {
        final data = _toMap(res.data);
        if (data != null) return StudentProfile.fromJson(data);
      }
    } on DioException catch (e) {
      _logDio('updateProfile', e);
      rethrow;
    }
    return null;
  }

  // ── Update student preferences ────────────────────────────────────────────
  // PATCH /students/preferences

  Future<StudentPreferences?> updatePreferences(
      UpdatePreferencesRequest req) async {
    try {
      final res = await _client.patch<Map<String, dynamic>>(
        ApiConstants.studentPreferences,
        data: req.toJson(),
      );
      if (_ok(res.statusCode)) {
        final data = _toMap(res.data);
        if (data != null) return StudentPreferences.fromJson(data);
      }
    } on DioException catch (e) {
      _logDio('updatePreferences', e);
      rethrow;
    }
    return null;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  bool _ok(int? code) => code == 200 || code == 201;

  Map<String, dynamic>? _toMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is String) {
      try {
        return jsonDecode(raw) as Map<String, dynamic>;
      } catch (_) {}
    }
    return null;
  }

  Never _logDio(String method, DioException e) {
    final status = e.response?.statusCode;
    final body = e.response?.data;
    print('*** StudentService.$method [$status]: $body');

    String msg = 'Server error ($status)';
    if (body is Map) {
      final detail = body['detail'];
      if (detail is List && detail.isNotEmpty) {
        final first = detail.first;
        final field = (first['loc'] as List?)?.skip(1).join(' → ') ?? '';
        final reason = first['msg'] ?? '';
        msg = field.isNotEmpty ? '$field: $reason' : reason.toString();
      } else if (detail is String) {
        msg = detail;
      }
    }
    throw Exception(msg);
  }
}
