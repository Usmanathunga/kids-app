import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../features/navigation/main_navigation_screen.dart';

class ChildActivityApp extends StatelessWidget {
  const ChildActivityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KidSteps',
      theme: AppTheme.theme,
      home: const MainNavigationScreen(),
    );
  }
}
