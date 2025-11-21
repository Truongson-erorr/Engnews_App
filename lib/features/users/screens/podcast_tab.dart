import 'package:flutter/material.dart';
import '../../viewmodel/podcastViewModel.dart';
import '../../models/podcast_model.dart';

class PodcastTab extends StatelessWidget {
  final PodcastViewModel viewModel = PodcastViewModel();
  PodcastTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: Colors.white,
      body: FutureBuilder<List<PodcastModel>>(
        future: viewModel.fetchPodcasts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          final podcasts = snapshot.data ?? [];

          if (podcasts.isEmpty) {
            return const Center(child: Text('Chưa có podcast nào.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: podcasts.length,
            itemBuilder: (_, index) {
              final podcast = podcasts[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Image.network(podcast.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                  title: Text(podcast.title),
                  subtitle: Text(podcast.duration),
                  trailing: IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () {
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
