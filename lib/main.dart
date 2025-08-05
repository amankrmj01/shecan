import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/di/dependency_injection.dart';
import 'core/router/app_router.dart';
import 'core/services/theme_service.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init();

  runApp(const InternDashboardApp());
}

class InternDashboardApp extends StatelessWidget {
  const InternDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeService>(
      create: (_) => sl<ThemeService>(),
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp.router(
            title: 'Intern Dashboard',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeService.themeMode == AppThemeMode.light
                ? ThemeMode.light
                : themeService.themeMode == AppThemeMode.dark
                ? ThemeMode.dark
                : ThemeMode.system,
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
