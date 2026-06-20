import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../core/constants/api_constants.dart';
import '../core/network/dio_client.dart';
import '../data/models/conversation_model.dart';

class ConversationService extends GetxService {
  final DioClient _client = Get.find<DioClient>();

  // ── GET /chat/conversations ───────────────────────────────────────────────

  Future<List<ConversationModel>> getConversations() async {
    try {
      final res = await _client.get<Map<String, dynamic>>(ApiConstants.conversations);
      debugPrint('💬 GET /chat/conversations — status: ${res.statusCode}, body: ${res.data}');
      if (_ok(res.statusCode)) {
        final data = _toMap(res.data);
        final list  = data?['conversations'] as List<dynamic>?;
        if (list != null) {
          return list
              .whereType<Map<String, dynamic>>()
              .map(ConversationModel.fromJson)
              .toList();
        }
      }
    } on DioException catch (e) {
      _logDio('getConversations', e);
    }
    return [];
  }

  // ── POST /chat/conversations ──────────────────────────────────────────────

  Future<ConversationModel?> createConversation() async {
    try {
      final res = await _client.post<Map<String, dynamic>>(ApiConstants.conversations);
      debugPrint('💬 POST /chat/conversations — status: ${res.statusCode}, body: ${res.data}');
      if (_ok(res.statusCode)) {
        final data = _toMap(res.data);
        if (data != null) return ConversationModel.fromJson(data);
      }
    } on DioException catch (e) {
      _logDio('createConversation', e);
    }
    return null;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  bool _ok(int? code) => code == 200 || code == 201;

  Map<String, dynamic>? _toMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is String) {
      try { return jsonDecode(raw) as Map<String, dynamic>; } catch (_) {}
    }
    return null;
  }

  Never _logDio(String method, DioException e) {
    final status = e.response?.statusCode;
    final body   = e.response?.data;
    debugPrint('*** ConversationService.$method [$status]: $body');
    String msg = 'Server error ($status)';
    if (body is Map) {
      final detail = body['detail'];
      if (detail is List && detail.isNotEmpty) {
        final first  = detail.first;
        final field  = (first['loc'] as List?)?.skip(1).join(' → ') ?? '';
        final reason = first['msg'] ?? '';
        msg = field.isNotEmpty ? '$field: $reason' : reason.toString();
      } else if (detail is String) {
        msg = detail;
      }
    }
    throw Exception(msg);
  }
}
