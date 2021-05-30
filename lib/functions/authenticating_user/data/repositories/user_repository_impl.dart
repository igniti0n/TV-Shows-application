import 'package:tw_shows/core/storage/secure_storage_manager.dart';
import 'package:tw_shows/functions/authenticating_user/data/datasources/network_user_data_source.dart';
import 'package:tw_shows/functions/authenticating_user/data/entities/user_model.dart';
import 'package:tw_shows/functions/authenticating_user/domain/models/user.dart';
import 'package:tw_shows/functions/authenticating_user/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final NetworkUserDataSource _networkUserDataSource;
  final SecureStorageManager _secureStorageManager;
  UserRepositoryImpl(this._networkUserDataSource, this._secureStorageManager);

  @override
  Future<void> authenticateUserWithEmailAndPassword(User user) async {
    await _networkUserDataSource.signIn(UserModel.fromUser(user));
  }

  @override
  Future<User> loadRememberdUser() async {
    final _userData = await _secureStorageManager.loadRememberdUser();
    return UserModel.fromJson(_userData);
  }

  @override
  Future<void> saveRememberdUser(User user) async {
    await _secureStorageManager.saveRememberdUser(UserModel.fromUser(user));
  }

  @override
  Future<void> signOut() async {
    _networkUserDataSource.signOut();
  }
}