import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:zebrrasea/core.dart';

class ZebrraTheme {
  /// Initialize the theme by setting the system navigation and system colours.
  void initialize() {
    //Set system UI overlay style (navbar, statusbar)
    SystemChrome.setSystemUIOverlayStyle(overlayStyle);
  }

  /// Returns the active [ThemeData] by checking the theme database value.
  ThemeData activeTheme() {
    return isAMOLEDTheme ? _pureBlackTheme() : _midnightTheme();
  }

  static bool get isAMOLEDTheme => ZebrraSeaDatabase.THEME_AMOLED.read();
  static bool get useBorders => ZebrraSeaDatabase.THEME_AMOLED_BORDER.read();

  /// Midnight theme (Default)
  ThemeData _midnightTheme() {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.dark,
      canvasColor: ZebrraColours.primary,
      primaryColor: ZebrraColours.secondary,
      highlightColor: ZebrraColours.accent.withOpacity(ZebrraUI.OPACITY_SPLASH / 2),
      cardColor: ZebrraColours.secondary,
      hoverColor: ZebrraColours.accent.withOpacity(ZebrraUI.OPACITY_SPLASH / 2),
      splashColor: ZebrraColours.accent.withOpacity(ZebrraUI.OPACITY_SPLASH),
      dialogTheme: DialogThemeData(
        backgroundColor: ZebrraColours.secondary,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      tooltipTheme: const TooltipThemeData(
        decoration: BoxDecoration(
          color: ZebrraColours.secondary,
          borderRadius: BorderRadius.all(Radius.circular(ZebrraUI.BORDER_RADIUS)),
        ),
        textStyle: TextStyle(
          color: ZebrraColours.grey,
          fontSize: ZebrraUI.FONT_SIZE_SUBHEADER,
        ),
        preferBelow: true,
      ),
      unselectedWidgetColor: Colors.white,
      textTheme: _sharedTextTheme,
      textButtonTheme: _sharedTextButtonThemeData,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  /// AMOLED/Pure black theme
  ThemeData _pureBlackTheme() {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.dark,
      canvasColor: Colors.black,
      primaryColor: Colors.black,
      highlightColor: ZebrraColours.accent.withOpacity(ZebrraUI.OPACITY_SPLASH / 2),
      cardColor: Colors.black,
      hoverColor: ZebrraColours.accent.withOpacity(ZebrraUI.OPACITY_SPLASH / 2),
      splashColor: ZebrraColours.accent.withOpacity(ZebrraUI.OPACITY_SPLASH),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.black,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: const BorderRadius.all(
            Radius.circular(ZebrraUI.BORDER_RADIUS),
          ),
          border: useBorders ? Border.all(color: ZebrraColours.white10) : null,
        ),
        textStyle: const TextStyle(
          color: ZebrraColours.grey,
          fontSize: ZebrraUI.FONT_SIZE_SUBHEADER,
        ),
        preferBelow: true,
      ),
      unselectedWidgetColor: Colors.white,
      textTheme: _sharedTextTheme,
      textButtonTheme: _sharedTextButtonThemeData,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  SystemUiOverlayStyle get overlayStyle {
    return SystemUiOverlayStyle(
      systemNavigationBarColor: ZebrraSeaDatabase.THEME_AMOLED.read()
          ? Colors.black
          : ZebrraColours.secondary,
      systemNavigationBarDividerColor: ZebrraSeaDatabase.THEME_AMOLED.read()
          ? Colors.black
          : ZebrraColours.secondary,
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    );
  }

  TextTheme get _sharedTextTheme {
    const textStyle = TextStyle(color: Colors.white);
    return const TextTheme(
      displaySmall: textStyle,
      displayMedium: textStyle,
      displayLarge: textStyle,
      headlineSmall: textStyle,
      headlineMedium: textStyle,
      headlineLarge: textStyle,
      bodySmall: textStyle,
      bodyMedium: textStyle,
      bodyLarge: textStyle,
      titleSmall: textStyle,
      titleMedium: textStyle,
      titleLarge: textStyle,
      labelSmall: textStyle,
      labelMedium: textStyle,
      labelLarge: textStyle,
    );
  }

  TextButtonThemeData get _sharedTextButtonThemeData {
    return TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(
          ZebrraColours.accent.withOpacity(ZebrraUI.OPACITY_SPLASH),
        ),
      ),
    );
  }
}
