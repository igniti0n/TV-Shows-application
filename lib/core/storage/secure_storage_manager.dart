import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../functions/authenticating_user/data/entities/user_model.dart';

abstract class SecureStorageManager {
  Future<Map<String, dynamic>> loadRememberdUser();
  Future<void> saveRememberdUser(UserModel userModel);
}

const String USER_STORAGE_KEY = 'rememberd_user';

class SecureStorageManagerImpl extends SecureStorageManager {
  final FlutterSecureStorage _flutterSecureStorage;

  SecureStorageManagerImpl(this._flutterSecureStorage);
  @override
  Future<Map<String, dynamic>> loadRememberdUser() async {
    final String? _savedUser =
        await _flutterSecureStorage.read(key: USER_STORAGE_KEY);
    if (_savedUser != null) {
      return jsonDecode(_savedUser);
    } else {
      return {
        'email': '',
        'password': '',
      };
    }
  }

  @override
  Future<void> saveRememberdUser(UserModel userModel) async {
    final String _userData = jsonEncode(userModel.toJson());
    await _flutterSecureStorage.write(key: USER_STORAGE_KEY, value: _userData);
  }
}
