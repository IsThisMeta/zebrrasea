import 'package:flutter/material.dart';
import 'package:zebrrasea/core.dart';
import 'package:zebrrasea/modules/radarr.dart';
import 'package:zebrrasea/router/routes/radarr.dart';

class RadarrManualImportBottomActionBar extends StatelessWidget {
  const RadarrManualImportBottomActionBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZebrraBottomActionBar(
      actions: [
        ZebrraButton.text(
          text: 'radarr.Quick'.tr(),
          icon: Icons.search_rounded,
          onTap: () async => RadarrAPIHelper().quickImport(
            context: context,
            path: context.read<RadarrManualImportState>().currentPath,
          ),
        ),
        ZebrraButton.text(
          text: 'radarr.Interactive'.tr(),
          icon: Icons.person_rounded,
          onTap: () => RadarrRoutes.MANUAL_IMPORT_DETAILS.go(queryParams: {
            'path': context.read<RadarrManualImportState>().currentPath,
          }),
        ),
      ],
    );
  }
}
