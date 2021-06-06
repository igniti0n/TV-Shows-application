import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../authetication_checker/view/auth_form_bloc/auth_form_bloc.dart';

class EmailField extends StatelessWidget {
  final AuthFormState authFormState;
  final AuthFormBloc authFormBloc;
  final TextEditingController controller;
  const EmailField({
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
        onChanged: (String email) => authFormBloc.add(EmailChanged(email)),
        style: platformThemeData(
          context,
          material: (data) => data.textTheme.bodyText1,
          cupertino: (data) => data.textTheme.textStyle,
        ),
        decoration: InputDecoration(
          errorText: authFormState.authCredentials.emailCredential.errorMessage,
          labelText: 'Email',
          labelStyle: TextStyle(fontSize: 19, color: fadedTextColor),
          hintStyle: TextStyle(fontSize: 10, color: fadedTextColor),
        ),
        maxLines: 1,
        obscureText: false,
      ),
    );
  }
}
