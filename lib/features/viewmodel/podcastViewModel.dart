import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/podcast_model.dart';

/// ViewModel for fetching Podcasts from API
class PodcastViewModel {
  /// API endpoint URL
  final String apiUrl = "";

  /// Fetch list of podcasts from the API
  Future<List<PodcastModel>> fetchPodcasts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => PodcastModel.fromJson(e)).toList();
      } else {
        throw Exception("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching podcasts: $e");
      return [];
    }
  }
}
