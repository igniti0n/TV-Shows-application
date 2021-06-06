import '../../../../core/error/exceptions/exceptions.dart';
import '../../../../core/network/connection_checker.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../datasources/network_user_data_source.dart';
import '../entities/user_model.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final NetworkUserDataSource _networkUserDataSource;
  final SecureStorageManager _secureStorageManager;
  final ConnectionChecker _connectionChecker;
  UserRepositoryImpl(this._networkUserDataSource, this._secureStorageManager,
      this._connectionChecker);

  @override
  Future<void> authenticateUserWithEmailAndPassword(User user) async {
    if (!await _connectionChecker.hasConnection) throw NoConnectionException();
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
