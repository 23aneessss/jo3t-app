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
