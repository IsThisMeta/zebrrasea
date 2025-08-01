import 'package:flutter/material.dart';
import 'package:zebrrasea/core.dart';
import 'package:zebrrasea/modules/radarr.dart';
import 'package:zebrrasea/widgets/pages/invalid_route.dart';
import 'package:zebrrasea/widgets/sheets/download_client/button.dart';

class MovieReleasesRoute extends StatefulWidget {
  final int movieId;

  const MovieReleasesRoute({
    Key? key,
    required this.movieId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<MovieReleasesRoute> with ZebrraScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    if (widget.movieId <= 0) {
      return InvalidRoutePage(
        title: 'Releases',
        message: 'Movie Not Found',
      );
    }
    return ChangeNotifierProvider(
      create: (context) => RadarrReleasesState(context, widget.movieId),
      builder: (context, _) => ZebrraScaffold(
        scaffoldKey: _scaffoldKey,
        appBar: _appBar(context) as PreferredSizeWidget?,
        body: _body(context),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return ZebrraAppBar(
      title: 'Releases',
      scrollControllers: [scrollController],
      bottom: RadarrReleasesSearchBar(scrollController: scrollController),
      actions: const [
        DownloadClientButton(),
      ],
    );
  }

  Widget _body(BuildContext context) {
    return ZebrraRefreshIndicator(
      context: context,
      key: _refreshKey,
      onRefresh: () async {
        context.read<RadarrReleasesState>().refreshReleases(context);
        await context.read<RadarrReleasesState>().releases;
      },
      child: FutureBuilder(
        future: context.read<RadarrReleasesState>().releases,
        builder: (context, AsyncSnapshot<List<RadarrRelease>> snapshot) {
          if (snapshot.hasError) {
            if (snapshot.connectionState != ConnectionState.waiting) {
              ZebrraLogger().error(
                'Unable to fetch Radarr releases: ${widget.movieId}',
                snapshot.error,
                snapshot.stackTrace,
              );
            }
            return ZebrraMessage.error(
              onTap: () => _refreshKey.currentState!.show,
            );
          }
          if (snapshot.hasData) return _list(context, snapshot.data);
          return const ZebrraLoader();
        },
      ),
    );
  }

  Widget _list(BuildContext context, List<RadarrRelease>? releases) {
    return Consumer<RadarrReleasesState>(
      builder: (context, state, _) {
        if ((releases?.length ?? 0) == 0) {
          return ZebrraMessage(
            text: 'No Releases Found',
            buttonText: 'Refresh',
            onTap: _refreshKey.currentState!.show,
          );
        }
        List<RadarrRelease> _processed = _filterAndSortReleases(
          releases ?? [],
          state,
        );
        return ZebrraListViewBuilder(
          controller: scrollController,
          itemCount: _processed.isEmpty ? 1 : _processed.length,
          itemBuilder: (context, index) {
            if (_processed.isEmpty) {
              return ZebrraMessage.inList(text: 'No Releases Found');
            }
            return RadarrReleasesTile(release: _processed[index]);
          },
        );
      },
    );
  }

  List<RadarrRelease> _filterAndSortReleases(
    List<RadarrRelease> releases,
    RadarrReleasesState state,
  ) {
    if (releases.isEmpty) return releases;
    List<RadarrRelease> filtered = releases.where(
      (release) {
        String _query = state.searchQuery;
        if (_query.isNotEmpty) {
          return release.title!.toLowerCase().contains(_query.toLowerCase());
        }
        return true;
      },
    ).toList();
    filtered = state.filterType.filter(filtered);
    filtered = state.sortType.sort(filtered, state.sortAscending);
    return filtered;
  }
}
