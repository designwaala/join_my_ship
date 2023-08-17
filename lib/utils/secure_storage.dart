/* import 'dart:io';


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
 */