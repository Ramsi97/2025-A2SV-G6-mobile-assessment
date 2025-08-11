import 'package:chatting_app/features/chatting/presentation/widgets/chat_list_page.dart';
import 'package:chatting_app/features/chatting/presentation/widgets/stories.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Stories(),

          // Add the draggable chat list sheet on top
          DraggableScrollableSheet(
            initialChildSize: 0.7, // start height (40% of screen)
            minChildSize: 0.1, // min height
            maxChildSize: 0.9, // max height
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Small grab handle bar
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Expanded(
                      child: ChatListPage(
                        scrollController: scrollController,
                        isInsideSheet: true, // Add this flag
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
