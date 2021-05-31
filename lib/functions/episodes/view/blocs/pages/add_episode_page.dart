import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:tw_shows/core/constants/colors.dart';
import 'package:image_picker/image_picker.dart';

class AddEpisodePage extends StatelessWidget {
  const AddEpisodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
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
          child: AutoSizeText(
            'Add episode',
            textAlign: TextAlign.center,
          ),
        ),
        trailingActions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 3.0),
              child: AutoSizeText(
                'Add',
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
        ],
      ),
      body: AddEpisodeForm(),
    );
  }
}

class AddEpisodeForm extends StatelessWidget {
  const AddEpisodeForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: GestureDetector(
              onTap: () {},
              child: Column(
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
                      context,
                      material: (data) => data.textTheme.bodyText1!.copyWith(
                        color: accentColor,
                      ),
                      cupertino: (data) => data.textTheme.textStyle.copyWith(
                        color: accentColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PlatformTextField(
              hintText: 'Episode title',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PlatformTextField(
              hintText: 'Season & episode',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PlatformTextField(
              hintText: 'Episode description',
            ),
          ),
        ],
      ),
    ));
  }
}
