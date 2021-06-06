import 'dart:developer';

import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/pages.dart';
import '../auth_bloc/auth_bloc_bloc.dart';
import '../../../authetication_checker/domain/models/auth_credentials.dart';
import '../../../authetication_checker/view/auth_form_bloc/auth_form_bloc.dart';
import '../../../shows/view/blocs/shows_bloc/shows_bloc.dart';

class InputButton extends StatelessWidget {
  const InputButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = BlocProvider.of<AuthBloc>(context);
    final ShowsBloc _showsBloc = BlocProvider.of<ShowsBloc>(context);

    return BlocConsumer<AuthBloc, AuthBlocState>(listener: (ctx, authState) {
      if (authState is AuthFailed) {
        showPlatformDialog(
          context: context,
          builder: (_) => PlatformAlertDialog(
            //title: Text('Alert'),
            content: Text(authState.message),
            actions: <Widget>[
              PlatformDialogAction(
                child: Text('Okay'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      } else if (authState is AuthSuccesfull) {
        _showsBloc.add(FetchShows());
        Navigator.of(context).pushReplacementNamed(ROUTE_SHOWS_PAGE);
      }
    }, builder: (context, authState) {
      if (authState is AuthLoading) {
        return Center(
          child: PlatformCircularProgressIndicator(),
        );
      }

      return BlocBuilder<AuthFormBloc, AuthFormState>(
        builder: (context, formState) {
          final bool _isValid = formState.authCredentials.isValid();

          return GestureDetector(
            onTap: !_isValid
                ? null
                : () => _tryToAuthenticateUser(
                    _authBloc, formState.authCredentials),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                color: _isValid ? accentColor : buttonColorOff,
              ),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              width: double.infinity,
              child: AutoSizeText(
                'LOG IN',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          );
        },
      );
    });
  }

  void _tryToAuthenticateUser(AuthBloc authBloc, AuthCredentials credentials) {
    final AuthCredentials _credentials = credentials;
    authBloc.add(LogIn(
      _credentials.emailCredential.email,
      _credentials.passwordCredential.password,
      _credentials.isRemember,
    ));
  }
}
