import 'package:chatting_app/features/chatting/presentation/widgets/my_status.dart';
import 'package:chatting_app/features/chatting/presentation/widgets/story.dart';
import 'package:flutter/material.dart';

class Stories extends StatefulWidget {
  const Stories({super.key});

  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Icon(Icons.search, color: Colors.white, size: 25),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  MyStatus(),
                  Story(
                    imagefile: 'assets/images/1.png',
                    name: 'Adil',
                    color1: Color.fromRGBO(209, 150, 12, 1),
                    color2: Color.fromRGBO(209, 150, 12, 1),
                  ),
                  Story(
                    imagefile: 'assets/images/2.png',
                    name: 'Marina',
                    color1: Color.fromRGBO(245, 183, 190, 1),
                    color2: Color.fromRGBO(245, 183, 190, 1),
                  ),
                  Story(
                    imagefile: 'assets/images/3.png',
                    name: 'Dean',
                    color1: Color.fromRGBO(200, 236, 253, 1),
                    color2: Color.fromRGBO(200, 236, 253, 1),
                  ),
                  Story(
                    imagefile: 'assets/images/4.png',
                    name: 'Max',
                    color1: Color.fromRGBO(200, 236, 253, 1),
                    color2: Color.fromRGBO(200, 236, 253, 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
