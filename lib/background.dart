import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Màn hình hiển thị background bầu trời động
class AnimatedSkyScreen extends StatefulWidget {
  const AnimatedSkyScreen({super.key});

  @override
  State<AnimatedSkyScreen> createState() => _AnimatedSkyScreenState();
}

class _AnimatedSkyScreenState extends State<AnimatedSkyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Sky'),
      ),
      body: SkyBackgroundMixin(
        controller: _controller,
        child: const Center(
          child: Text(
            'Animated Sky Background',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  offset: Offset(1, 1),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget để hiển thị nền bầu trời với đám mây chuyển động nhẹ
class SkyBackgroundMixin extends StatelessWidget {
  final Widget child;
  final AnimationController controller;

  const SkyBackgroundMixin({
    super.key,
    required this.child,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background gradient
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
        
        // Animated clouds and celestial body
        AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final size = MediaQuery.of(context).size;
            final isDarkMode = Theme.of(context).brightness == Brightness.dark;
            final isSmallScreen = size.width < 600; // Kiểm tra nếu màn hình nhỏ (điện thoại)
            
            // Điều chỉnh kích thước đám mây dựa trên kích thước màn hình
            final cloudSizeMultiplier = isSmallScreen ? 0.7 : 1.0;
            
            return Stack(
              children: [
                // Sun/Moon (based on theme) - now centered
                Positioned(
                  top: size.height * 0.15, // Điều chỉnh độ cao
                  // Căn giữa theo chiều ngang với độ lệch nhẹ
                  left: size.width / 2 - (isSmallScreen ? 40 : 60) + 15 * math.sin(controller.value * math.pi * 0.5),
                  child: Image.asset(
                    isDarkMode ? 'assets/images/moon3.png' : 'assets/images/sun2.png',
                    width: (isDarkMode ? 120.0 : 140.0) * (isSmallScreen ? 0.8 : 1.0),
                    height: (isDarkMode ? 120.0 : 140.0) * (isSmallScreen ? 0.8 : 1.0),
                  ),
                ),
                
                // Cloud 1 - top left
                if (isSmallScreen ? true : true) // Luôn hiển thị đám mây này
                Positioned(
                  top: size.height * 0.05,
                  left: size.width * 0.08 + 30 * math.sin(controller.value * math.pi),
                  child: _buildCloudImage(context, 'assets/images/cloud1.png', 180 * cloudSizeMultiplier),
                ),
                
                // Cloud 2 - top right
                if (isSmallScreen ? true : true) // Luôn hiển thị đám mây này
                Positioned(
                  top: size.height * 0.28,
                  right: size.width * 0.08 + 40 * math.cos(controller.value * math.pi),
                  child: _buildCloudImage(context, 'assets/images/cloud1.png', 200 * cloudSizeMultiplier),
                ),
                
                // Cloud 3 - mid left
                if (isSmallScreen ? size.width > 350 : true) // Chỉ hiển thị trên màn hình đủ lớn
                Positioned(
                  top: size.height * 0.4,
                  left: size.width * 0.3 + 25 * math.sin(controller.value * math.pi * 1.5),
                  child: _buildCloudImage(context, 'assets/images/cloud1.png', 250 * cloudSizeMultiplier),
                ),
                
                // Cloud 4 - bottom right
                if (isSmallScreen ? true : true) // Luôn hiển thị đám mây này
                Positioned(
                  top: size.height * (isSmallScreen ? 0.6 : 0.65), // Điều chỉnh vị trí trên điện thoại
                  right: size.width * 0.2 + 35 * math.cos(controller.value * math.pi * 0.8),
                  child: _buildCloudImage(context, 'assets/images/cloud1.png', 160 * cloudSizeMultiplier),
                ),
                
                // Additional cloud - mid left
                if (isSmallScreen ? size.width > 400 : true) // Chỉ hiển thị trên màn hình đủ lớn
                Positioned(
                  top: size.height * (isSmallScreen ? 0.5 : 0.45), // Điều chỉnh vị trí trên điện thoại
                  left: -size.width * 0.05 + 20 * math.sin(controller.value * math.pi * 0.6),
                  child: _buildCloudImage(context, 'assets/images/cloud1.png', 140 * cloudSizeMultiplier),
                ),
                
                // Additional cloud - bottom right
                if (isSmallScreen ? size.width > 380 : true) // Chỉ hiển thị trên màn hình đủ lớn
                Positioned(
                  top: size.height * (isSmallScreen ? 0.8 : 0.75), // Điều chỉnh vị trí trên điện thoại
                  right: size.width * (isSmallScreen ? 0.25 : 0.35) + 30 * math.cos(controller.value * math.pi * 1.2),
                  child: _buildCloudImage(context, 'assets/images/cloud1.png', 220 * cloudSizeMultiplier),
                ),
              ],
            );
          },
        ),
        
        // Content - đảm bảo nội dung nằm chính giữa và đáp ứng
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: child,
          ),
        ),
      ],
    );
  }
  
  Widget _buildCloudImage(BuildContext context, String imagePath, double size) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Tăng chiều cao tương đối để đám mây có tỷ lệ tốt hơn
    return Opacity(
      opacity: isDarkMode ? 0.15 : 0.7,
      child: Image.asset(
        imagePath,
        width: size,
        height: size * 0.7, // Tăng tỷ lệ chiều cao
        fit: BoxFit.contain,
      ),
    );
  }
}
