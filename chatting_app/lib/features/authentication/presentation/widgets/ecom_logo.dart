import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EcomLogo extends StatelessWidget {
  final double containerWidth;
  final double containerHeight;
  final double textFontsize;
  final double boxRadius;

  const EcomLogo({
    super.key,
    required this.containerWidth,
    required this.containerHeight,
    required this.textFontsize,
    required this.boxRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerWidth,
      height: containerHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(boxRadius)),
        color: Colors.white,
      ),
      child: Center(
        child: Text(
          'ECOM',
          style: GoogleFonts.caveatBrush(
            fontSize: textFontsize,
            color: Color.fromRGBO(63, 81, 243, 1),
          ),
        ),
      ),
    );
  }
}
