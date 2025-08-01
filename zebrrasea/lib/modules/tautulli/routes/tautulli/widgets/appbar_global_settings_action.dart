import 'package:flutter/material.dart';
import 'package:zebrrasea/core.dart';
import 'package:zebrrasea/modules/tautulli.dart';

class TautulliAppBarGlobalSettingsAction extends StatelessWidget {
  const TautulliAppBarGlobalSettingsAction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZebrraIconButton(
      icon: Icons.more_vert_rounded,
      onPressed: () async {
        Tuple2<bool, TautulliGlobalSettingsType?> values =
            await TautulliDialogs().globalSettings(context);
        if (values.item1) values.item2!.execute(context);
      },
    );
  }
}
