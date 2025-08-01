import 'package:flutter/material.dart';
import 'package:zebrrasea/core.dart';
import 'package:zebrrasea/modules/sonarr.dart';
import 'package:zebrrasea/router/routes/sonarr.dart';

class SonarrSeasonDetailsNavigationBar extends StatefulWidget {
  static const List<IconData> icons = [
    Icons.live_tv_rounded,
    Icons.history_rounded,
  ];

  static final List<String> titles = [
    'sonarr.Episodes'.tr(),
    'sonarr.History'.tr(),
  ];

  static List<ScrollController> scrollControllers =
      List.generate(icons.length, (_) => ScrollController());
  final PageController? pageController;
  final int seriesId;
  final int seasonNumber;

  const SonarrSeasonDetailsNavigationBar({
    Key? key,
    required this.pageController,
    required this.seriesId,
    required this.seasonNumber,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SonarrSeasonDetailsNavigationBar> {
  ZebrraLoadingState _automaticLoadingState = ZebrraLoadingState.INACTIVE;

  @override
  Widget build(BuildContext context) {
    return ZebrraBottomNavigationBar(
      pageController: widget.pageController,
      scrollControllers: SonarrSeasonDetailsNavigationBar.scrollControllers,
      icons: SonarrSeasonDetailsNavigationBar.icons,
      titles: SonarrSeasonDetailsNavigationBar.titles,
      topActions: [
        ZebrraButton(
          type: ZebrraButtonType.TEXT,
          text: 'sonarr.Automatic'.tr(),
          icon: Icons.search_rounded,
          onTap: _automatic,
          loadingState: _automaticLoadingState,
        ),
        ZebrraButton.text(
          text: 'sonarr.Interactive'.tr(),
          icon: Icons.person_rounded,
          onTap: _manual,
        ),
      ],
    );
  }

  Future<void> _automatic() async {
    Future<void> setLoadingState(ZebrraLoadingState state) async {
      if (this.mounted) setState(() => _automaticLoadingState = state);
    }

    setLoadingState(ZebrraLoadingState.ACTIVE);
    SonarrAPIController()
        .automaticSeasonSearch(
          context: context,
          seriesId: widget.seriesId,
          seasonNumber: widget.seasonNumber,
        )
        .whenComplete(() => setLoadingState(ZebrraLoadingState.INACTIVE));
  }

  Future<void> _manual() async {
    return SonarrRoutes.RELEASES.go(queryParams: {
      'series': widget.seriesId.toString(),
      'season': widget.seasonNumber.toString(),
    });
  }
}
