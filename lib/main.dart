import 'package:flutter/material.dart';

import 'package:stravo/app/presentation/main_navigation_shell.dart';
import 'package:stravo/app/theme/app_theme.dart';

void main() {
  runApp(const StravoApp());
}

class StravoApp extends StatelessWidget {
  const StravoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stravo Pro',
      debugShowCheckedModeBanner: false,
      theme: StravoAppTheme.darkTheme,
      home: const MainNavigationShell(),
    );
  }
}

