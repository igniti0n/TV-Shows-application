import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get_it/get_it.dart';
import '../../domain/usecases/create_episode_usecase.dart';
import '../../../../core/constants/colors.dart';
import '../blocs/episode_creation_bloc.dart/episode_creation_bloc.dart';
import '../blocs/episode_form_bloc/episode_form_bloc.dart';
import '../blocs/episode_image/episode_image_bloc.dart';
import '../blocs/episodes_bloc/episodes_bloc.dart';
import '../widgets/add_episode/add_episode_form.dart';

class AddEpisodePage extends StatelessWidget {
  const AddEpisodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EpisodeFormBloc _episodeFormBloc =
        BlocProvider.of<EpisodeFormBloc>(context);
    final EpisodeImageBloc _episodeImageBloc =
        BlocProvider.of<EpisodeImageBloc>(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EpisodeCreationBloc(
            GetIt.I<CreateEpisodeUsecase>(),
          ),
        ),
      ],
      child: PlatformScaffold(
        appBar: PlatformAppBar(
          leading: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 3.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: AutoSizeText(
                  'Cancel',
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
              ),
            ),
          ),
          title: Center(
            child: GestureDetector(
              child: AutoSizeText(
                'Add episode',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          trailingActions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: BlocConsumer<EpisodeCreationBloc, EpisodeCreationState>(
                  listener: (ctx, episodeCreationState) {
                    if (episodeCreationState is EpisodeCreationFail) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(
                          content: PlatformText(episodeCreationState.message),
                        ),
                      );
                    } else if (episodeCreationState is EpisodeCreationSuccess) {
                      _listenEpisodeCreationSuccess(
                          context, _episodeFormBloc, _episodeImageBloc, ctx);
                    }
                  },
                  builder: (ctx, episodeCreationState) {
                    if (episodeCreationState is EpisodeCreationLoading) {
                      return Center(
                        child: PlatformCircularProgressIndicator(),
                      );
                    }
                    return _buildEpisodeCreationSuccess(ctx);
                  },
                ),
              ),
            ),
          ],
        ),
        body: AddEpisodeForm(
          episodeFormBloc: _episodeFormBloc,
          episodeImageBloc: _episodeImageBloc,
        ),
      ),
    );
  }

  BlocBuilder<EpisodeFormBloc, EpisodeFormState> _buildEpisodeCreationSuccess(
      BuildContext ctx) {
    return BlocBuilder<EpisodeFormBloc, EpisodeFormState>(
      builder: (context, episopeFormState) {
        return GestureDetector(
          onTap: () {
            if (episopeFormState.episode.isValid()) {
              BlocProvider.of<EpisodeCreationBloc>(context)
                  .add(CreateEpisode(episopeFormState.episode));
            }
          },
          child: AutoSizeText(
            'Add',
            style: platformThemeData(
              ctx,
              material: (data) => data.textTheme.bodyText1!.copyWith(
                color: episopeFormState.episode.isValid()
                    ? accentColor
                    : accentColor.withAlpha(100),
              ),
              cupertino: (data) => data.textTheme.textStyle.copyWith(
                color: episopeFormState.episode.isValid()
                    ? accentColor
                    : accentColor.withAlpha(100),
              ),
            ),
          ),
        );
      },
    );
  }

  void _listenEpisodeCreationSuccess(
      BuildContext context,
      EpisodeFormBloc _episodeFormBloc,
      EpisodeImageBloc _episodeImageBloc,
      BuildContext ctx) {
    BlocProvider.of<EpisodesBloc>(context)
        .add(FetchShowEpisodes(_episodeFormBloc.state.episode.showId));
    _episodeFormBloc.add(EpisodeClear());
    _episodeImageBloc.add(ClearImage());
    Navigator.of(context).pop();
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: PlatformText('Episode created!'),
      ),
    );
  }
}
