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
    _tts.setLanguage("en-US");
    _tts.setSpeechRate(0.45);
    _tts.setVolume(1.0);
    _tts.setPitch(1.0);

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
      print("TTS ERROR: $msg"); // in ra lỗi nếu có
      _isReading = false;
      _isPaused = false;
      notifyListeners();
    });
  }

  Future<void> startReading(String text) async {
    final t = text.trim();
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
    } catch (_) {
    }
    _isPaused = true;
    _isReading = true;
    notifyListeners();
  }

  Future<void> resumeReading() async {
    final t = _lastText.trim();
    if (t.isEmpty) return;

    _isPaused = false;
    _isReading = true;
    notifyListeners();

    await _tts.speak(t);
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
