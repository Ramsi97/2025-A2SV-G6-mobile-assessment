import 'package:chatting_app/features/authentication/presentation/widgets/ecom_logo.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('images/splash_image.png', fit: BoxFit.cover),
          ),
          Center(
            child: EcomLogo(
              containerWidth: 264,
              containerHeight: 121,
              textFontsize: 112.89,
            ),
          ),
        ],
      ),
    );
  }
}
