import 'package:flutter/material.dart';
import 'common/utils/app_colors.dart';
import 'core/themes/app_theme.dart';
import 'routes/app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skincare Safety',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      color: AppColors.primary,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
