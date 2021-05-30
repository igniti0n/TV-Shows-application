import 'package:tw_shows/functions/authenticating_user/domain/models/user.dart';

class UserModel extends User {
  UserModel(String email, String password) : super(email, password);

  factory UserModel.fromUser(User user) {
    return UserModel(user.email, user.password);
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(map['email'], map['password']);
  }

  Map<String, dynamic> toJson() {
    return {
      'email': this.email,
      'password': this.password,
    };
  }
}
