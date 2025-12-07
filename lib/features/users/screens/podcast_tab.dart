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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: podcasts.length,
        itemBuilder: (context, index) {
          final podcast = podcasts[index];

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.25)
                      : Colors.black.withOpacity(0.05),
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
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                podcast.duration,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),

              trailing: IconButton(
                icon: Icon(
                  Icons.play_circle_fill,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đang phát: ${podcast.title}'),
                      backgroundColor: theme.colorScheme.primary,
                    ),
                  );
                },
              ),

              splashColor: theme.colorScheme.primary.withOpacity(0.25),
            ),
          );
        },
      ),
    );
  }
}
