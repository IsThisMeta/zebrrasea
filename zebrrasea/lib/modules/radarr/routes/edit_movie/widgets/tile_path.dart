import 'package:flutter/material.dart';
import 'package:zebrrasea/core.dart';
import 'package:zebrrasea/modules/radarr.dart';

class RadarrMoviesEditPathTile extends StatelessWidget {
  const RadarrMoviesEditPathTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<RadarrMoviesEditState, String>(
      selector: (_, state) => state.path,
      builder: (context, path, _) => ZebrraBlock(
        title: 'radarr.MoviePath'.tr(),
        body: [TextSpan(text: path)],
        trailing: const ZebrraIconButton.arrow(),
        onTap: () async {
          Tuple2<bool, String> _values = await ZebrraDialogs().editText(
            context,
            'radarr.MoviePath'.tr(),
            prefill: path,
          );
          if (_values.item1)
            context.read<RadarrMoviesEditState>().path = _values.item2;
        },
      ),
    );
  }
}
