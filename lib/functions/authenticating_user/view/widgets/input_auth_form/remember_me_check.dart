import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tw_shows/functions/authetication_checker/view/auth_form_bloc/auth_form_bloc.dart';

class RememberMeCheck extends StatelessWidget {
  final bool isChecked;
  final AuthFormBloc authFormBloc;

  const RememberMeCheck({
    Key? key,
    required this.isChecked,
    required this.authFormBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => authFormBloc.add(RememberUserChanged(!isChecked)),
            child: isChecked
                ? SvgPicture.asset(
                    'assets/checkbox/ic-checkbox-filled.svg',
                  )
                : SvgPicture.asset(
                    'assets/checkbox/ic-checkbox-empty.svg',
                  ),
          ),
          SizedBox(
            width: 20,
          ),
          AutoSizeText(
            'Remember me',
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.bodyText1,
              cupertino: (data) => data.textTheme.textStyle,
            ),
          ),
        ],
      ),
    );
  }
}
