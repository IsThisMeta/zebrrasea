import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:zebrrasea/core.dart';
import 'package:zebrrasea/modules/radarr.dart';
import 'package:zebrrasea/modules/radarr/routes/movie_details/sheets/links.dart';
import 'package:zebrrasea/router/routes/radarr.dart';
import 'package:zebrrasea/widgets/pages/invalid_route.dart';

class MovieDetailsRoute extends StatefulWidget {
  final int movieId;

  const MovieDetailsRoute({
    Key? key,
    required this.movieId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<MovieDetailsRoute> with ZebrraLoadCallbackMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  RadarrMovie? movie;
  PageController? _pageController;

  @override
  Future<void> loadCallback() async {
    if (widget.movieId > 0) {
      RadarrMovie? result =
          _findMovie(await context.read<RadarrState>().movies!);
      setState(() => movie = result);
      context.read<RadarrState>().fetchQualityProfiles();
      context.read<RadarrState>().fetchTags();
      await context.read<RadarrState>().resetSingleMovie(widget.movieId);
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: RadarrDatabase.NAVIGATION_INDEX_MOVIE_DETAILS.read(),
    );
  }

  RadarrMovie? _findMovie(List<RadarrMovie> movies) {
    return movies.firstWhereOrNull(
      (movie) => movie.id == widget.movieId,
    );
  }

  List<RadarrTag> _findTags(List<int?>? tagIds, List<RadarrTag> tags) {
    return tags.where((tag) => tagIds!.contains(tag.id)).toList();
  }

  RadarrQualityProfile? _findQualityProfile(
      int? profileId, List<RadarrQualityProfile> profiles) {
    return profiles.firstWhereOrNull(
      (profile) => profile.id == profileId,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movieId <= 0)
      return InvalidRoutePage(
        title: 'Movie Details',
        message: 'Movie Not Found',
      );
    return ZebrraScaffold(
      scaffoldKey: _scaffoldKey,
      module: ZebrraModule.RADARR,
      appBar: _appBar(),
      bottomNavigationBar:
          context.watch<RadarrState>().enabled ? _bottomNavigationBar() : null,
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    List<Widget>? _actions;

    if (movie != null) {
      _actions = [
        ZebrraIconButton(
          icon: ZebrraIcons.LINK,
          onPressed: () async {
            LinksSheet(movie: movie!).show();
          },
        ),
        ZebrraIconButton(
          icon: ZebrraIcons.EDIT,
          onPressed: () => RadarrRoutes.MOVIE_EDIT.go(params: {
            'movie': widget.movieId.toString(),
          }),
        ),
        RadarrAppBarMovieSettingsAction(movieId: widget.movieId),
      ];
    }

    return ZebrraAppBar(
      pageController: _pageController,
      scrollControllers: RadarrMovieDetailsNavigationBar.scrollControllers,
      title: 'Movie Details',
      actions: _actions,
    );
  }

  Widget? _bottomNavigationBar() {
    if (movie == null) return null;
    return RadarrMovieDetailsNavigationBar(
      pageController: _pageController,
      movie: movie,
    );
  }

  Widget _body() {
    return Consumer<RadarrState>(
      builder: (context, state, _) => FutureBuilder(
        future: Future.wait([
          state.qualityProfiles!,
          state.tags!,
          state.movies!,
        ]),
        builder: (context, AsyncSnapshot<List<Object>> snapshot) {
          if (snapshot.hasError) {
            if (snapshot.connectionState != ConnectionState.waiting)
              ZebrraLogger().error(
                'Unable to pull Radarr movie details',
                snapshot.error,
                snapshot.stackTrace,
              );
            return ZebrraMessage.error(onTap: loadCallback);
          }
          if (snapshot.hasData) {
            movie = _findMovie(snapshot.data![2] as List<RadarrMovie>);
            if (movie == null)
              return ZebrraMessage.goBack(
                text: 'Movie Not Found',
                context: context,
              );
            RadarrQualityProfile? qualityProfile = _findQualityProfile(
                movie!.qualityProfileId,
                snapshot.data![0] as List<RadarrQualityProfile>);
            List<RadarrTag> tags =
                _findTags(movie!.tags, snapshot.data![1] as List<RadarrTag>);
            return _pages(qualityProfile, tags);
          }
          return const ZebrraLoader();
        },
      ),
    );
  }

  Widget _pages(RadarrQualityProfile? qualityProfile, List<RadarrTag> tags) {
    return ChangeNotifierProvider(
      create: (context) =>
          RadarrMovieDetailsState(context: context, movie: movie!),
      builder: (context, _) => ZebrraPageView(
        controller: _pageController,
        children: [
          RadarrMovieDetailsOverviewPage(
            movie: movie,
            qualityProfile: qualityProfile,
            tags: tags,
          ),
          const RadarrMovieDetailsFilesPage(),
          RadarrMovieDetailsHistoryPage(movie: movie),
          RadarrMovieDetailsCastCrewPage(movie: movie),
        ],
      ),
    );
  }
}
