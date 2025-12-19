import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SpeechViewModel extends ChangeNotifier {
  final FlutterTts _tts = FlutterTts();

  bool _isReading = false;
  bool _isPaused = false;

  bool get isReading => _isReading;
  bool get isPaused => _isPaused;

  List<String> _paragraphs = [];
  int _currentIndex = 0;

  final List<double> speedLevels = [0.5, 1.0, 1.5];
  double _speechRate = 0.5;
  double get speechRate => _speechRate;

  SpeechViewModel() {
    _initTts();
  }

  // Configure TTS language, rate, volume, and handlers
  void _initTts() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(_speechRate);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    if (defaultTargetPlatform == TargetPlatform.android) {
      await _tts.setEngine("com.google.android.tts");
      await _tts.awaitSpeakCompletion(true);
    }

    _tts.setCompletionHandler(() {
      if (!_isPaused) {
        _currentIndex++;
        _speakNext();
      }
    });

    _tts.setErrorHandler((msg) {
      print("TTS ERROR: $msg");
      _resetState();
    });
  }

  // Remove unnecessary characters and normalize spaces
  String _cleanText(String text) {
    return text
        .replaceAll("\n", " ")
        .replaceAll(RegExp(r'[^\x00-\x7F]'), "")
        .replaceAll(RegExp(r'\s+'), " ")
        .trim();
  }

  // Start reading the given text from the beginning
  Future<void> startReading(String text) async {
    final t = _cleanText(text);
    if (t.isEmpty) return;

    _paragraphs = t.split('. ');
    _currentIndex = 0;
    _isReading = true;
    _isPaused = false;
    notifyListeners();

    _speakNext();
  }

  // Speak the current paragraph
  void _speakNext() async {
    if (_currentIndex >= _paragraphs.length) {
      _resetState();
      return;
    }

    await _tts.setSpeechRate(_speechRate);
    await _tts.speak(_paragraphs[_currentIndex]);
  }

  // Pause reading at the current paragraph
  Future<void> pauseReading() async {
    if (!_isReading) return;

    try {
      await _tts.stop();
    } catch (_) {}

    _isPaused = true;
    notifyListeners();
  }

  // Resume reading from the paused paragraph
  Future<void> resumeReading() async {
    if (!_isPaused || _currentIndex >= _paragraphs.length) return;

    _isPaused = false;
    notifyListeners();
    _speakNext();
  }

  // Stop reading completely and reset state
  Future<void> stopReading() async {
    try {
      await _tts.stop();
    } catch (_) {}

    _resetState();
  }

  // Change reading speed dynamically
  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate;
    await _tts.setSpeechRate(_speechRate);

    if (_isReading && !_isPaused && _currentIndex < _paragraphs.length) {
      await _tts.stop();
      _speakNext();
    }

    notifyListeners();
  }

  // Reset all internal states and counters
  void _resetState() {
    _isReading = false;
    _isPaused = false;
    _paragraphs = [];
    _currentIndex = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }
}
