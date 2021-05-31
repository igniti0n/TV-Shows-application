import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tw_shows/functions/authenticating_user/view/widgets/input_auth_form/input_auth_form.dart';
import 'package:tw_shows/functions/authenticating_user/view/widgets/input_button.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData _media = MediaQuery.of(context);

    return PlatformScaffold(
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
          )),
    );
  }
}
