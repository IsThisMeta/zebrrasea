import 'package:flutter/material.dart';
import 'package:zebrrasea/core.dart';

class TautulliStatisticsStreamTile extends StatefulWidget {
  final Map<String, dynamic> data;

  const TautulliStatisticsStreamTile({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TautulliStatisticsStreamTile> {
  @override
  Widget build(BuildContext context) {
    return ZebrraBlock(
      title: widget.data['title'] ?? 'Unknown Title',
      body: _body(),
      posterIsSquare: true,
      posterPlaceholderIcon: ZebrraIcons.SHUFFLE,
    );
  }

  List<TextSpan> _body() {
    return [
      TextSpan(
        text: widget.data['count'].toString() +
            (widget.data['count'] == 1 ? ' Play' : ' Plays'),
        style: const TextStyle(
          color: ZebrraColours.accent,
          fontWeight: ZebrraUI.FONT_WEIGHT_BOLD,
        ),
      ),
      int.tryParse(widget.data['started']) != null
          ? TextSpan(
              text: ZebrraSeaDatabase.USE_24_HOUR_TIME.read()
                  ? DateFormat('yyyy-MM-dd HH:mm').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          int.tryParse(widget.data['started'])! * 1000))
                  : DateFormat('yyyy-MM-dd hh:mm a').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          int.tryParse(widget.data['started'])! * 1000)),
            )
          : const TextSpan(text: ZebrraUI.TEXT_EMDASH),
    ];
  }
}
