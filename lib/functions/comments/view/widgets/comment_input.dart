import 'dart:developer';

import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../../../core/constants/colors.dart';
import '../../domain/models/comment.dart';
import '../blocs/comment_post/comment_post_bloc.dart';
import '../blocs/comments_bloc/comments_bloc.dart';

class CommentInput extends StatefulWidget {
  final Size deviceSize;
  final String episodeId;
  const CommentInput({
    Key? key,
    required this.deviceSize,
    required this.episodeId,
  }) : super(key: key);

  @override
  _CommentInputState createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  String _comment = '';

  @override
  Widget build(BuildContext context) {
    final CommentsBloc _commentsBloc = BlocProvider.of<CommentsBloc>(context);

    final CommentPostBloc _commentPostBloc =
        BlocProvider.of<CommentPostBloc>(context);

    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        color: Color.fromRGBO(237, 237, 237, 1),
      )),
      height: widget.deviceSize.height * 0.12,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              height: widget.deviceSize.height * 0.05,
              width: widget.deviceSize.height * 0.05,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Color.fromRGBO(237, 237, 237, 1),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: TextField(
                          controller: _textEditingController,
                          onChanged: (String text) => _comment = text,
                          maxLines: null,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: 'Add a comment...',
                          ),
                        ),
                      ),
                    ),
                    BlocListener<CommentPostBloc, CommentPostState>(
                      listener: (context, state) {
                        if (state is CommentPostSuccess) {
                          _commentsBloc.add(FetchComments(widget.episodeId));
                        } else if (state is CommentPostFail) {
                          log('failed');
                        }
                      },
                      child: PlatformTextButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _textEditingController.clear();
                          _commentPostBloc.add(
                            PostComment(
                              Comment(
                                _comment,
                                widget.episodeId,
                              ),
                            ),
                          );
                        },
                        child: AutoSizeText(
                          'Post',
                          style: platformThemeData(
                            context,
                            material: (data) =>
                                data.textTheme.bodyText1!.copyWith(
                              color: accentColor,
                            ),
                            cupertino: (data) =>
                                data.textTheme.textStyle.copyWith(
                              color: accentColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
