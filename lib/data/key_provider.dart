import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Holds secrets in the iOS Keychain / Android Keystore-backed storage.
class SecureStore {
  SecureStore([FlutterSecureStorage? storage])
    : _storage =
          storage ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
          );
  final FlutterSecureStorage _storage;

  static const _dbKey = 'db_passphrase';
  static const _tokenKey = 'fhir_token';

  /// Returns the database passphrase, creating a random 256-bit one on first use.
  Future<String> databasePassphrase() async {
    final existing = await _storage.read(key: _dbKey);
    if (existing != null) return existing;
    final rnd = Random.secure();
    final key = List.generate(
      32,
      (_) => rnd.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
    await _storage.write(key: _dbKey, value: key);
    return key;
  }

  Future<String?> readToken() => _storage.read(key: _tokenKey);
  Future<void> saveToken(String? token) => token == null || token.isEmpty
      ? _storage.delete(key: _tokenKey)
      : _storage.write(key: _tokenKey, value: token);
}
