import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../../../../core/constants/colors.dart';
import '../../../domain/models/episode.dart';
import '../../blocs/episode_form_bloc/episode_form_bloc.dart';

class AddEpisodeInputFileds extends StatefulWidget {
  const AddEpisodeInputFileds({
    Key? key,
    required EpisodeFormBloc episodeFormBloc,
  })  : _episodeFormBloc = episodeFormBloc,
        super(key: key);

  final EpisodeFormBloc _episodeFormBloc;

  @override
  _AddEpisodeInputFiledsState createState() => _AddEpisodeInputFiledsState();
}

class _AddEpisodeInputFiledsState extends State<AddEpisodeInputFileds> {
  late final FocusNode _numberFocusNode;
  late final FocusNode _descriptionFocusNode;

  @override
  void initState() {
    _numberFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _numberFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PlatformTextField(
            hintText: 'Episode title',
            textInputAction: TextInputAction.next,
            onSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_numberFocusNode),
            onChanged: (String title) =>
                widget._episodeFormBloc.add(EpisodeTitleChanged(title)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<EpisodeFormBloc, EpisodeFormState>(
            builder: (context, formState) {
              return PlatformTextField(
                focusNode: _numberFocusNode,
                maxLines: 1,
                hintText: 'Season & episode',
                cupertino: (ctx, target) => CupertinoTextFieldData(
                  suffix: _buildSuffix(formState, ctx),
                ),
                material: (ctx, target) => MaterialTextFieldData(
                  decoration: InputDecoration(
                    suffix: _buildSuffix(formState, ctx),
                  ),
                ),
                textInputAction: TextInputAction.next,
                onSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_descriptionFocusNode),
                onChanged: (String number) =>
                    widget._episodeFormBloc.add(EpisodeNumberChanged(number)),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PlatformTextField(
            hintText: 'Episode description',
            textInputAction: TextInputAction.done,
            maxLines: null,
            focusNode: _descriptionFocusNode,
            onChanged: (String description) => widget._episodeFormBloc
                .add(EpisodeDescriptionChanged(description)),
          ),
        ),
      ],
    );
  }

  PlatformText _buildSuffix(EpisodeFormState formState, BuildContext ctx) {
    final Episode _currentEpisode = formState.episode;
    final String _episodeNumber = _currentEpisode.episodeNumber.isEmpty
        ? ''
        : ', ' + _currentEpisode.episodeNumber;

    return PlatformText(
      _currentEpisode.seasonNumber + _episodeNumber,
      style: platformThemeData(
        ctx,
        material: (data) => data.textTheme.bodyText1!.copyWith(
          color: accentColor,
        ),
        cupertino: (data) => data.textTheme.textStyle.copyWith(
          color: accentColor,
        ),
      ),
    );
  }
}
