import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiViewModel {
  final apiKey = dotenv.env['GEMINI_API_KEY'] ?? "";
  
  Future<String> summarizeContent(String text, String language) async {
    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey",
    );

    final prompt = """
    Hãy tóm tắt đoạn văn sau bằng $language, ngắn gọn, mạch lạc, dễ hiểu:

    $text
    """;

    // Build the JSON request body for the Gemini API
    final body = {
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    };

    // Send HTTP POST request to Gemini API
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    // Handle API error responses
    if (response.statusCode != 200) {
      print("API Error: ${response.body}");
      throw Exception("Lỗi gọi Gemini API");
    }

    final data = jsonDecode(response.body);

    // Parse text result safely and catch unexpected format
    try {
      return data["candidates"][0]["content"]["parts"][0]["text"];
    } catch (e) {
      print("Parse Error: $e");
      print("Response: ${response.body}");
      throw Exception("Lỗi phân tích dữ liệu trả về");
    }
  }
}
