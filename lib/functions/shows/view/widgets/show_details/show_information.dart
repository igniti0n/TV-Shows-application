import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:tw_shows/functions/shows/domain/models/show.dart';

class ShowInformation extends StatelessWidget {
  const ShowInformation({
    Key? key,
    required this.deviceSize,
    required this.show,
  }) : super(key: key);

  final Size deviceSize;
  final Show show;

  @override
  Widget build(BuildContext context) {
    return
        // height: deviceSize.height * 0.25,
        // width: double.infinity,
        Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AutoSizeText(
          show.title,
          maxLines: 1,
          style: platformThemeData(
            context,
            material: (data) => data.textTheme.headline1!.copyWith(
              fontWeight: FontWeight.w300,
            ),
            cupertino: (data) => data.textTheme.navLargeTitleTextStyle
                .copyWith(fontWeight: FontWeight.w300),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: AutoSizeText(
            show.description,
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.bodyText1!.copyWith(
                height: 1.8,
                wordSpacing: 1.5,
                color: Color.fromRGBO(80, 80, 80, 1),
              ),
              cupertino: (data) => data.textTheme.textStyle.copyWith(
                height: 1.5,
                wordSpacing: 1.5,
                color: Color.fromRGBO(80, 80, 80, 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
