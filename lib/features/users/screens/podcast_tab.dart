import 'package:flutter/material.dart';

class PodcastModel {
  final String title;
  final String imageUrl;
  final String duration;

  PodcastModel({
    required this.title,
    required this.imageUrl,
    required this.duration,
  });
}

class PodcastTab extends StatelessWidget {
  PodcastTab({Key? key}) : super(key: key);

  final List<PodcastModel> podcasts = [
    PodcastModel(
      title: 'Flutter Basics',
      imageUrl: 'https://picsum.photos/100/100?random=1',
      duration: '25:30',
    ),
    PodcastModel(
      title: 'State Management in Flutter',
      imageUrl: 'https://picsum.photos/100/100?random=2',
      duration: '32:10',
    ),
    PodcastModel(
      title: 'Building Responsive UI',
      imageUrl: 'https://picsum.photos/100/100?random=3',
      duration: '28:45',
    ),
    PodcastModel(
      title: 'Animations & Transitions',
      imageUrl: 'https://picsum.photos/100/100?random=4',
      duration: '40:05',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: podcasts.length,
        itemBuilder: (context, index) {
          final podcast = podcasts[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color.fromARGB(33, 255, 255, 255),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  offset: const Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(14),

              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  podcast.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),

              title: Text(
                podcast.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                podcast.duration,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                ),
              ),

              trailing: IconButton(
                icon: const Icon(
                  Icons.play_circle_fill,
                  size: 32,
                  color: Color(0xFFD0021B),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đang phát: ${podcast.title}'),
                    ),
                  );
                },
              ),
              splashColor: const Color(0x33D0021B),
            ),
          );
        },
      ),
    );
  }
}
