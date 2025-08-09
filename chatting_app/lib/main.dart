import 'package:chatting_app/features/authentication/presentation/pages/log_in.dart';
import 'package:chatting_app/features/authentication/presentation/pages/sign_up.dart';
import 'package:chatting_app/features/authentication/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: const LogIn());
  }
}
