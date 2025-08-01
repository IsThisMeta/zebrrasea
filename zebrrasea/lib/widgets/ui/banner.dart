import 'package:flutter/material.dart';
import 'package:zebrrasea/core.dart';

class ZebrraBanner extends StatelessWidget {
  // An arbitrarily large number of max lines
  static const _MAX_LINES = 5000000;
  final String headerText;
  final String? bodyText;
  final IconData icon;
  final Color iconColor;
  final Color? backgroundColor;
  final Color headerColor;
  final Color bodyColor;
  final Function? dismissCallback;
  final List<ZebrraButton>? buttons;

  const ZebrraBanner({
    Key? key,
    this.dismissCallback,
    required this.headerText,
    this.bodyText,
    this.icon = Icons.info_outline_rounded,
    this.iconColor = ZebrraColours.accent,
    this.backgroundColor,
    this.headerColor = Colors.white,
    this.bodyColor = ZebrraColours.grey,
    this.buttons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZebrraCard(
      context: context,
      child: Container(
        padding:
            EdgeInsets.symmetric(vertical: ZebrraUI.MARGIN_H_DEFAULT_V_HALF.top),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: ZebrraUI.MARGIN_H_DEFAULT_V_HALF,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    child: Icon(
                      icon,
                      size: 20.0,
                      color: iconColor,
                    ),
                    padding: EdgeInsets.only(
                        right: ZebrraUI.MARGIN_DEFAULT.right - 2.0),
                  ),
                  Expanded(
                    child: ZebrraText.title(
                      text: headerText,
                      color: headerColor,
                      maxLines: _MAX_LINES,
                      softWrap: true,
                    ),
                  ),
                  if (dismissCallback != null)
                    InkWell(
                      child: const Icon(
                        Icons.close_rounded,
                        size: 20.0,
                        color: ZebrraColours.accent,
                      ),
                      borderRadius: BorderRadius.circular(24.0),
                      onTap: dismissCallback as void Function()?,
                    ),
                ],
              ),
            ),
            if (bodyText?.isNotEmpty ?? false)
              Padding(
                padding: ZebrraUI.MARGIN_H_DEFAULT_V_HALF.copyWith(top: 0),
                child: ZebrraText.subtitle(
                  text: bodyText.toString(),
                  color: bodyColor,
                  softWrap: true,
                  maxLines: _MAX_LINES,
                ),
              ),
            if (buttons?.isNotEmpty ?? false)
              ZebrraButtonContainer(
                padding: EdgeInsets.symmetric(
                    horizontal: ZebrraUI.MARGIN_H_DEFAULT_V_HALF.left / 2),
                children: buttons!,
              ),
          ],
        ),
      ),
      color: backgroundColor,
    );
  }
}
