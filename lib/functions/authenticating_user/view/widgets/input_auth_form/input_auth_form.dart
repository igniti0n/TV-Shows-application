import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tw_shows/functions/authenticating_user/view/widgets/input_auth_form/email_field.dart';
import 'package:tw_shows/functions/authenticating_user/view/widgets/input_auth_form/password_field.dart';
import 'package:tw_shows/functions/authenticating_user/view/widgets/input_auth_form/remember_me_check.dart';
import 'package:tw_shows/functions/authetication_checker/view/auth_form_bloc/auth_form_bloc.dart';

class InputAuthenticationForm extends StatefulWidget {
  const InputAuthenticationForm({
    Key? key,
  }) : super(key: key);

  @override
  _InputAuthenticationFormState createState() =>
      _InputAuthenticationFormState();
}

class _InputAuthenticationFormState extends State<InputAuthenticationForm> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    BlocProvider.of<AuthFormBloc>(context).add(InitialLoad());
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthFormBloc _authFormBloc =
        BlocProvider.of<AuthFormBloc>(context, listen: false);

    return BlocBuilder<AuthFormBloc, AuthFormState>(
      builder: (context, formState) {
        if (formState is AuthFormInitial) {
          if (formState.authCredentials.emailCredential.email.length > 1) {
            _emailController.text =
                formState.authCredentials.emailCredential.email;
            _passwordController.text =
                formState.authCredentials.passwordCredential.password;
          }
        }

        return Column(
          children: [
            EmailField(
              controller: _emailController,
              authFormBloc: _authFormBloc,
              authFormState: formState,
            ),
            PasswordField(
              controller: _passwordController,
              authFormBloc: _authFormBloc,
              authFormState: formState,
            ),
            RememberMeCheck(
              authFormBloc: _authFormBloc,
              isChecked: formState.authCredentials.isRemember,
            ),
          ],
        );
      },
    );
  }
}
