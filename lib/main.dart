/// FluttnBoil - Flutter SaaS Boilerplate
///
/// A comprehensive Flutter starter template with authentication,
/// subscription management, RBAC, and clean architecture.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_config.dart';
import 'core/config/environment.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment configuration
  EnvironmentConfig.instance.initialize(AppConfig.environment);

  runApp(
    const ProviderScope(
      child: FluttnBoilApp(),
    ),
  );
}

/// Main application widget
class FluttnBoilApp extends ConsumerWidget {
  const FluttnBoilApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Router
      routerConfig: router,
    );
  }
}
