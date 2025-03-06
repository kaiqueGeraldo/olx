import 'package:flutter/material.dart';
import 'package:olx/src/controllers/splash_screen_controller.dart';
import 'package:olx/src/utils/colors.dart';
import 'package:provider/provider.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<SplashScreenController>(context, listen: false)
            .startAnimation(context));
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SplashScreenController>(context);

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              opacity: controller.opacities[index],
              child: Transform.translate(
                offset: index == 1 ? const Offset(0, -10) : Offset.zero,
                child: Text(
                  "OLX"[index],
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: [
                      const Color(0xFFF1F1F1), // O - Branco
                      const Color(0xFF2ABF2F), // L - Verde (elevado)
                      const Color(0xFFF55F15) // X - Laranja
                    ][index],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
