import 'package:flutter/material.dart';

class Gradients extends StatelessWidget {
  const Gradients({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(63, 81, 243, 0.5),
            Color.fromRGBO(63, 81, 243, 1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
