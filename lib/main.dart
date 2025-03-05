import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'dart:math' as math;

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
          child: BackgroundWrapper(child: child ?? const SizedBox()),
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

class BackgroundWrapper extends StatefulWidget {
  final Widget child;
  
  const BackgroundWrapper({super.key, required this.child});

  @override
  State<BackgroundWrapper> createState() => _BackgroundWrapperState();
}

class _BackgroundWrapperState extends State<BackgroundWrapper> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 3),
    )..repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background color
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).brightness == Brightness.light 
                    ? const Color(0xFFAEDEF4) 
                    : const Color(0xFF1A1A2E),
                Theme.of(context).brightness == Brightness.light 
                    ? const Color(0xFF93C6E7) 
                    : const Color(0xFF0F0F1A),
              ],
            ),
          ),
        ),
        
        // Clouds
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              children: [
                // Cloud 1
                Positioned(
                  top: 50,
                  left: 30 + 20 * math.sin(_controller.value * math.pi),
                  child: _buildCloud(80),
                ),
                
                // Cloud 2
                Positioned(
                  top: 120,
                  right: 50 + 25 * math.cos(_controller.value * math.pi),
                  child: _buildCloud(100),
                ),
                
                // Cloud 3
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.3,
                  left: 80 + 15 * math.sin(_controller.value * math.pi * 1.5),
                  child: _buildCloud(60),
                ),
              ],
            );
          },
        ),
        
        // Content
        widget.child,
      ],
    );
  }
  
  Widget _buildCloud(double size) {
    return Opacity(
      opacity: Theme.of(context).brightness == Brightness.light ? 0.7 : 0.2,
      child: Container(
        width: size,
        height: size * 0.6,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size * 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}

