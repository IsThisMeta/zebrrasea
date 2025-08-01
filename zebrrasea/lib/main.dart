import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:device_preview/device_preview.dart';
import 'package:zebrrasea/core.dart';
import 'package:zebrrasea/database/database.dart';
import 'package:zebrrasea/router/router.dart';
import 'package:zebrrasea/system/cache/image/image_cache.dart';
import 'package:zebrrasea/system/cache/memory/memory_store.dart';
import 'package:zebrrasea/system/network/network.dart';
import 'package:zebrrasea/system/recovery_mode/main.dart';
import 'package:zebrrasea/system/window_manager/window_manager.dart';
import 'package:zebrrasea/system/platform.dart';

/// ZebrraSea Entry Point: Bootstrap & Run Application
///
/// Runs app in guarded zone to attempt to capture fatal (crashing) errors
Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      try {
        await bootstrap();
        runApp(const ZebrraBIOS());
      } catch (error) {
        runApp(const ZebrraRecoveryMode());
      }
    },
    (error, stack) => ZebrraLogger().critical(error, stack),
  );
}

/// Bootstrap the core
///
Future<void> bootstrap() async {
  await ZebrraDatabase().initialize();
  ZebrraLogger().initialize();
  ZebrraTheme().initialize();
  if (ZebrraWindowManager.isSupported) await ZebrraWindowManager().initialize();
  if (ZebrraNetwork.isSupported) ZebrraNetwork().initialize();
  if (ZebrraImageCache.isSupported) ZebrraImageCache().initialize();
  ZebrraRouter().initialize();
  await ZebrraMemoryStore().initialize();
}

class ZebrraBIOS extends StatelessWidget {
  const ZebrraBIOS({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ZebrraTheme();
    final router = ZebrraRouter.router;

    return ZebrraState.providers(
      child: DevicePreview(
        enabled: kDebugMode && ZebrraPlatform.isDesktop,
        builder: (context) => EasyLocalization(
          supportedLocales: [Locale('en')],
          path: 'assets/localization',
          fallbackLocale: Locale('en'),
          startLocale: Locale('en'),
          useFallbackTranslations: true,
          child: ZebrraBox.zebrrasea.listenableBuilder(
            selectItems: [
              ZebrraSeaDatabase.THEME_AMOLED,
              ZebrraSeaDatabase.THEME_AMOLED_BORDER,
            ],
            builder: (context, _) {
              return MaterialApp.router(
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                builder: DevicePreview.appBuilder,
                darkTheme: theme.activeTheme(),
                theme: theme.activeTheme(),
                title: 'ZebrraSea',
                routeInformationProvider: router.routeInformationProvider,
                routeInformationParser: router.routeInformationParser,
                routerDelegate: router.routerDelegate,
              );
            },
          ),
        ),
      ),
    );
  }
}
