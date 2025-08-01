import 'package:flutter/material.dart';
import 'package:zebrrasea/core.dart';
import 'package:zebrrasea/modules/radarr.dart';

class RadarrSystemStatusHealthCheckPage extends StatefulWidget {
  final ScrollController scrollController;

  const RadarrSystemStatusHealthCheckPage({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<RadarrSystemStatusHealthCheckPage> createState() => _State();
}

class _State extends State<RadarrSystemStatusHealthCheckPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  bool get wantKeepAlive => true;

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
      onRefresh: () async =>
          context.read<RadarrSystemStatusState>().fetchHealthCheck(context),
      child: FutureBuilder(
          future: context.read<RadarrSystemStatusState>().healthCheck,
          builder: (context, AsyncSnapshot<List<RadarrHealthCheck>> snapshot) {
            if (snapshot.hasError) {
              ZebrraLogger().error('Unable to fetch Radarr health check',
                  snapshot.error, snapshot.stackTrace);
              return ZebrraMessage.error(onTap: _refreshKey.currentState!.show);
            }
            if (snapshot.hasData) return _list(snapshot.data);
            return const ZebrraLoader();
          }),
    );
  }

  Widget _list(List<RadarrHealthCheck>? checks) {
    if ((checks?.length ?? 0) == 0)
      return ZebrraMessage(
        text: 'No Issues Found',
        buttonText: 'Refresh',
        onTap: _refreshKey.currentState!.show,
      );
    return ZebrraListViewBuilder(
      controller: widget.scrollController,
      itemCount: checks!.length,
      itemBuilder: (context, index) =>
          RadarrHealthCheckTile(healthCheck: checks[index]),
    );
  }
}
