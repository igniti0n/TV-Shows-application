import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import '../../domain/usecases/create_new_comment_usecase.dart';
import '../blocs/comment_post/comment_post_bloc.dart';
import '../../../../core/constants/strings.dart';
import '../blocs/comments_bloc/comments_bloc.dart';
import '../widgets/comment_input.dart';
import '../widgets/comment_tile.dart';

class CommentsPage extends StatelessWidget {
  final String episodeId;
  const CommentsPage({Key? key, required this.episodeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _deviceSize = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => CommentPostBloc(
        GetIt.I<CreateNewCommentUsecase>(),
      ),
      child: PlatformScaffold(
        appBar: PlatformAppBar(
          title: PlatformText('Comments'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: SizedBox(
            height: _deviceSize.height,
            width: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: BlocBuilder<CommentsBloc, CommentsState>(
                    builder: (context, commentsState) {
                      if (commentsState is CommentsLoaded) {
                        if (commentsState.comments.isEmpty) {
                          return _buildNoComments(context);
                        }
                        return _buildCommentsList(commentsState, _deviceSize);
                      } else if (commentsState is CommentsError) {
                        return Center(
                          child: PlatformText(commentsState.message),
                        );
                      }
                      return Center(
                        child: PlatformCircularProgressIndicator(),
                      );
                    },
                  ),
                ),
                CommentInput(
                  deviceSize: _deviceSize,
                  episodeId: episodeId,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildCommentsList(CommentsLoaded commentsState, Size _deviceSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey,
        ),
        itemCount: commentsState.comments.length,
        itemBuilder: (ctx, index) => CommentTile(
          comment: commentsState.comments[index],
          height: _deviceSize.height * 0.1,
        ),
      ),
    );
  }

  Center _buildNoComments(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/ic-no-comments.svg'),
          AutoSizeText(
            TEXT_NO_COMMENTS,
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.bodyText1!,
              cupertino: (data) => data.textTheme.textStyle,
            ),
          ),
        ],
      ),
    );
  }
}
