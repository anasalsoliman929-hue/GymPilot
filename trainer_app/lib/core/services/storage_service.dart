import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../constants/storage_keys.dart';

class StorageService {
  final _box = GetStorage();

  // ─── Token ────────────────────────────────────────────────
  String? get token => _box.read<String>(StorageKeys.token);

  Future<void> saveToken(String token) => _box.write(StorageKeys.token, token);
  Future<void> clearToken()            => _box.remove(StorageKeys.token);

  // ─── User ─────────────────────────────────────────────────
  Map<String, dynamic>? get user {
    final raw = _box.read<String>(StorageKeys.user);
    if (raw == null) return null;
    try { return jsonDecode(raw) as Map<String, dynamic>; } catch (_) { return null; }
  }

  Future<void> saveUser(Map<String, dynamic> user) =>
      _box.write(StorageKeys.user, jsonEncode(user));

  Future<void> clearUser() => _box.remove(StorageKeys.user);

  // ─── Session ──────────────────────────────────────────────
  bool get isLoggedIn => token != null && token!.isNotEmpty;

  Future<void> clearSession() async {
    await clearToken();
    await clearUser();
  }
}
