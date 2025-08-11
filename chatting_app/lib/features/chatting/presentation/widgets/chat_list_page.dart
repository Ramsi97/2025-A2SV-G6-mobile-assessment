import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatListPage extends StatelessWidget {
  final ScrollController scrollController;
  final bool isInsideSheet;

  const ChatListPage({
    super.key,
    required this.scrollController,
    this.isInsideSheet = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController, // Crucial connection
      physics: isInsideSheet
          ? const ClampingScrollPhysics() // For sheet dragging
          : const BouncingScrollPhysics(), // Regular behavior
      padding: const EdgeInsets.only(top: 8),
      children: const [
        _ChatItem(
          name: 'Alex Linderson',
          time: '2min ago',
          message: 'How are you looking?',
          imagefile: 'assets/images/1.png',
        ),
        _ChatItem(
          name: 'Angel Dayna',
          time: '2min ago',
          message: 'Don\'t miss a cardboard for meeting.',
          imagefile: 'assets/images/2.png',
        ),
        _ChatItem(
          name: 'John Abraham',
          time: '2min ago',
          message: 'Hey, Come you join me meeting?',
          imagefile: 'assets/images/3.png',
        ),
        _ChatItem(
          name: 'Sasha Sayma',
          time: '2min ago',
          message: 'How will you look at?',
          imagefile: 'assets/images/3.png',
        ),
        _ChatItem(
          name: 'John Borino',
          time: '2min ago',
          message: 'How to go on day.',
          imagefile: 'assets/images/2.png',
        ),
      ],
    );
  }
}

class _ChatItem extends StatelessWidget {
  final String name;
  final String time;
  final String message;
  final String imagefile;
  const _ChatItem({
    required this.name,
    required this.time,
    required this.message,
    required this.imagefile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: FileImage(File(imagefile)),
          ),
          title: Row(
            children: [
              Text(
                name,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Text(time, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          subtitle: Text(
            message,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Color.fromRGBO(121, 124, 123, 1),
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/message');
          },
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
