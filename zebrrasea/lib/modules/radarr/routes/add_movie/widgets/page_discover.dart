import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:zebrrasea/core.dart';
import 'package:zebrrasea/modules/radarr.dart';

class RadarrAddMovieDiscoverPage extends StatefulWidget {
  const RadarrAddMovieDiscoverPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<RadarrAddMovieDiscoverPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  bool get wantKeepAlive => true;

  Future<void> loadCallback() async {
    context.read<RadarrAddMovieState>().fetchDiscovery(context);
    await context.read<RadarrAddMovieState>().discovery;
    await context.read<RadarrAddMovieState>().exclusions;
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
      child: Selector<RadarrState, Future<List<RadarrMovie>>?>(
        selector: (_, state) => state.movies,
        builder: (context, movies, _) => Selector<RadarrAddMovieState,
            Tuple2<Future<List<RadarrMovie>>?, Future<List<RadarrExclusion>>?>>(
          selector: (_, state) => Tuple2(state.discovery, state.exclusions),
          builder: (context, tuple, _) => FutureBuilder(
            future: Future.wait([movies!, tuple.item1!, tuple.item2!]),
            builder: (context, AsyncSnapshot<List<Object>> snapshot) {
              if (snapshot.hasError) {
                if (snapshot.connectionState != ConnectionState.waiting)
                  ZebrraLogger().error(
                    'Unable to fetch Radarr discovery',
                    snapshot.error,
                    snapshot.stackTrace,
                  );
                return ZebrraMessage.error(onTap: _refreshKey.currentState!.show);
              }
              if (snapshot.hasData)
                return _list(
                    snapshot.data![0] as List<RadarrMovie>,
                    snapshot.data![1] as List<RadarrMovie>,
                    snapshot.data![2] as List<RadarrExclusion>);
              return const ZebrraLoader();
            },
          ),
        ),
      ),
    );
  }

  Widget _list(List<RadarrMovie> movies, List<RadarrMovie> discovery,
      List<RadarrExclusion> exclusions) {
    List<RadarrMovie> _filtered = _filterAndSort(movies, discovery, exclusions);
    if (_filtered.isEmpty)
      return ZebrraMessage(
        text: 'radarr.NoMoviesFound'.tr(),
        buttonText: 'zebrrasea.Refresh'.tr(),
        onTap: _refreshKey.currentState!.show,
      );
    return ZebrraListViewBuilder(
      controller: RadarrAddMovieNavigationBar.scrollControllers[1],
      itemCount: _filtered.length,
      itemBuilder: (context, index) =>
          RadarrAddMovieDiscoveryResultTile(movie: _filtered[index]),
    );
  }

  List<RadarrMovie> _filterAndSort(
    List<RadarrMovie> movies,
    List<RadarrMovie> discovery,
    List<RadarrExclusion> exclusions,
  ) {
    if (discovery.isEmpty) return [];
    List<RadarrMovie> _filtered = discovery;
    // Filter out the excluded movies
    if (exclusions.isNotEmpty)
      _filtered = _filtered
          .where((discover) =>
              exclusions.firstWhereOrNull(
                (exclusion) => exclusion.tmdbId == discover.tmdbId,
              ) ==
              null)
          .toList();
    // Filter out the already added movies
    if (movies.isNotEmpty)
      _filtered = _filtered
          .where((discover) =>
              movies.firstWhereOrNull(
                (movie) => movie.tmdbId == discover.tmdbId,
              ) ==
              null)
          .toList();
    // Sort by the sort name
    _filtered.sort((a, b) =>
        a.sortTitle!.toLowerCase().compareTo(b.sortTitle!.toLowerCase()));
    return _filtered;
  }
}
