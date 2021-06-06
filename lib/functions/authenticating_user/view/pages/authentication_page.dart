import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import '../../domain/usecases/save_rememberd_user_usecase.dart';
import '../../domain/usecases/sign_in_user_usecase.dart';
import '../../domain/usecases/sign_out_user_usecase.dart';
import '../auth_bloc/auth_bloc_bloc.dart';
import '../../../authetication_checker/domain/usecases/load_rememberd_user_usecase.dart';
import '../../../authetication_checker/view/auth_form_bloc/auth_form_bloc.dart';
import '../widgets/input_auth_form/input_auth_form.dart';
import '../widgets/input_button.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData _media = MediaQuery.of(context);

    return BlocProvider(
      create: (_) => AuthFormBloc(
        GetIt.I<LoadRememberdUserUsecase>(),
      ),
      child: PlatformScaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: SizedBox(
              height: _media.size.height - _media.viewPadding.vertical,
              width: _media.size.width,
              child: Column(
                children: [
                  Flexible(
                      flex: 1,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/logo/img-login-logo.svg',
                        ),
                      )),
                  Flexible(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputAuthenticationForm(),
                        InputButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
