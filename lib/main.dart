import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:tw_shows/core/constants/colors.dart';
import 'package:tw_shows/core/navigation/route_generation.dart';
import 'package:tw_shows/functions/authenticating_user/view/pages/authentication_page.dart';
import 'package:tw_shows/functions/authetication_checker/view/auth_form_bloc/auth_form_bloc.dart';
import 'package:tw_shows/functions/comments/view/blocs/comment_post/comment_post_bloc.dart';
import 'package:tw_shows/functions/comments/view/blocs/comments_bloc/comments_bloc.dart';
import 'package:tw_shows/functions/dependency_injection.dart';
import 'package:tw_shows/functions/episodes/view/blocs/episodes_bloc/episodes_bloc.dart';
import 'package:tw_shows/functions/shows/view/blocs/shows_bloc/shows_bloc.dart';

import 'functions/authenticating_user/domain/usecases/save_rememberd_user_usecase.dart';
import 'functions/authenticating_user/domain/usecases/sign_in_user_usecase.dart';
import 'functions/authenticating_user/domain/usecases/sign_out_user_usecase.dart';
import 'functions/authenticating_user/view/auth_bloc/auth_bloc_bloc.dart';
import 'functions/authetication_checker/domain/usecases/load_rememberd_user_usecase.dart';
import 'functions/comments/domain/usecases/create_new_comment_usecase.dart';
import 'functions/comments/domain/usecases/load_episode_comments_usecase.dart';
import 'functions/episodes/domain/usecases/load_show_episodes_usecase.dart';
import 'functions/shows/domain/usecases/load_show_usecase_impl.dart';
import 'functions/shows/domain/usecases/load_shows_usecase_impl.dart';
import 'functions/shows/view/blocs/single_show_bloc/single_show_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyInjector.initiDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthFormBloc(GetIt.I<LoadRememberdUserUsecase>()),
        ),
        BlocProvider(
          create: (_) => AuthBloc(
            GetIt.I<SignInUserUsecase>(),
            GetIt.I<SignOutUserUsecase>(),
            GetIt.I<SaveRememberdUserUsecase>(),
          ),
        ),
        BlocProvider(
          create: (_) => ShowsBloc(
            GetIt.I<LoadShowsUsecase>(),
          ),
        ),
        BlocProvider(
          create: (_) => SingleShowBloc(
            GetIt.I<LoadShowUsecase>(),
          ),
        ),
        BlocProvider(
          create: (_) => EpisodesBloc(
            GetIt.I<LoadShowEpisodesUsecase>(),
          ),
        ),
        BlocProvider(
          create: (_) => CommentsBloc(
            GetIt.I<LoadEpisodeCommentsUsecase>(),
          ),
        ),
        BlocProvider(
          create: (_) => CommentPostBloc(
            GetIt.I<CreateNewCommentUsecase>(),
          ),
        ),
      ],
      child: PlatformApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        material: (ctx, target) => MaterialAppData(
          theme: ThemeData(
            primaryColor: Colors.white,
            accentColor: accentColor,
            textTheme: TextTheme(
              bodyText1: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
              headline1: TextStyle(
                fontSize: 35,
                color: Colors.black,
              ),
            ),
            checkboxTheme: CheckboxThemeData(
              checkColor: MaterialStateProperty.all(accentColor),
            ),
          ),
        ),
        cupertino: (ctx, target) => CupertinoAppData(
          theme: CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
              textStyle: TextStyle(
                fontSize: 17,
                color: Colors.black,
              ),
              navLargeTitleTextStyle: TextStyle(
                fontSize: 35,
                color: Colors.black,
              ),
            ),
            primaryColor: Colors.white,
            primaryContrastingColor: accentColor,
          ),
        ),
        home: AuthenticationPage(),
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }
}
