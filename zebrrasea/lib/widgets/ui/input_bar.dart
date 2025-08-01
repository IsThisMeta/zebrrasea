import 'package:flutter/material.dart';
import 'package:zebrrasea/core.dart';
import 'package:zebrrasea/extensions/scroll_controller.dart';

class ZebrraTextInputBar extends StatefulWidget {
  static const double defaultHeight = 50.0;
  static const double defaultAppBarHeight =
      defaultHeight + ZebrraUI.DEFAULT_MARGIN_SIZE;
  static const EdgeInsets appBarMargin = EdgeInsets.fromLTRB(
    ZebrraUI.DEFAULT_MARGIN_SIZE,
    0,
    ZebrraUI.DEFAULT_MARGIN_SIZE,
    ZebrraUI.DEFAULT_MARGIN_SIZE,
  );

  final TextEditingController? controller;
  final ScrollController? scrollController;
  final TextInputAction action;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final Iterable<String>? autofillHints;
  final String? labelText;
  final IconData labelIcon;
  final bool autofocus;
  final bool obscureText;
  final bool isFormField;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final EdgeInsets margin;

  const ZebrraTextInputBar({
    Key? key,
    required this.controller,
    this.scrollController,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.autofillHints,
    this.action = TextInputAction.search,
    this.keyboardType = TextInputType.text,
    this.labelText,
    this.labelIcon = Icons.search_rounded,
    this.margin = ZebrraUI.MARGIN_H_DEFAULT_V_HALF,
    this.focusNode,
    this.autofocus = false,
    this.obscureText = false,
    this.isFormField = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ZebrraTextInputBar> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_controllerListener);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_controllerListener);
    super.dispose();
  }

  void _controllerListener() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) => ZebrraCard(
        context: context,
        margin: widget.margin,
        child: FocusScope(
          child: Focus(
            onFocusChange: (value) => setState(() => _isFocused = value),
            child: widget.isFormField ? _isForm : _isNotForm,
          ),
        ),
        height: ZebrraTextInputBar.defaultHeight,
        color: Theme.of(context).canvasColor,
      );

  TextStyle get _sharedTextStyle => const TextStyle(
        color: ZebrraColours.white,
        fontSize: ZebrraUI.FONT_SIZE_H3,
      );

  InputDecoration get _sharedInputDecoration => InputDecoration(
        labelText: widget.labelText ?? 'zebrrasea.SearchTextBar'.tr(),
        labelStyle: const TextStyle(
          color: ZebrraColours.grey,
          decoration: TextDecoration.none,
          fontSize: ZebrraUI.FONT_SIZE_H3,
        ),
        suffixIcon: AnimatedOpacity(
          child: InkWell(
            child: const Icon(
              Icons.close_rounded,
              color: ZebrraColours.accent,
              size: 24.0,
            ),
            onTap: !_isFocused || widget.controller!.text == ''
                ? null
                : () {
                    widget.scrollController?.animateToStart();
                    widget.controller!.text = '';
                    if (widget.onChanged != null) widget.onChanged!('');
                  },
            mouseCursor: !_isFocused || widget.controller!.text == ''
                ? SystemMouseCursors.text
                : SystemMouseCursors.click,
            borderRadius: BorderRadius.circular(24.0),
            hoverColor: Colors.transparent,
          ),
          opacity: !_isFocused || widget.controller!.text == '' ? 0.0 : 1.0,
          duration: const Duration(milliseconds: ZebrraUI.ANIMATION_SPEED),
        ),
        icon: Padding(
          child: Icon(
            widget.labelIcon,
            color: ZebrraColours.accent,
          ),
          padding: const EdgeInsets.only(left: 16.0),
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      );

  TextFormField get _isForm => TextFormField(
        autofillHints: widget.autofillHints,
        autofocus: widget.autofocus,
        controller: widget.controller,
        decoration: _sharedInputDecoration,
        style: _sharedTextStyle,
        cursorColor: ZebrraColours.accent,
        textInputAction: widget.action,
        obscureText: widget.obscureText,
        autocorrect: false,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        onTap: widget.scrollController?.animateToStart,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        focusNode: widget.focusNode,
      );

  TextField get _isNotForm => TextField(
        autofillHints: widget.autofillHints,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        controller: widget.controller,
        decoration: _sharedInputDecoration,
        style: _sharedTextStyle,
        cursorColor: ZebrraColours.accent,
        textInputAction: widget.action,
        obscureText: widget.obscureText,
        autocorrect: false,
        keyboardType: widget.keyboardType,
        onTap: widget.scrollController?.animateToStart,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
      );
}
