import 'package:flutter/material.dart';
import '../../viewmodel/speech_viewmodel.dart';

class ArticleSpeechWidget extends StatelessWidget {
  final SpeechViewModel speechVM;
  final String content;

  const ArticleSpeechWidget({
    super.key,
    required this.speechVM,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: speechVM,
          builder: (context, _) {
            return Row(
              children: [
                IconButton(
                  icon: Icon(
                    speechVM.isReading && !speechVM.isPaused
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    size: 32,
                    color: const Color(0xFF015E53),
                  ),
                  onPressed: () {
                    if (!speechVM.isReading) {
                      speechVM.startReading(content);
                    } else if (speechVM.isPaused) {
                      speechVM.resumeReading();
                    } else {
                      speechVM.pauseReading();
                    }
                  },
                ),
                if (speechVM.isReading)
                  IconButton(
                    icon: const Icon(Icons.stop_circle, size: 30, color: Colors.grey),
                    onPressed: () => speechVM.stopReading(),
                  ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    speechVM.isReading
                        ? (speechVM.isPaused ? "Đã tạm dừng" : "Đang đọc...")
                        : "Nhấn để đọc bài",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                ),
                // ===== POPUP MENU CHỌN TỐC ĐỘ =====
                PopupMenuButton<double>(
                  tooltip: "Chọn tốc độ đọc",
                  icon: Text(
                    "${speechVM.speechRate}x",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF015E53),
                    ),
                  ),
                  onSelected: (value) {
                    speechVM.setSpeechRate(value);
                  },
                  itemBuilder: (context) {
                    return speechVM.speedLevels
                        .map(
                          (speed) => PopupMenuItem<double>(
                            value: speed,
                            child: Text("${speed}x"),
                          ),
                        )
                        .toList();
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
