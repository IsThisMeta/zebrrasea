import 'package:flutter/material.dart';
import 'package:zebrrasea/core.dart';
import 'package:zebrrasea/modules/sonarr.dart';

class SonarrSeriesAddDetailsRootFolderTile extends StatelessWidget {
  const SonarrSeriesAddDetailsRootFolderTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZebrraBlock(
      title: 'sonarr.RootFolder'.tr(),
      body: [
        TextSpan(
          text: context.watch<SonarrSeriesAddDetailsState>().rootFolder.path ??
              ZebrraUI.TEXT_EMDASH,
        ),
      ],
      trailing: const ZebrraIconButton.arrow(),
      onTap: () async => _onTap(context),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    List<SonarrRootFolder> _folders =
        await context.read<SonarrState>().rootFolders!;
    Tuple2<bool, SonarrRootFolder?> result =
        await SonarrDialogs().editRootFolder(context, _folders);
    if (result.item1) {
      context.read<SonarrSeriesAddDetailsState>().rootFolder = result.item2!;
      SonarrDatabase.ADD_SERIES_DEFAULT_ROOT_FOLDER.update(result.item2!.id);
    }
  }
}
