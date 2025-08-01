import 'package:flutter/material.dart';
import 'package:zebrrasea/core.dart';
import 'package:zebrrasea/extensions/string/string.dart';
import 'package:zebrrasea/modules/tautulli.dart';
import 'package:zebrrasea/router/routes/tautulli.dart';

class TautulliHistoryTile extends StatelessWidget {
  final TautulliHistoryRecord history;

  const TautulliHistoryTile({
    Key? key,
    required this.history,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZebrraBlock(
      title: history.lsTitle,
      body: [
        _subtitle1(),
        _subtitle2(),
        _subtitle3(),
      ],
      bodyLeadingIcons: [
        null,
        null,
        history.zebrraWatchStatusIcon,
      ],
      posterUrl:
          context.watch<TautulliState>().getImageURLFromPath(history.thumb),
      posterHeaders: context.watch<TautulliState>().headers,
      posterPlaceholderIcon: ZebrraIcons.VIDEO_CAM,
      backgroundHeaders: context.watch<TautulliState>().headers,
      backgroundUrl: context.watch<TautulliState>().getImageURLFromRatingKey(
            history.grandparentRatingKey ??
                history.parentRatingKey ??
                history.ratingKey ??
                '' as int?,
          ),
      onTap: () => TautulliRoutes.HISTORY_DETAILS.go(
        queryParams: {
          'reference_id': history.referenceId.toString(),
          'session_key': history.sessionKey.toString(),
        },
        params: {
          'rating_key': history.ratingKey!.toString(),
        },
      ),
    );
  }

  TextSpan _subtitle1() {
    return TextSpan(
      children: [
        if (history.mediaType == TautulliMediaType.EPISODE)
          TextSpan(
            children: [
              TextSpan(text: 'Season ${history.parentMediaIndex}'),
              TextSpan(text: ZebrraUI.TEXT_BULLET.pad()),
              TextSpan(text: 'Episode ${history.mediaIndex}: '),
              TextSpan(
                text: history.title,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        if (history.mediaType == TautulliMediaType.MOVIE)
          TextSpan(text: history.year.toString()),
        if (history.mediaType == TautulliMediaType.TRACK)
          TextSpan(
            children: [
              TextSpan(text: history.title),
              TextSpan(text: ZebrraUI.TEXT_BULLET.pad()),
              TextSpan(text: history.parentTitle),
            ],
          ),
        if (history.mediaType == TautulliMediaType.LIVE)
          TextSpan(text: history.title),
      ],
    );
  }

  TextSpan _subtitle2() {
    return TextSpan(text: history.lsDate);
  }

  TextSpan _subtitle3() {
    return TextSpan(text: history.friendlyName ?? 'Unknown User');
  }
}
