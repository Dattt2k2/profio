import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profio/config/custom/custom_text_style.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class AnimatedSkyScreen extends StatefulWidget {
  const AnimatedSkyScreen({super.key});

  @override
  State<AnimatedSkyScreen> createState() => _AnimatedSkyScreenState();
}

class _AnimatedSkyScreenState extends State<AnimatedSkyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌤 Nền trời
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          // ☀️ Mặt trời di chuyển lên xuống
          Positioned(
            top: 100,
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: Image.asset(
              'assets/images/background_sun.png',
              width: 100,
              height: 100,
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
            .moveY(begin: -20, end: 20, duration: 5.seconds, curve: Curves.easeInOut),
          ),

          // ☁️ Mây trôi ngang
          Positioned(
            top: 150,
            left: -100,
            child: Image.asset(
              'assets/images/clould.png',
              width: 120,
              height: 80,
            ).animate(onPlay: (controller) => controller.repeat(reverse: false))
            .moveX(begin: -150, end: MediaQuery.of(context).size.width, duration: 10.seconds, curve: Curves.linear),
          ),

          // 🌥 Mây khác trôi chậm hơn
          Positioned(
            top: 200,
            left: -120,
            child: Image.asset(
              'assets/images/clould.png',
              width: 150,
              height: 100,
            ).animate(onPlay: (controller) => controller.repeat(reverse: false))
            .moveX(begin: -150, end: MediaQuery.of(context).size.width, duration: 15.seconds, curve: Curves.linear),
          ),

          // 📝 Văn bản với hiệu ứng
          Center(
            child: TextAnimator(
              'Chào mừng bạn!',
              atRestEffect: WidgetRestingEffects.pulse(),
              incomingEffect: WidgetTransitionEffects.incomingSlideInFromBottom(),
              style: CustomTextStyle.headlineBig(context),
            ),
          ),
        ],
      ),
    );
  }
}
