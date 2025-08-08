import 'package:flutter/material.dart';

class Gradient extends StatelessWidget {
  const Gradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(63, 81, 243, 1),
              Color.fromRGBO(63, 81, 243, 0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }
}
