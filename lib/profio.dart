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

class _ProfioPageState extends State<ProfioPage> with TickerProviderStateMixin {
  bool _isDarkMode = false;
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _positionAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _newIconRotationAnimation;
  late Animation<double> _newIconPositionAnimation;
  late Animation<double> _newIconOpacityAnimation;
  
  // Controller for background clouds
  late AnimationController _backgroundController;
  
  // ScrollController để phát hiện và xử lý cuộn
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _profileSectionKey = GlobalKey();
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Initialize background controller
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat(reverse: true);

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
    _backgroundController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Cuộn xuống phần profile
  void _scrollToProfile() {
    if (_profileSectionKey.currentContext != null) {
      Scrollable.ensureVisible(
        _profileSectionKey.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
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
    // Lấy màu gradient dựa trên chế độ theme hiện tại
    final topColor = Theme.of(context).brightness == Brightness.light 
      ? const Color(0xFFAEDEF4) 
      : const Color(0xFF1A1A2E);
    final bottomColor = Theme.of(context).brightness == Brightness.light 
      ? const Color(0xFF93C6E7) 
      : const Color(0xFF0F0F1A);
    
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    return Scaffold(
      extendBodyBehindAppBar: true, // Cho phép body mở rộng ra phía sau AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // AppBar trong suốt
        elevation: 0, // Không có shadow
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                topColor,
                bottomColor,
              ],
            ),
          ),
        ),
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
      body: SkyBackgroundMixin(
        controller: _backgroundController,
        child: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Welcome section
                SizedBox(
                  width: screenSize.width,
                  height: screenSize.height - 100, // Chiều cao gần bằng màn hình
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TextAnimator(
                            'Welcome to my Profile Page',
                            atRestEffect: WidgetRestingEffects.wave(),
                            incomingEffect: WidgetTransitionEffects.incomingOffsetThenScale(),
                            style: isSmallScreen 
                              ? CustomTextStyle.headlineBig(context) 
                              : CustomTextStyle.headlineSuperBig(context),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),
                          CustomButton(
                            text: "VIEW PROFILE",
                            onpressed: _scrollToProfile,
                          ),
                          const SizedBox(height: 50),
                          GestureDetector(
                            onTap: _scrollToProfile,
                            child: Column(
                              children: [
                                const Text(
                                  "Scroll down to see more",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down, 
                                  size: 36,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Profile section - sẽ hiện khi cuộn xuống
                Container(
                  key: _profileSectionKey,
                  width: screenSize.width,
                  constraints: const BoxConstraints(maxWidth: 800),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white.withOpacity(0.85)
                        : Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: isSmallScreen ? 70 : 100,
                        backgroundImage: const AssetImage('assets/images/profile_photo.jpg'),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Your Name",
                        style: isSmallScreen
                            ? CustomTextStyle.headlineBig(context)
                            : CustomTextStyle.headlineSuperBig(context),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "App Developer",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Divider(),
                      _buildInfoSection(
                        context,
                        title: "About Me",
                        content: "I'm a passionate developer with experience in Flutter and mobile app development. "
                            "I love creating beautiful and functional applications that help people in their daily lives.",
                      ),
                      _buildInfoSection(
                        context,
                        title: "Skills",
                        content: "Flutter • Dart • UI/UX Design • Firebase • RESTful APIs",
                      ),
                      _buildInfoSection(
                        context,
                        title: "Experience",
                        content: "3+ years of experience in mobile app development with Flutter.",
                      ),
                      _buildInfoSection(
                        context,
                        title: "Education",
                        content: "Bachelor's Degree in Computer Science",
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                        text: "Contact Me",
                        onpressed: () {},
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                
                // Bottom padding
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, {required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.light
                  ? const Color(0xFF4A86E8)
                  : const Color(0xFF7BABF8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 10),
          const Divider(),
        ],
      ),
    );
  }
}