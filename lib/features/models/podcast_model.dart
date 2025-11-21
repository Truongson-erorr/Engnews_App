import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing a Podcast
class PodcastModel {
  final String title;
  final String imageUrl;
  final String duration;
  final String audioUrl;

  PodcastModel({
    required this.title,
    required this.imageUrl,
    required this.duration,
    required this.audioUrl,
  });

  /// Create PodcastModel from JSON data
  factory PodcastModel.fromJson(Map<String, dynamic> json) {
    return PodcastModel(
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      duration: json['duration'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
    );
  }
}
