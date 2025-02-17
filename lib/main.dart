import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';


import 'package:profio/config/theme/theme.dart';
import 'package:profio/profio.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: buildThemeData(context: context),
      dark: buildThemeData(context: context, isDarkTheme: true),
      initial: AdaptiveThemeMode.light,
      builder: (light, dark) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: light,
        darkTheme: dark,
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child ?? const SizedBox(),
          breakpoints: const [
            Breakpoint(start: 0, end: 480, name: MOBILE),
            Breakpoint(start: 481, end: 768, name: TABLET),
            Breakpoint(start: 769, end: double.infinity, name: DESKTOP),
          ],
        ),
        home: const ProfioPage(),
      ),
    );
  }
}

