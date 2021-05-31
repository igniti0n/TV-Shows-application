import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tw_shows/core/constants/colors.dart';
import 'package:tw_shows/functions/comments/domain/models/comment.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({
    Key? key,
    required this.comment,
    required this.height,
  }) : super(key: key);

  final Comment comment;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: SvgPicture.asset('assets/ic-user.svg'),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      'User',
                      textAlign: TextAlign.left,
                      style: platformThemeData(
                        context,
                        material: (data) => data.textTheme.bodyText1!.copyWith(
                          color: accentColor,
                        ),
                        cupertino: (data) => data.textTheme.textStyle.copyWith(
                          color: accentColor,
                        ),
                      ),
                    ),
                    AutoSizeText(
                      '4min',
                      maxFontSize: 15,
                      textAlign: TextAlign.left,
                      style: platformThemeData(
                        context,
                        material: (data) => data.textTheme.bodyText1!.copyWith(
                          color: Color.fromRGBO(160, 160, 160, 1),
                        ),
                        cupertino: (data) => data.textTheme.textStyle.copyWith(
                          color: accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
                AutoSizeText(
                  comment.text,
                  textAlign: TextAlign.left,
                  style: platformThemeData(
                    context,
                    material: (data) => data.textTheme.bodyText1!,
                    cupertino: (data) => data.textTheme.textStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
