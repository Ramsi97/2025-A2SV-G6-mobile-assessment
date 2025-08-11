import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyStatus extends StatelessWidget {
  const MyStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          // Stack allows overlapping widgets
          Stack(
            alignment: Alignment.center,
            children: [
              // Story circle with gradient border
              Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromRGBO(245, 245, 245, 1),
                      Color.fromRGBO(245, 245, 245, 1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: ClipOval(
                    child: Image.file(
                      File('assets/images/2.png'),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.person, size: 30),
                      ),
                    ),
                  ),
                ),
              ),
              // Plus icon positioned at bottom right
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(245, 245, 245, 1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color.fromRGBO(137, 137, 137, 1),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 15,
                    color: Color.fromRGBO(137, 137, 137, 1),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Name
          Text(
            'My Status',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
