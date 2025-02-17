import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:profio/background.dart';
import 'package:profio/config/custom/custom_button.dart';
import 'package:profio/config/custom/custom_text_style.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:math' as math;

import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class ProfioPage extends StatefulWidget {
  const ProfioPage({super.key});

  @override
  State<ProfioPage> createState() => _ProfioPageState();
}

class _ProfioPageState extends State<ProfioPage> with SingleTickerProviderStateMixin {
  bool _isDarkMode = false;
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _positionAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _newIconRotationAnimation;
  late Animation<double> _newIconPositionAnimation;
  late Animation<double> _newIconOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Current icon animations
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
    ));

    _positionAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.5, curve: Curves.easeInOut),
    ));

    // New icon animations
    _newIconRotationAnimation = Tween<double>(
      begin: -math.pi,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
    ));

    _newIconPositionAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
    );

    _newIconOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.7, curve: Curves.easeInOut),
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isDarkMode = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleTheme() async {
    await _controller.forward();
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    if (_isDarkMode) {
      AdaptiveTheme.of(context).setDark();
    } else {
      AdaptiveTheme.of(context).setLight();
    }
    _controller.reset();
  }

  Widget _buildAnimatedIcon({
    required Animation<double> rotationAnimation,
    required Animation<double> positionAnimation,
    required Animation<double> opacityAnimation,
    required bool isCurrentIcon,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final responsive = ResponsiveBreakpoints.of(context);
        final isMobile = responsive.isMobile;
        final isTablet = responsive.isTablet;
        final iconSize = isMobile ? 24.0 : isTablet ? 32.0 : 48.0;
        final arcHeight = iconSize * 2;

        // Calculate position on the arc
        double progress = isCurrentIcon 
            ? positionAnimation.value 
            : 1 - positionAnimation.value;
        final double dx = progress * iconSize;
        final double dy = -math.sin(progress * math.pi) * arcHeight;

        return Opacity(
          opacity: opacityAnimation.value,
          child: Transform.translate(
            offset: Offset(dx, dy),
            child: Transform.rotate(
              angle: rotationAnimation.value,
              child: IconButton(
                icon: Image.asset(
                  isCurrentIcon 
                      ? (_isDarkMode ? 'assets/images/moon3.png' : 'assets/images/sun2.png')
                      : (_isDarkMode ? 'assets/images/sun2.png' : 'assets/images/moon3.png'),
                ),
                iconSize: iconSize,
                onPressed: _toggleTheme,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        actions: [
          SizedBox(
            width: 96,
            height: 96,
            child: Stack(
              children: [
                // Current icon animation
                _buildAnimatedIcon(
                  rotationAnimation: _rotationAnimation,
                  positionAnimation: _positionAnimation,
                  opacityAnimation: _opacityAnimation,
                  isCurrentIcon: true,
                ),
                // New icon animation
                _buildAnimatedIcon(
                  rotationAnimation: _newIconRotationAnimation,
                  positionAnimation: _newIconPositionAnimation,
                  opacityAnimation: _newIconOpacityAnimation,
                  isCurrentIcon: false,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  <Widget>[
            TextAnimator(
              'Welcome to my Profile Page',
              atRestEffect: WidgetRestingEffects.wave(),
              incomingEffect: WidgetTransitionEffects.incomingOffsetThenScale(),
              style: CustomTextStyle.headlineSuperBig(context),
            ),
            CustomButton(
              text: "TO OTHER PAGE",
              onpressed: () {
                Future.microtask(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AnimatedSkyScreen()),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}