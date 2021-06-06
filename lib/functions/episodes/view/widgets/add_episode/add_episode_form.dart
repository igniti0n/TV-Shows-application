import 'dart:io';

import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/constants/colors.dart';
import '../../blocs/episode_form_bloc/episode_form_bloc.dart';
import '../../blocs/episode_image/episode_image_bloc.dart';

import 'add_episode_input_fields.dart';

class AddEpisodeForm extends StatelessWidget {
  const AddEpisodeForm({
    Key? key,
    required EpisodeFormBloc episodeFormBloc,
    required EpisodeImageBloc episodeImageBloc,
  })  : _episodeFormBloc = episodeFormBloc,
        _episodeImageBloc = episodeImageBloc,
        super(key: key);
  final EpisodeFormBloc _episodeFormBloc;
  final EpisodeImageBloc _episodeImageBloc;

  @override
  Widget build(BuildContext context) {
    final Size _deviceSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: GestureDetector(
              onTap: () => _callbackPickEpisodeImage(context),
              child: ConstrainedBox(
                constraints: BoxConstraints.tight(
                  Size(double.infinity, _deviceSize.height / 4),
                ),
                child: BlocConsumer<EpisodeImageBloc, EpisodeImageState>(
                  listener: (ctx, episodeImageState) {
                    if (episodeImageState is ImagePickingError) {
                      _listenImagePickError(ctx, episodeImageState, context);
                    } else if (episodeImageState is ImagePicked) {
                      _listenImagePickedSUccess(episodeImageState, context);
                    }
                  },
                  builder: (ctx, episodeImageState) {
                    if (episodeImageState.imagePath.isEmpty) {
                      return _buildImageNotPicked(ctx);
                    }

                    return Image.file(
                      File(episodeImageState.imagePath),
                      fit: BoxFit.fitWidth,
                    );
                  },
                ),
              ),
            ),
          ),
          AddEpisodeInputFileds(episodeFormBloc: _episodeFormBloc),
        ],
      ),
    ));
  }

  void _listenImagePickedSUccess(
      ImagePicked episodeImageState, BuildContext context) {
    _episodeFormBloc.add(EpisodeImageChanged(episodeImageState.imagePath));
    Navigator.of(context).pop();
  }

  void _listenImagePickError(BuildContext ctx,
      ImagePickingError episodeImageState, BuildContext context) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: PlatformText(episodeImageState.message),
      ),
    );
    Navigator.of(context).pop();
  }

  void _callbackPickEpisodeImage(BuildContext context) {
    _episodeImageBloc.add(StartImageSourcePicking());
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        //title: Text('Alert'),
        content: Text('Pick image source'),
        actions: <Widget>[
          PlatformDialogAction(
            child: Text('Gallery'),
            onPressed: () =>
                _episodeImageBloc.add(StartImagePicking(ImageSource.gallery)),
          ),
          PlatformDialogAction(
            child: Text('Camera'),
            onPressed: () =>
                _episodeImageBloc.add(StartImagePicking(ImageSource.camera)),
          ),
        ],
      ),
    );
  }

  Column _buildImageNotPicked(BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.camera_alt_outlined,
          size: 30,
          color: accentColor,
        ),
        AutoSizeText(
          'Upload photo',
          style: platformThemeData(
            ctx,
            material: (data) => data.textTheme.bodyText1!.copyWith(
              color: accentColor,
            ),
            cupertino: (data) => data.textTheme.textStyle.copyWith(
              color: accentColor,
            ),
          ),
        )
      ],
    );
  }
}
