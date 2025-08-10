import 'package:chatting_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:chatting_app/features/authentication/presentation/pages/home_page.dart';
import 'package:chatting_app/features/authentication/presentation/pages/log_in.dart';
import 'package:chatting_app/features/authentication/presentation/pages/sign_up.dart';

import 'package:chatting_app/features/authentication/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => di.sl<AuthBloc>(),
        child: const AuthWrapper(),
      ),
      routes: {
        // '/': (context) => const AuthWrapper(),
        '/login': (context) =>
            BlocProvider(create: (_) => di.sl<AuthBloc>(), child: LogIn()),
        '/signup': (context) =>
            BlocProvider(create: (_) => di.sl<AuthBloc>(), child: SignUp()),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return const SplashScreen();
        } else if (state is AuthLoading) {
          return const LogIn();
        } else if (state is Authenticated) {
          return const HomePage();
        } else {
          // For Unauthenticated and AuthError, show LoginPage
          // and let it handle the error display
          return const LogIn();
        }
      },
    );
  }
}
