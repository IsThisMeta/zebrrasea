import 'package:flutter/material.dart';
import 'package:zebrrasea/core.dart';
import 'package:zebrrasea/modules/tautulli.dart';

class TautulliGraphsStreamInformationRoute extends StatefulWidget {
  const TautulliGraphsStreamInformationRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<TautulliGraphsStreamInformationRoute> createState() => _State();
}

class _State extends State<TautulliGraphsStreamInformationRoute>
    with AutomaticKeepAliveClientMixin, ZebrraLoadCallbackMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Future<void> loadCallback() async {
    context.read<TautulliState>().resetAllStreamInformationGraphs();
    await Future.wait([
      context.read<TautulliState>().dailyStreamTypeBreakdownGraph!,
      context.read<TautulliState>().playCountBySourceResolutionGraph!,
      context.read<TautulliState>().playCountByStreamResolutionGraph!,
      context.read<TautulliState>().playCountByPlatformStreamTypeGraph!,
      context.read<TautulliState>().playCountByUserStreamTypeGraph!,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ZebrraScaffold(
      scaffoldKey: _scaffoldKey,
      body: _body(),
    );
  }

  Widget _body() {
    return ZebrraRefreshIndicator(
      context: context,
      key: _refreshKey,
      onRefresh: loadCallback,
      child: ZebrraListView(
        controller: TautulliGraphsNavigationBar.scrollControllers[1],
        children: [
          ZebrraHeader(
            text: 'Daily Stream Type Breakdown',
            subtitle: [
              'Last ${TautulliDatabase.GRAPHS_LINECHART_DAYS.read()} Days',
              '\n\n',
              'The total play count or duration of television, movies, and music by the transcode decision.',
            ].join(),
          ),
          const TautulliGraphsDailyStreamTypeBreakdownGraph(),
          ZebrraHeader(
            text: 'By Source Resolution',
            subtitle: [
              'Last ${TautulliDatabase.GRAPHS_DAYS.read()} Days',
              '\n\n',
              'The combined total of television and movies by their original resolution (pre-transcoding).',
            ].join(),
          ),
          const TautulliGraphsPlayCountBySourceResolutionGraph(),
          ZebrraHeader(
            text: 'By Stream Resolution',
            subtitle: [
              'Last ${TautulliDatabase.GRAPHS_DAYS.read()} Days',
              '\n\n',
              'The combined total of television and movies by their streamed resolution (post-transcoding).',
            ].join(),
          ),
          const TautulliGraphsPlayCountByStreamResolutionGraph(),
          ZebrraHeader(
            text: 'By Platform Stream Type',
            subtitle: [
              'Last ${TautulliDatabase.GRAPHS_DAYS.read()} Days',
              '\n\n',
              'The combined total of television, movies, and music by platform and stream type.',
            ].join(),
          ),
          const TautulliGraphsPlayCountByPlatformStreamTypeGraph(),
          ZebrraHeader(
            text: 'By User Stream Type',
            subtitle: [
              'Last ${TautulliDatabase.GRAPHS_DAYS.read()} Days',
              '\n\n',
              'The combined total of television, movies, and music by user and stream type.',
            ].join(),
          ),
          const TautulliGraphsPlayCountByUserStreamTypeGraph(),
        ],
      ),
    );
  }
}
