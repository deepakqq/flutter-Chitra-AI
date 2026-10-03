import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../core/config/asset_paths.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Get.offAllNamed(AppRoutes.home);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3D36C7),
              Color(0xFF241F88),
              Color(0xFF0A0828),
            ],
            stops: [0.0, 0.62, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(0, 0.04),
                child: Image.asset(
                  AssetPaths.splashImage,
                  width: size.width * 0.68,
                  fit: BoxFit.contain,
                ),
              ),
              Align(
                alignment: const Alignment(0, 0.72),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                    
                      'Intelligence meets Imagination.',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white.withOpacity(0.95),
                        fontWeight: FontWeight.w500,
                        fontSize: 16
                        // letterSpacing: ,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _FramedEqualizerBars(controller: _controller),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FramedEqualizerBars extends StatelessWidget {
  const _FramedEqualizerBars({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFFB34BFF),
      const Color(0xFF7E5BFF),
      const Color(0xFF5E8CFF),
      const Color(0xFFFF4CB0),
      const Color(0xFFFF6B8F),
      const Color(0xFFFF8A5C),
      const Color(0xFFFFB84D),
    ];
    const totalBars = 18;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFFB469FF), width: 1.6),
            gradient: const LinearGradient(
              colors: [Color(0xFF2C185E), Color(0xFF24134E)],
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(totalBars, (i) {
              final t = (controller.value + (i * 0.05)) % 1.0;
              final wave = (t > 0.5 ? 1 - t : t) * 2;
              final height = 8.0 + (wave * 8.5);
              return Container(
                width: 3,
                height: height,
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.5),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      colors[i % colors.length],
                      colors[(i + 2) % colors.length],
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
