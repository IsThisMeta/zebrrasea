import 'package:flutter/material.dart';
import 'package:zebrrasea/core.dart';
import 'package:zebrrasea/modules/radarr.dart';

class RadarrMoviesEditMonitoredTile extends StatelessWidget {
  const RadarrMoviesEditMonitoredTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZebrraBlock(
      title: 'radarr.Monitored'.tr(),
      trailing: ZebrraSwitch(
        value: context.watch<RadarrMoviesEditState>().monitored,
        onChanged: (value) =>
            context.read<RadarrMoviesEditState>().monitored = value,
      ),
    );
  }
}
