import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';

class AuthCredentials extends Equatable {
  final EmailCredential emailCredential;
  final PasswordCredential passwordCredential;

  AuthCredentials({
    required this.emailCredential,
    required this.passwordCredential,
  });

  bool isValid(bool isLogin) {
    bool _areAllInputsValid = (this.emailCredential.errorMessage == null &&
        this.passwordCredential.errorMessage == null);

    _areAllInputsValid = (this.emailCredential.email.isNotEmpty &&
        this.passwordCredential.password.isNotEmpty);

    return _areAllInputsValid;
  }

  AuthCredentials copyWith({
    EmailCredential? emailCredential,
    PasswordCredential? passwordCredential,
  }) {
    return AuthCredentials(
      emailCredential: emailCredential ?? this.emailCredential,
      passwordCredential: passwordCredential ?? this.passwordCredential,
    );
  }

  @override
  List<Object?> get props => [
        this.emailCredential,
        this.passwordCredential,
      ];
}

class EmailCredential extends Equatable {
  late final String? errorMessage;
  final String email;
  EmailCredential(
    String email,
  ) : this.email = email {
    errorMessage =
        EmailValidator.validate(email) ? null : 'email is not valid.';
  }

  EmailCredential.initial() : this.email = '' {
    errorMessage = null;
  }

  @override
  List<Object?> get props => [email, errorMessage];
}

class PasswordCredential extends Equatable {
  late final String? errorMessage;
  final String password;

  PasswordCredential(
    String password,
  ) : this.password = password {
    errorMessage = (password.length >= 8) ? null : 'Password si too short.';
  }

  PasswordCredential.initial() : this.password = '' {
    errorMessage = null;
  }

  @override
  List<Object?> get props => [password, errorMessage];
}
