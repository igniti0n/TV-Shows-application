import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../authetication_checker/view/auth_form_bloc/auth_form_bloc.dart';

class PasswordField extends StatelessWidget {
  final AuthFormState authFormState;
  final AuthFormBloc authFormBloc;
  final TextEditingController controller;
  const PasswordField({
    Key? key,
    required this.authFormState,
    required this.authFormBloc,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        onChanged: (String password) =>
            authFormBloc.add(PasswordChanged(password)),
        style: platformThemeData(
          context,
          material: (data) =>
              data.textTheme.bodyText1!.copyWith(letterSpacing: 5),
          cupertino: (data) => data.textTheme.textStyle,
        ),
        decoration: InputDecoration(
          errorText:
              authFormState.authCredentials.passwordCredential.errorMessage,
          suffixIcon: GestureDetector(
            onTap: () => authFormBloc.add(ObscurePasswordChanged(
                !authFormState.authCredentials.isObscured)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: authFormState.authCredentials.isObscured
                  ? SvgPicture.asset(
                      'assets/password/pass_hidden.svg',
                    )
                  : SvgPicture.asset(
                      'assets/password/pass_visible.svg',
                    ),
            ),
          ),
          labelText: 'Password',
          labelStyle:
              TextStyle(fontSize: 19, color: fadedTextColor, letterSpacing: 1),
          hintStyle: TextStyle(fontSize: 2, color: fadedTextColor),
        ),
        maxLines: 1,
        obscureText: authFormState.authCredentials.isObscured,
      ),
    );
  }
}
