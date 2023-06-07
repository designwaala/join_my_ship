import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._();
  static final SecureStorage instance = SecureStorage._();

  final _storage = Platform.isAndroid
      ? const FlutterSecureStorage(
          aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ))
      : const FlutterSecureStorage();

  String passwordKey = "PASSWORD";

  Future<String> get password async =>
      await _storage.read(key: passwordKey) ?? "";

  set password(value) => _storage.write(key: passwordKey, value: value);
}
