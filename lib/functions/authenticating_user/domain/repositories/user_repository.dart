import '../models/user.dart';

abstract class UserRepository {
  Future<void> authenticateUserWithEmailAndPassword(User user);

  Future<void> signOut();

  Future<void> saveRememberdUser(User user);
  Future<User> loadRememberdUser();
}
