import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/article_model.dart';
import 'article_viewmodel.dart';

class NotificationViewModel extends ChangeNotifier {
  final ArticleViewModel _articleVM = ArticleViewModel();
  final FlutterTts _flutterTts = FlutterTts();

  bool _isReading = false;
  bool _isPaused = false;
  String _lastText = "";

  bool get isReading => _isReading;
  bool get isPaused => _isPaused;

  NotificationViewModel() {
    _initTts();
  }

  void _initTts() async {
    await _flutterTts.setLanguage("vi-VN");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    if (defaultTargetPlatform == TargetPlatform.android) {
      await _flutterTts.setEngine("com.google.android.tts"); 
      await _flutterTts.awaitSpeakCompletion(true); 
    }

    _flutterTts.setCompletionHandler(() {
      _isReading = false;
      _isPaused = false; 
      _lastText = "";
      notifyListeners();
    });

    _flutterTts.setErrorHandler((msg) {
      print("TTS ERROR: $msg"); 
      _isReading = false; 
      _isPaused = false; 
      _lastText = ""; 
      notifyListeners();
    });
  }

  // Stream today's articles
  Stream<List<ArticleModel>> todayArticlesStream() {
    return _articleVM.listenArticlesFromToday();
  }

  // Fetch articles before today
  Future<List<ArticleModel>> previousArticles() async {
    final all = await _articleVM.fetchArticles();
    final todayStart =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return all.where((a) => a.date.isBefore(todayStart)).toList();
  }

  // Start reading or resume if paused
  Future<void> readArticle(ArticleModel article) async {
    final text = "${article.title}. ${article.content}".trim();
    if (text.isEmpty) return;

    if (_isPaused && _lastText == text) {
      await resumeReading(); 
      return;
    }

    _lastText = text; 
    _isReading = true; 
    _isPaused = false; 
    notifyListeners();

    await _flutterTts.speak(text); 
  }

  Future<void> pauseReading() async {
    try {
      await _flutterTts.stop();
    } catch (_) {}
    _isPaused = true; 
    _isReading = true; 
    notifyListeners();
  }

  Future<void> resumeReading() async {
    if (_lastText.isEmpty) return;

    _isPaused = false; 
    _isReading = true; 
    notifyListeners();

    await _flutterTts.speak(_lastText); 
  }

  Future<void> stopReading() async {
    try {
      await _flutterTts.stop(); 
    } catch (_) {}
    _isReading = false; 
    _isPaused = false; 
    _lastText = ""; 
    notifyListeners();
  }

  @override
  void dispose() {
    _flutterTts.stop(); 
    super.dispose();
  }
}
