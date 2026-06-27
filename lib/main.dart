import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/cache/hive_cache_service.dart';
import 'core/config/app_env.dart';
import 'core/firebase/firebase_service.dart';
import 'core/router/app_router.dart';
import 'core/services/fcm_service.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive local cache
  await HiveCacheService.init();

  // Firebase (only when USE_FIREBASE=true is passed via --dart-define)
  if (AppEnv.useFirebase) {
    await FirebaseService.initialize();
    await FcmService.initialize();
    // In debug, let Firebase phone-auth *test numbers* work on the iOS Simulator
    // / Android emulator without real SMS, APNs, or reCAPTCHA.
    if (kDebugMode) {
      await FirebaseAuth.instance
          .setSettings(appVerificationDisabledForTesting: true);
    }
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const ProviderScope(child: Jo3tApp()));
}

class Jo3tApp extends ConsumerWidget {
  const Jo3tApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'JO3T',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
