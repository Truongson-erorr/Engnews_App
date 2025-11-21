import 'package:translator/translator.dart';
import '../models/article_model.dart';

class TranslateViewModel {
  // Cache to store already translated texts to avoid repeated API calls
  final Map<String, String> _cache = {};

  /// Translate a single piece of text from English to Vietnamese
  Future<String> translateText(String text) async {
    if (text.isEmpty) return "";
    if (_cache.containsKey(text)) return _cache[text]!; 

    final translator = GoogleTranslator(); 
    try {
      final translated = await translator.translate(text, to: 'vi');
      _cache[text] = translated.text;
      return translated.text;
    } catch (e) {
      print('Translation error: $e'); 
      return "Lỗi dịch bài viết.";
    }
  }

  /// Split article content into paragraphs and translate each paragraph
  Future<List<Map<String, String>>> translateParagraphs(String content) async {
    final paragraphs = content.split('\n').where((e) => e.trim().isNotEmpty).toList();
    final results = <Map<String, String>>[];

    for (var p in paragraphs) {
      final translated = await translateText(p); 
      results.add({'en': p, 'vi': translated}); 
    }
    return results; 
  }
}
