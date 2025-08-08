import 'package:flutter/material.dart';

class EcomLogo extends StatelessWidget {
  final double containerWidth;
  final double containerHeight;
  final double textFontsize;

  const EcomLogo({
    super.key,
    required this.containerWidth,
    required this.containerHeight,
    required this.textFontsize,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: containerWidth,
        height: containerHeight,
        child: Center(
          child: Text(
            'Ecom',
            style: TextStyle(
              fontFamily: 'Caveat Brush',
              color: Color.fromRGBO(63, 81, 243, 1),
              fontWeight: FontWeight.w400,
              fontSize: textFontsize,
            ),
          ),
        ),
      ),
    );
  }
}
