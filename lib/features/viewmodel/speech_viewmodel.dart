import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SpeechViewModel extends ChangeNotifier {
  final FlutterTts _tts = FlutterTts();

  bool _isReading = false;
  bool _isPaused = false;
  String _lastText = "";

  bool get isReading => _isReading;
  bool get isPaused => _isPaused;

  SpeechViewModel() {
    _initTts();
  }

  void _initTts() async {
    // Ngôn ngữ tự nhiên, không đánh vần
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.55); // tốc độ tự nhiên hơn
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    // Android fix: bật Google TTS nếu có
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _tts.setEngine("com.google.android.tts");
      await _tts.awaitSpeakCompletion(true);
    }

    _tts.setCompletionHandler(() {
      _isReading = false;
      _isPaused = false;
      notifyListeners();
    });

    _tts.setErrorHandler((msg) {
      print("TTS ERROR: $msg");
      _isReading = false;
      _isPaused = false;
      notifyListeners();
    });
  }

  // CLEAN TEXT chống đọc từng chữ
  String _cleanText(String text) {
    return text
        .replaceAll("\n", " ")          // bỏ xuống dòng
        .replaceAll(RegExp(r'[^\x00-\x7F]'), "") // bỏ ký tự lạ
        .replaceAll(RegExp(r'\s+'), " ") // gọn khoảng trắng
        .trim();
  }

  Future<void> startReading(String text) async {
    final t = _cleanText(text);
    if (t.isEmpty) return;

    _lastText = t;
    _isReading = true;
    _isPaused = false;
    notifyListeners();

    await _tts.speak(t);
  }

  Future<void> pauseReading() async {
    try {
      await _tts.stop();
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

    // Không resume từ vị trí cũ được → đọc lại full text
    await _tts.speak(_lastText);
  }

  Future<void> stopReading() async {
    try {
      await _tts.stop();
    } catch (_) {}

    _isReading = false;
    _isPaused = false;
    _lastText = "";
    notifyListeners();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }
}
