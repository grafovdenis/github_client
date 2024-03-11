import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthTokenRepository {
  static const _key = 'github_token';

  final _token = ValueNotifier<String?>(null);

  ValueListenable<String?> get token => _token;

  final FlutterSecureStorage _storage;

  AuthTokenRepository({
    required FlutterSecureStorage storage,
  }) : _storage = storage;

  Future<String?> getToken() async {
    final token = await _storage.read(key: _key);
    _token.value = token;

    return token;
  }

  Future<void> setToken(String token) async {
    await _storage.write(key: _key, value: token);
    _token.value = token;
  }
}
