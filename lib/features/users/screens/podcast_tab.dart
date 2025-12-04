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
    PodcastModel(
      title: 'Networking & APIs',
      imageUrl: 'https://picsum.photos/100/100?random=5',
      duration: '35:20',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C1A1F),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: podcasts.length,
        itemBuilder: (context, index) {
          final podcast = podcasts[index];
          return Card(
            color: const Color(0xFF3B1322), 
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
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
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                podcast.duration,
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.play_arrow, color: Color(0xFFD0021B)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đang phát: ${podcast.title}')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
