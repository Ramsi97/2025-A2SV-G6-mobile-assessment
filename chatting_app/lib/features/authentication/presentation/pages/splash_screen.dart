import 'package:chatting_app/features/authentication/presentation/widgets/ecom_logo.dart';
import 'package:chatting_app/features/authentication/presentation/widgets/gradient.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash_image.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(child: Gradients()),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EcomLogo(
                  containerWidth: 264,
                  containerHeight: 121,
                  textFontsize: 98,
                  boxRadius: 32,
                ),
                SizedBox(height: 20),
                Text(
                  'Ecommerce APP',
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
