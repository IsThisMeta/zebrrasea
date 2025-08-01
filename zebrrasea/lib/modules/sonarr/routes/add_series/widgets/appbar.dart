import 'package:flutter/material.dart';
import 'package:zebrrasea/core.dart';
import 'package:zebrrasea/modules/sonarr.dart';

// ignore: non_constant_identifier_names
Widget SonarrSeriesAddAppBar({
  required ScrollController scrollController,
  required String? query,
  required bool autofocus,
}) =>
    ZebrraAppBar(
      title: 'sonarr.AddSeries'.tr(),
      scrollControllers: [scrollController],
      bottom: _SearchBar(
        scrollController: scrollController,
        query: query ?? '',
        autofocus: autofocus,
      ),
    );

class _SearchBar extends StatefulWidget implements PreferredSizeWidget {
  final String query;
  final bool autofocus;
  final ScrollController scrollController;

  const _SearchBar({
    Key? key,
    required this.query,
    required this.autofocus,
    required this.scrollController,
  }) : super(key: key);

  @override
  Size get preferredSize =>
      const Size.fromHeight(ZebrraTextInputBar.defaultAppBarHeight);

  @override
  State<_SearchBar> createState() => _State();
}

class _State extends State<_SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.query;
  }

  @override
  Widget build(BuildContext context) => Consumer<SonarrState>(
        builder: (context, state, _) => SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ZebrraTextInputBar(
                  controller: _controller,
                  scrollController: widget.scrollController,
                  autofocus: widget.autofocus,
                  onChanged: (value) =>
                      context.read<SonarrAddSeriesState>().searchQuery = value,
                  onSubmitted: (value) {
                    if (value.isNotEmpty)
                      context.read<SonarrAddSeriesState>().fetchLookup(context);
                  },
                  margin: ZebrraTextInputBar.appBarMargin,
                ),
              ),
            ],
          ),
          height: ZebrraTextInputBar.defaultAppBarHeight,
        ),
      );
}
