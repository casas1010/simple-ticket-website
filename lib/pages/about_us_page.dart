import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final List<Map<String, dynamic>> _users = [
    {
      "name": "Juan Casas",
      "position": "Lead",
      "images": ['https://i.imgur.com/konOPMO.png'],
      "description": "Operations guru and organizer.",
    },
    // {
    //   "name": "John Calderario",
    //   "position": "CEO",
    //   "images": ['https://i.imgur.com/RI4B4ja.png'],
    //   "description": "Visionary leader and strategist.",
    // },
    // {
    //   "name": "James Moise",
    //   "position": "CTO",
    //   "images": ['https://i.imgur.com/TIh5kU5.png'],
    //   "description": "Tech enthusiast and innovator.",
    // },
    // {
    //   "name": "Connor McCarthy",
    //   "position": "COO",
    //   "images": ['https://i.imgur.com/WvlgWpL.png'],
    //   "description": "Tech enthusiast and innovator.",
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _users.map((user) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(user['images'][0]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user['position'],
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  // SizedBox(
                  //   width: 100,
                  //   child: Text(
                  //     user['description'],
                  //     textAlign: TextAlign.center,
                  //     style: const TextStyle(fontSize: 12),
                  //   ),
                  // ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
