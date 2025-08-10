import 'package:chatting_app/features/authentication/presentation/widgets/ecom_logo.dart';
import 'package:chatting_app/features/authentication/presentation/widgets/gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/auth_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      context.read<AuthBloc>().add(AuthCheckedRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Your existing splash screen UI
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
                const SizedBox(height: 20),
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
