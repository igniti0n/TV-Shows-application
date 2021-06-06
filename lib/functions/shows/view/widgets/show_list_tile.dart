import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../../../core/constants/pages.dart';
import '../../../episodes/view/blocs/episodes_bloc/episodes_bloc.dart';
import '../../domain/models/show.dart';
import '../blocs/single_show_bloc/single_show_bloc.dart';

class ShowListTile extends StatelessWidget {
  const ShowListTile({
    Key? key,
    required Show show,
    required this.imageHeight,
    required this.imageWidth,
    required this.autoSizeGroup,
    required this.singleShowBloc,
    required this.episodesBloc,
  })  : _show = show,
        super(key: key);

  final Show _show;
  final double imageHeight;
  final double imageWidth;
  final AutoSizeGroup autoSizeGroup;
  final SingleShowBloc singleShowBloc;
  final EpisodesBloc episodesBloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => _navigateToShowDetails(context),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: 'https://api.infinum.academy' + _show.imageUrl,
              imageBuilder: (ctx, image) => Container(
                padding: const EdgeInsets.all(2),
                height: imageHeight,
                width: imageWidth,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(212, 212, 212, 1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image(
                    image: image,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              placeholder: (context, url) =>
                  Center(child: PlatformCircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        _show.title,
                        maxLines: 1,
                        group: autoSizeGroup,
                        textAlign: TextAlign.left,
                        style: platformThemeData(
                          context,
                          material: (data) => data.textTheme.bodyText1!
                              .copyWith(
                                  color: Color.fromRGBO(80, 80, 80, 1),
                                  fontSize: 40),
                          cupertino: (data) => data.textTheme.textStyle
                              .copyWith(
                                  color: Color.fromRGBO(80, 80, 80, 1),
                                  fontSize: 40),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToShowDetails(BuildContext context) {
    singleShowBloc.add(FetchShow(_show.id));
    episodesBloc.add(FetchShowEpisodes(_show.id));
    Navigator.of(context).pushReplacementNamed(ROUTE_SHOW_DETAILS);
  }
}
